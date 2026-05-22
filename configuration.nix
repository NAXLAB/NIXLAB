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
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
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

  systemd.tmpfiles.rules = [
  "d /etc/nixos 0755 nax wheel -"
];

  environment.shellAliases = {
  nx = "sudo nano /etc/nixos/configuration.nix";
  ns = "cd /etc/nixos";
  cfg = "cd /home/nax/.config"; 
  switch = "sudo nixos-rebuild switch --flake /etc/nixos#zaigomaat";
  build = "sudo nixos-rebuild build --flake /etc/nixos#zaigomaat";

  };

  # Install Modules
  programs.firefox.enable = true;
  programs.niri.enable = true;
  programs.zsh.enable = true;
  programs.dconf.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
	git #version control
  git-cola #git manager
	curl #data transfer utility
	xwayland-satellite #Wayland integration
	wl-clipboard  #Clipboard 
	cliphist #Clipboard history
	grim #Screenshot 
	slurp #Select region screenshot
	nwg-look #GTK settings 
	swayidle #idle screen
	swaylock #lockscreen
	playerctl #media player utility
	mako #Notification Daemon
	xdg-utils #Desktop app rendering utils
	lxqt.lxqt-policykit #Root access policykit
  capitaine-cursors #Cursor Icons
  nemo #File Manager
  kitty #Terminal
  vscodium #Dev environment

  nano # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.

  ];

environment.variables = {
  XCURSOR_THEME = "capitaine-cursors";
  XCURSOR_SIZE = "24";
  MOZ_ENABLE_WAYLAND = "1";
};

fonts.packages = with pkgs; [
  nerd-fonts.jetbrains-mono
];


hjem.users.nax = {
  directory = config.users.users.nax.home;
  files = {

    ".gitconfig".source = ./nax/git/config;

    ".config/niri/config.kdl".source = ./nax/niri/config.kdl;
    
    ".config/noctalia/settings.json".source = ./nax/noctalia/settings.json;
    ".config/noctalia/colors.json".source = ./nax/noctalia/colors.json;
    ".config/noctalia/colorschemes".source = ./nax/noctalia/colorschemes;

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
