# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  

  swapDevices = [{
  device = "/swapfile";
  size = 32768; # 32GB in MB
  }];

  networking.hostName = "zaigomaat"; # Define your hostname.

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  
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
  ];
};

systemd.settings.Manager = {
  DefaultTimeoutStopSec = "10s";
};

systemd.tmpfiles.rules = [
  "d /etc/nixos 0755 nax wheel -"
  "d /mnt/zaigomaat 0755 nax wheel -"
  "d /home/nax/Desktop 0755 nax users -"
  "d /home/nax/Downloads 0755 nax users -"

  "L /home/nax/Archives - - - - /mnt/zaigomaat/Archives"
  "L /home/nax/Documents - - - - /mnt/zaigomaat/Documents"
  "L /home/nax/Fonts - - - - /mnt/zaigomaat/Fonts"
  "L /home/nax/Music - - - - /mnt/zaigomaat/Music"
  "L /home/nax/Photos - - - - /mnt/zaigomaat/Photos"
  "L /home/nax/Torrents - - - - /mnt/zaigomaat/Torrents"

  "L /home/nax/.config/noctalia/colors.json - - - - /etc/nixos/nax/noctalia/colors.json"
  "L /home/nax/.config/noctalia/settings.json - - - - /etc/nixos/nax/noctalia/settings.json"
  "L /home/nax/.config/noctalia/colorschemes - - - - /etc/nixos/nax/noctalia/colorschemes"
];

environment.shellAliases = {
nx = "sudo nano /etc/nixos/configuration.nix";
ns = "cd /etc/nixos";
cfg = "cd /home/nax/.config";
switch = "sudo nixos-rebuild switch --flake /etc/nixos#zaigomaat";
build = "sudo nixos-rebuild build --flake /etc/nixos#zaigomaat";

};

# Allow unfree packages
nixpkgs.config.allowUnfree = true;

# Display and Login Options
services.displayManager.sddm = {
  enable = true;
  wayland.enable = true;
  settings = {
    Theme = {
      CursorTheme = "capitaine-cursors";
       CursorSize = "24";
     };
   };
};

#Gnome Services as a fallback
services.displayManager.defaultSession = "niri";
services.desktopManager.gnome.enable = true;
services.gnome.core-apps.enable = false;
services.gnome.core-developer-tools.enable = false;
services.gnome.games.enable = false;
environment.gnome.excludePackages = with pkgs; [ gnome-tour gnome-user-docs ];

# Install Modules
programs.firefox.enable = true;
programs.niri.enable = true;
programs.zsh.enable = true;
programs.starship.enable = true;
programs.dconf.enable = true;

  #Nix Package manager
  environment.systemPackages = with pkgs; [
	git #version control
	curl #data transfer utility
	xwayland-satellite #Wayland integration
	wl-clipboard  #Clipboard 
	cliphist #Clipboard history
	nwg-look #GTK settings 
	swayidle #idle screen
	swaylock #lockscreen
	playerctl #media player utility
	mako #Notification Daemon
	xdg-utils #Desktop app rendering utils
	lxqt.lxqt-policykit #Root access policykit
  capitaine-cursors #Cursor Icons
  vscodium #Dev environment
  fastfetch #meme terminal widget
  crosspipe #Audo patch bay
  cifs-utils #smb client utilities
  samba #smb client
  grim #screenshot
  slurp #select area screenshot
  discord #Discord

  # GNOME Apps
  nautilus
  gnome-console      # Console
  gnome-calculator   # Calculator
  gnome-control-center # Settings - probably already comes with gnome
  evince             # Document viewer
  resources          # Resources (system monitor)
  gnome-text-editor  # Text editor
  gnome-font-viewer   # Fonts
  gnome-characters    # Characters
  baobab              # Disk usage (Disk Usage Analyzer)
  loupe               # Image viewer (modern GNOME image viewer)
  gnome-music         # Music

];

environment.variables = {
  XCURSOR_THEME = "capitaine-cursors";
  XCURSOR_SIZE = "24";
  MOZ_ENABLE_WAYLAND = "1";
};

fonts.packages = with pkgs; [
  nerd-fonts.jetbrains-mono
];

#Disable Automatic Home Folders
environment.etc."xdg/user-dirs.conf".text = ''
  enabled=False
'';

#Hjem
hjem.users.nax = {
  enable = true;
  directory = config.users.users.nax.home;
  files = {

    ".config/user-dirs.dirs".source = ./nax/xdg/user-dirs.dirs;

    ".gitconfig".source = ./nax/git/config;

    ".config/niri/config.kdl".source = ./nax/niri/config.kdl;
    
    #".config/noctalia/settings.json".source = ./nax/noctalia/settings.json;
    #".config/noctalia/colors.json".source = ./nax/noctalia/colors.json;
    #".config/noctalia/colorschemes".source = ./nax/noctalia/colorschemes;
    
    ".zshrc".source = ./nax/zsh/zshrc;

    ".config/fastfetch/config.jsonc".source = ./nax/fastfetch/config.jsonc;

  };
};

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.


  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; #test

}
