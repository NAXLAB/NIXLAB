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
  planify                           # Planner & Notes
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
  valuta                            # Currency Translation
  xournalpp                         # Pdf Editor
  nicotine-plus                     # soulseek music sharing
  wine                              #Run Windows apps
  inkscape                          #2D Design 
  krita                             #Raster Design
  obs-studio                        #Screen Recording
  bazaar                            #Flatpak App store
  dopamine                          #Music
  telegram-desktop                  #Messaging
  libreoffice
  

  #Games
  keypunch                          #Typing Test
  binary                            #Number Base Math tool
  fretboard                         #Guitar chords app
  gnome-characters                  #Characters
  concessio                         #file permission toy

  #Design Apps
  upscaler                          #Image Upscale
  upscayl                           #Image Upscale
  gnome-decoder                     #Create QR Codes
  eyedropper                        #Color Picker
  elastic                           #Design Spring Animations
  gnome-font-viewer                 #Fonts
  penpot-desktop                    #UI/UX Design
  (pkgs.callPackage ./nax/figma/figma-desktop.nix { })

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
  solaar                            #Mouse Compatibility

  #System Utilities
  fan2go                            #fan control
	curl                              #data transfer utility
  playerctl                         #media player utility
  unixtools.netstat                 #Network monitor
  libinput                          #input monitoring
  evtest                            #input monitoring

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

}