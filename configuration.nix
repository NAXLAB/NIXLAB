# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{

  nix.settings.experimental-features = [ "flakes" "nix-command" ];

  imports =
    [ 
      ./hardware-configuration.nix
      ./fancontrol.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  swapDevices = [{
  device = "/swapfile";
  size = 32768; # 32GB in MB
  }];

  networking.hostName = "zaigomaat"; # Define your hostname.

  #Fan Configuration

  
  #NixOS Services for Niri/Noctalia
  hardware.bluetooth.enable = true;
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;

  # Enable networking
  networking.networkmanager.enable = true;

  # Policy Configuration
  security.polkit.enable = true;  

  # Set your time zone.
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

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    # media-session.enable = true;
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

#SMB share (soon, physical drive connection)
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
    "credentials=/etc/nixos/secrets/smb"
    "uid=1000"
    "gid=1000"
    "x-systemd.requires=network-online.target"
    "x-systemd.stop-timeout=5s"  # force unmount after 5 seconds
  ];
};

systemd.tmpfiles.rules = [

  "d /etc/nixos 0775 nax wheel -"
  "d /mnt/zaigomaat 0755 nax wheel -"

  "d /home/nax/Desktop 0755 nax users -"
  "d /home/nax/Downloads 0755 nax users -"

  "L+ /home/nax/Archives - - - - /mnt/zaigomaat/Archives"
  "L+ /home/nax/Documents - - - - /mnt/zaigomaat/Documents"
  "L+ /home/nax/Fonts - - - - /mnt/zaigomaat/Fonts"
  "L+ /home/nax/Music - - - - /mnt/zaigomaat/Music"
  "L+ /home/nax/Photos - - - - /mnt/zaigomaat/Photos"
  "L+ /home/nax/Torrents - - - - /mnt/zaigomaat/Torrents"

  "L+ /home/nax/.config/noctalia/colors.json - - - - /etc/nixos/nax/noctalia/colors.json"
  "L+ /home/nax/.config/noctalia/settings.json - - - - /etc/nixos/nax/noctalia/settings.json"
  "L+ /home/nax/.config/noctalia/colorschemes - - - - /etc/nixos/nax/noctalia/colorschemes"
];

# Aliases for Terminal Commands
environment.shellAliases = {
nx = "sudo nano /etc/nixos/configuration.nix";
ns = "cd /etc/nixos";
switch = "sudo nixos-rebuild switch --flake /etc/nixos#zaigomaat";
build = "sudo nixos-rebuild build --flake /etc/nixos#zaigomaat";
};

# Install Modules
programs.firefox.enable = true;
programs.niri.enable = true;
programs.zsh.enable = true;
programs.starship.enable = true;
programs.dconf.enable = true;

stylix.enable = true;

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
  waybar # Alternative Bar
	playerctl #media player utility
	mako #Notification Daemon
	xdg-utils #Desktop app rendering utils
	lxqt.lxqt-policykit #Root access policykit
  capitaine-cursors #Cursor Icons
  vscodium #Dev environment
  fastfetch #meme terminal widget
  crosspipe #Audio patch bay
  cifs-utils #smb client utilities
  grim #screenshot
  slurp #select area screenshot
  onlyoffice-desktopeditors #office
  ungoogled-chromium #chrome
  p7zip #Archive Manager
  discord #discord
  fanctl #fan control

];

# Allow unfree packages
nixpkgs.config.allowUnfree = true;

environment.variables = {
  XCURSOR_THEME = "capitaine-cursors";
  XCURSOR_SIZE = "24";
  MOZ_ENABLE_WAYLAND = "1";
};

fonts.packages = with pkgs; [
  nerd-fonts.jetbrains-mono
];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; #test

}
