{ config, pkgs, inputs,... }:

{

nix.settings.experimental-features = [ "flakes" "nix-command" ];

  imports =
    [ 
      ./hardware-configuration.nix
    ];

  #Motherboard Kernel Modules
  boot.kernelModules = [
    "nct6775" 
    "nct6687"
  ];

  boot.extraModulePackages = [
    config.boot.kernelPackages.nct6687d
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  #Swapfile
  swapDevices = [
    {
      device = "/swapfile";
      size = 32768; # 32GB in MB
    }
  ];

  #System & Hardware Services
  services.power-profiles-daemon.enable = true;
  hardware.bluetooth.enable = true;
  services.upower.enable = true;
  services.printing.enable = true;

  #Audio Services
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  
  #Allow Electron Apps to be managed by Niri
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Enable networking
  networking.networkmanager.enable = true;
  networking.hostName = "zaigomaat";
  services.openssh.enable = true;
  
  # Policy Configuration
  security.polkit.enable = true;  

 #Time Zone
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nax = {
    shell = pkgs.zsh;
    isNormalUser = true;
    description = "Nax Lab";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    ];
  };

  #SMB share
  fileSystems."/mnt/zaigomaat" = {
    device = "//192.168.88.202/zaigomaat";
    fsType = "cifs";
    options = [
      "noauto"
      "x-systemd.automount"
      "x-systemd.idle-timeout=60"
      "x-systemd.device-timeout=5s"
      "x-systemd.mount-timeout=5s"
      "_netdev"
      "credentials=/run/agenix/smb"
      "uid=1000"
      "gid=1000"
      "x-systemd.requires=network-online.target"
      "x-systemd.stop-timeout=5s"  # force unmount after 5 seconds
    ];
  };

  age.secrets.smb = {
    file = ./secrets/smb.age;
    mode = "400";
  };

  #File System Config
  systemd.tmpfiles.rules = [

  #etc/nixos owned by nax
  "Z /etc/nixos - nax wheel - -"

  #Mount ZaigoMaat SMB share and give nax access
  "d /mnt/zaigomaat 0755 nax wheel -"

  #Mount X Drive 
  "d /mnt/xdrive 0755 nax users -"
  "d /mnt/xdrive-fuse 0755 root root -"

  #Create desktop folders manually
  "d /home/nax/Desktop 0755 nax users -"
  "d /home/nax/Downloads 0755 nax users -"
  "L+ /home/nax/Archives - - - - /run/media/nax/X DRIVE/Archives"
  "L+ /home/nax/Documents - - - - /run/media/nax/X DRIVE/Documents"
  "L+ /home/nax/Fonts - - - - /run/media/nax/X DRIVE/Fonts"
  "L+ /home/nax/Music - - - - /run/media/nax/X DRIVE/Music"
  "L+ /home/nax/Photos - - - - /run/media/nax/X DRIVE/Photos"
  "L+ /home/nax/Torrents - - - - /run/media/nax/X DRIVE/Torrents"
];

# Aliases for Terminal Commands
environment.shellAliases = {
switch = "sudo nixos-rebuild switch --flake /etc/nixos#zaigomaat";
build = "sudo nixos-rebuild build --flake /etc/nixos#zaigomaat";
};


# Allow unfree packages
nixpkgs.config.allowUnfree = true;

# Install Modules
programs.firefox.enable = true;
programs.niri.enable = true;
programs.zsh.enable = true;
programs.starship.enable = true;
programs.dconf.enable = true;
programs.coolercontrol.enable = true;



  #Nix Package manager
  environment.systemPackages = with pkgs; [
	git #version control
	curl #data transfer utility
  samba #smb client
	xwayland-satellite #Wayland integration
	wl-clipboard  #Clipboard 
	cliphist #Clipboard history
	swayidle #idle screen
	swaylock #lockscreen
	playerctl #media player utility
	mako #Notification Daemon
	xdg-utils #Desktop app rendering utils
  capitaine-cursors #Cursor Icons
  vscodium #Dev environment
  fastfetch #meme terminal widget
  crosspipe #Audio patch bay
  cifs-utils #smb client utilities
  grim #screenshot
  slurp #select area screenshot
  ungoogled-chromium #chrome
  p7zip #Archive Manager
  fan2go #fan control
  openrgb #rgb control
  vesktop #Discord
  papirus-icon-theme #Icon Packs
  la-capitaine-icon-theme
  dislocker #Bitlocker encryption manager
  gapless #Music
  signal-desktop #Signal Messages
  freecad #Design
  impression #Bootable Media Utility
  mission-center #System Monitoring
  parabolic #Media Downloader
  upscaler #Image Upscale
  upscayl #Image Upscale
  planify #Planner & Notes
  cine #Video Player
  newsflash #news
  concessio #file permissions

  #recordbox is broken rn but an update might fix it

  inputs.agenix.packages.${pkgs.system}.default
  #lxqt.lxqt-policykit #Root access policykit
  polkit_gnome #Gnome Polkit
];

environment.variables = {
  XCURSOR_THEME = "capitaine-cursors";
  XCURSOR_SIZE = "24";
  MOZ_ENABLE_WAYLAND = "1";
};

fonts.packages = with pkgs; [
  nerd-fonts.jetbrains-mono
  nerd-fonts.iosevka
  fira-code
  geist-font

];

system.stateVersion = "25.11"; #test

}
