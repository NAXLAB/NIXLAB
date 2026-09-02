  { config, pkgs, inputs, ... }:

{
  
  #Nix Package manager
  environment.systemPackages = with pkgs; [
	
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
  citations                         # Bibliography
  gnome-clocks                      # Clocks
  exercise-timer                    # Timer App
  fragments                         # Torrent Client
  iotas                             # Notes
  nicotine-plus                     # soulseek music sharing
  obs-studio                        #Screen Recording
  bazaar                            #Flatpak App store
  dopamine                          #Music
  telegram-desktop                  #Messaging
  libreoffice                       #Office Suite
  gelly                             #Jellyfin Music Client
  flowtime                          #Timer
  bookup                            #Markdown Notes
  pdfarranger                       #PDF Editor
  gnome-text-editor                 #Text Editor
  
  #Games
  keypunch                          #Typing Test
  binary                            #Number Base Math tool
  gnome-characters                  #Characters
  concessio                         #file permission toy

  #Design Apps
  upscaler                          #Image Upscale
  upscayl                           #Image Upscale
  gnome-decoder                     #Create QR Codes
  eyedropper                        #Color Picker
  gnome-font-viewer                 #Fonts
  penpot-desktop                    #UI/UX Design
  prusa-slicer                      #3D Print Utility
  exhibit                           #View 3D Models
  inkscape                          #2D Design 
  krita                             #Raster Design
  (pkgs.callPackage ./nax/figma/figma-desktop.nix { })

  #Dev Utilities
  git                               #Version Control
  vscodium                          #Dev environment
  fastfetch                         #meme terminal widget         
  docker                            #container host
  docker-client                     #container host    
  github-desktop                    #git repository management
  libnotify                         #Notification Test Utility
  lufus                             #Format Drives
  qmk                               #Keyboard Programming
  inspector                         #Gnome App Debugger
  
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
  solaar                            #Mouse Compatibility
  sunshine                          #Remote Desktop Host

  #System Utilities
	curl                              #data transfer utility
  unixtools.netstat                 #Network monitor
  inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default #Secret Management

  #Themes
  papirus-icon-theme                #Icon Packs
  adwaita-icon-theme                #Icon Packs
  capitaine-cursors                 #Cursor Packs

];

# Nixos Modules
programs.firefox.enable = true;
programs.zsh.enable = true;
programs.starship.enable = true;
programs.dconf.enable = true;
programs.kdeconnect.enable = true;

programs.gamemode.enable = true;
programs.steam = {
  enable = true;
}; 

programs.appimage = {
  enable = true;
  binfmt = true;  # makes AppImages run directly without appimage-run prefix
};

fonts.packages = with pkgs; [

  nerd-fonts.jetbrains-mono
  nerd-fonts.iosevka
  fira-code
  geist-font
  iosevka

];

}