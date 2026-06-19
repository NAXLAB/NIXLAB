{ config, pkgs, inputs, ... }:

{

  nix.settings.experimental-features = [ "flakes" "nix-command" ];

  # Bootloader.
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
        size = 32768; # 32GB in MB
      }
    ];

  #System & Hardware Services
  services.power-profiles-daemon.enable = true;
  hardware.bluetooth.enable             = false;
  services.upower.enable                = true;
  services.printing.enable              = false;

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

   #Miscellaneous desktop environment dependencies
  environment.variables = 
    {
      XCURSOR_THEME = "capitaine-cursors";
      XCURSOR_SIZE = "24";
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
          "networkmanager"
          "wheel"
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
  "L+ /home/nax/.local/share/fonts - - - - /run/media/nax/xdrive/Fonts"
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
	
  #Apps
  nautilus                          # File Manager
  gnome-console                     # Console
  gnome-calculator                  # Calculator
  baobab                            # Disk usage (Disk Usage Analyzer)
  ungoogled-chromium                # chrome
  planify                           # Planner & Notes
  cine                              # Video Player
  vesktop                           # Discord
  parabolic                         # Media Downloader
  crosspipe                         # Audio patch bay
  signal-desktop                    # Signal Messages
  nocturne                          # Music
  loupe                             # Image viewer (modern GNOME image viewer)
  dialect                           # Translation Tool
  lmstudio                          # Language Model Studio
  citations                         # Bibliography
  gnome-clocks                      # Clocks
  exercise-timer                    # Timer App
  fragments                         # Torrent Client
  iotas                             # Notes
  valuta                            # Currency Translation
  pdfstudio2024                     # df Reader
  pdfstudioviewer                   # Pdf Reader

  #Games
  keypunch                          #Typing Test
  binary                            #Number Base Math tool
  gnome-graphs                      #Create graphs
  fretboard                         #Guitar chords app
  gnome-characters                  #Characters
  concessio                         #file permission toy

  #Design Apps
  upscaler                          #Image Upscale
  upscayl                           #Image Upscale
  emblem                            #App icon maker
  gnome-decoder                     #Create QR Codes
  eyedropper                        #Color Picker
  elastic                           #Design Spring Animations
  gnome-font-viewer                 #Fonts
  figma-agent                       #Figma Font Helper
  penpot-desktop                    #UI/UX Design

  #Dev Utilities
  git                               #Version Control
  vscodium                          #Dev environment
  fastfetch                         #meme terminal widget    
  quickshell                        #App and Widget Maker      
  docker                            #container host
  docker-client                     #container host    
  github-desktop                    #git repository management
  libnotify                         #Notification Test Utility

  #Desktop Utilities
  xwayland-satellite                #Wayland integration
  xdg-desktop-portal-gnome          #App Compatibility portal
  xdg-utils                         #Desktop app rendering utils
  refine                            #More Gnome Tweaks
  walker                            #Launcher
  wl-clipboard                      #Clipboard 
  cliphist                          #Clipboard history
  grim                              #screenshot
  slurp                             #select area screenshot
  gvfs                              #Gnome Filesystem Compatibility

  #System Utilities
  fan2go                            #fan control
  openrgb                           #rgb control
	curl                              #data transfer utility
  grsync                            #Rsync GUI wrapper
  rsync                             #File Sync
  playerctl                         #media player utility
  syncthing                         #FileSync
  inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default #Secret Management

  #Themes
  papirus-icon-theme                #Icon Packs
  la-capitaine-icon-theme           #Icon Packs
  whitesur-icon-theme               #Icon Packs
  adwaita-icon-theme                #Icon Packs
  capitaine-cursors                 #Cursor Packs

];

fonts.packages = with pkgs; [

  nerd-fonts.jetbrains-mono
  nerd-fonts.iosevka
  fira-code
  geist-font

];

#Do not change this number for reasons I don't understand.
system.stateVersion = "25.11";

}
