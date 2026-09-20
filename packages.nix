  { config, pkgs, inputs, ... }:

{

  # Allow unfree packages
  nixpkgs.config.allowUnfree    = true;

  # Nixos Modules
  programs.firefox.enable       = true;
  programs.zsh.enable           = true;
  programs.starship.enable      = true;
  programs.dconf.enable         = true;
  programs.gamemode.enable      = true;
  programs.steam.enable         = true;
  virtualisation.docker.enable  = true;
  hardware.keyboard.qmk.enable  = true;
  

  #Nix Package manager
  environment.systemPackages    = with pkgs; [
	
  #Apps
  nautilus                          # File Manager
  gnome-console                     # Console
  gnome-calculator                  # Calculator
  baobab                            # Disk usage (Disk Usage Analyzer)
  ungoogled-chromium                # chrome
  cine                              # Video Player
  vesktop                           # Discord
  parabolic                         # Media Downloader
  crosspipe                         # Audio patch bay
  signal-desktop                    # Signal Messages
  loupe                             # Image viewer (modern GNOME image viewer)
  dialect                           # Translation Tool
  lmstudio                          # Language Model Studio
  gnome-clocks                      # Clocks
  fragments                         # Torrent Client
  iotas                             # Notes
  nicotine-plus                     # soulseek music sharing
  obs-studio                        # Screen Recording
  bazaar                            # Flatpak App store
  dopamine                          # Music
  telegram-desktop                  # Messaging
  libreoffice                       # Office Suite
  pdfarranger                       # PDF Editor
  gnome-text-editor                 # Text Editor
  snapshot                          # webcam
  keypunch                          # Typing Test
  gnome-characters                  # Emojis
  gnome-tweaks                      # Gnome Tweaks

  #Design Apps
  upscayl                           #Image Upscale
  gnome-decoder                     #Create QR Codes
  eyedropper                        #Color Picker
  gnome-font-viewer                 #Fonts
  penpot-desktop                    #UI/UX Design
  prusa-slicer                      #3D Print Utility
  exhibit                           #View 3D Models
  inkscape                          #2D Design 
  krita                             #Raster Design
  blender                           #3D Design
  darktable                         #Photo Editing

  #Dev Utilities
  git                               #Version Control
  vscodium                          #Dev environment
  fastfetch                         #meme terminal widget         
  inspector                         #Gnome App Debugger
  qmk                               #QMK keyboard
  
  #Desktop Utilities
  xwayland-satellite                #Wayland integration
  xdg-desktop-portal-gnome          #App Compatibility portal
  xdg-utils                         #Desktop app rendering utils
  refine                            #More Gnome Tweaks
  wl-clipboard                      #Clipboard 
  cliphist                          #Clipboard history
  grim                              #screenshot
  slurp                             #select area screenshot
  gvfs                              #Gnome Filesystem Compatibility
  solaar                            #Mouse Compatibility

  #System Utilities
	curl                              #data transfer utility
  unixtools.netstat                 #Network monitor
  inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default #Secret Management

  #Themes
  papirus-icon-theme                #Icon Packs
  adwaita-icon-theme                #Icon Packs
  capitaine-cursors                 #Cursor Packs

];

fonts.packages = with pkgs; [

  nerd-fonts.jetbrains-mono
  nerd-fonts.iosevka
  fira-code
  geist-font

];

nix.settings.flake-registry = pkgs.writeTextFile {
  name = "registry.json"; 
    text = ''
      {
        "version": 2,
        "flakes": [
        {
          "from": {
            "id": "nixpkgs",
            "type": "indirect"
          },
          "to": {
            "type": "path",
            "path": "${pkgs.path}"
          }
        }
      ]
    }
  '';
};

}