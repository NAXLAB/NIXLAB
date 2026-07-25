{ config, pkgs, inputs, ... }:

{

  #Need to figure this out. I think DMS needed it to compile.
  nixpkgs.config.permittedInsecurePackages = [
    "pnpm-10.29.2"
    "electron-40.10.5"
  ];

  nix.settings.experimental-features = [ "flakes" "nix-command" ];

  # Bootloader.
  boot.loader = 
    {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
    };

  boot.kernelPackages = pkgs.linuxPackages_latest;

  #Swapfile
  swapDevices = 
    [
      {
        device = "/swapfile";
        size = 32000; # 64GB in MB
      }
    ];

  #System & Hardware Services
  services.power-profiles-daemon.enable = true;
  hardware.bluetooth.enable             = false;
  services.upower.enable                = true;

  services.printing = {
    enable = true;
    drivers = [ pkgs.brlaser ];
  };



  hardware.printers = {
    ensurePrinters = [
      {
        name = "Brother-HL-L2300D";
        deviceUri = "usb://Brother/HL-L2300D%20series?serial=U63878J5N186821";
        model = "drv:///brlaser.drv/brl2300d.ppd";
      }
    ];
    ensureDefaultPrinter = "Brother-HL-L2300D";
  };

  

  #Audio Services
  services.pulseaudio.enable  = false;
  security.rtkit.enable       = true;
  services.pipewire = 
    {
      enable = true;
      pulse.enable = true;
      alsa = 
        {
          enable = true;
          support32Bit = true;
        };
    };

  #Enable networking
  networking.networkmanager.enable  = true;
  networking.hostName               = "zaigomaat";
  services.openssh.enable           = true;
  
  #Policy Configuration
  security.polkit.enable = true;  

environment.etc."libinput/local-overrides.quirks".text = ''
  [Logitech G502 Wheel Quirk]
  MatchVendor=0x046D
  MatchProduct=0x407F
  MatchUdevType=mouse
  AttrEventCode=-REL_WHEEL_HI_RES;-REL_HWHEEL_HI_RES;
'';

  #Miscellaneous desktop environment dependencies
  environment.variables = 
    {
      MOZ_ENABLE_WAYLAND = "1";
    };

  #Time Zone
  time.timeZone = "America/New_York";

  #Select internationalisation properties.
  i18n.defaultLocale        = "en_US.UTF-8";
  i18n.extraLocaleSettings  = 
    {
      LC_ADDRESS        = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT    = "en_US.UTF-8";
      LC_MONETARY       = "en_US.UTF-8";
      LC_NAME           = "en_US.UTF-8";
      LC_NUMERIC        = "en_US.UTF-8";
      LC_PAPER          = "en_US.UTF-8";
      LC_TELEPHONE      = "en_US.UTF-8";
      LC_TIME           = "en_US.UTF-8";
    };

  users.users.nax = 
    {
      shell         = pkgs.zsh;
      isNormalUser  = true;
      description   = "Nax Lab";
      packages      = with pkgs; [];
      extraGroups   = 
        [ 
          "i2c"
          "networkmanager"
          "wheel"
          "libvirt" 
          "qemu-libvirtd"
        ];
    };

  #File System Config
  systemd.tmpfiles.rules = [

  #etc/nixos owned by nax
  "Z /etc/nixos - nax wheel - -"

  #Mount ZaigoMaat SMB share
  "d /mnt/zaigomaat 0755 nax wheel -"

  #Create desktop folders manually
  "d /home/nax/Desktop 0755 nax users -"
  "d /home/nax/Downloads 0755 nax users -"

  #Symlink Desktop folders to X Drive
  "L+ /home/nax/Archives - - - - /mnt/xdrive/Archives"
  "L+ /home/nax/Documents - - - - /mnt/xdrive/Documents"
  "L+ /home/nax/Fonts - - - - /mnt/xdrive/Fonts"
  "L+ /home/nax/Music - - - - /mnt/xdrive/Music"
  "L+ /home/nax/Pictures - - - - /mnt/xdrive/Photos"
  "L+ /home/nax/Torrents - - - - /mnt/xdrive/Torrents"

  #Connect font folder to X Drive
  "L+ /home/nax/.local/share/fonts - - - - /mnt/xdrive/Fonts"
];

# Aliases for Terminal Commands
environment.shellAliases = {
switch = "sudo nixos-rebuild switch --flake /etc/nixos#zaigomaat";
build = "sudo nixos-rebuild build --flake /etc/nixos#zaigomaat";

pkgs = "sudo nixos-rebuild switch --upgrade";
flake = "sudo nix flake update"; 
};

# Allow unfree packages
nixpkgs.config.allowUnfree = true;

# Install Modules
programs.firefox.enable = true;
programs.zsh.enable = true;
programs.starship.enable = true;
programs.dconf.enable = true;
programs.coolercontrol.enable = true;


#Install OpenRGB
services.hardware.openrgb = {
  enable = true;
  motherboard = "amd";
};

systemd.user.services.openrgb-profile = {
  description = "Load OpenRGB profile";
  wantedBy = [ "graphical-session.target" ];
  after = [ "graphical-session.target" ];
  serviceConfig = {
    Type = "oneshot";
    ExecStart = "${pkgs.openrgb}/bin/openrgb --profile \"naxlab\"";
    RemainAfterExit = true;
  };
};

programs.appimage = {
  enable = true;
  binfmt = true;  # makes AppImages run directly without appimage-run prefix
};

programs.gamemode.enable = true;

programs.steam = {
  enable = true;
};

programs.kdeconnect.enable = true;



#Do not change this number for reasons I don't understand.
system.stateVersion = "25.11";

}
