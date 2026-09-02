{ config, pkgs, inputs, ... }:

{

  #Enable flakes & nix-command
  nix.settings.experimental-features = [ "flakes" "nix-command" ];

  boot.kernelPackages = pkgs.linuxPackages_7_1;

  services.journald.storage = "persistent";

  # Bootloader
  boot.loader = 
    {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
    };

  #Swapfile
  swapDevices = 
    [
      {
        device = "/swapfile";
        size = 32000; # 32GB in MB
      }
    ];

  nix.gc = {
    automatic   = true;
    dates       = "weekly";
    options     = "--delete-older-than 7d";
  };

  #System & Hardware Services
  systemd.services.systemd-rfkill.enable = false;
  services.power-profiles-daemon.enable = true;
  hardware.bluetooth.enable             = false;
  services.upower.enable                = true;


  #Printing
  services.printing = {
    enable = true;
    drivers = [ pkgs.brlaser ];
    browsed.enable = false;
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

  #Audio
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

  #Networking
  networking.networkmanager.enable  = true;
  services.openssh.enable           = true;
  networking.hostName               = "zaigomaat";
  
  #Mouse Compatibility
  environment.etc."libinput/local-overrides.quirks".text = ''
    [Logitech G502 Wheel Quirk]
    MatchVendor=0x046D
    MatchProduct=0x407F
    MatchUdevType=mouse
    AttrEventCode=-REL_WHEEL_HI_RES;-REL_HWHEEL_HI_RES;
  '';

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

  #User Profile
  users.users.nax = 
    {
      shell         = pkgs.zsh;
      isNormalUser  = true;
      description   = "Nax Lab";
      #packages      = with pkgs; [];
      extraGroups   = 
        [ 
          "lab"
          "i2c"
          "networkmanager"
          "wheel"
          "libvirt" 
          "qemu-libvirtd"
          "audio"
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
garbage = "sudo nix-collect-garbage -d";

};

#Policy Kit
security.polkit.enable = true;  

# Allow unfree packages
nixpkgs.config.allowUnfree = true;

#Miscellaneous desktop environment dependencies
environment.variables = 
  {
    MOZ_ENABLE_WAYLAND = "1";
  };

#Do not change this number for reasons I don't understand.
system.stateVersion = "25.11";

}
