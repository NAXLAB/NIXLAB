{ config,
  pkgs,
  inputs,
  ... 
}:

{

  # Allow unfree packages
  nixpkgs.config.allowUnfree      = true;

  # Nixos Modules
  programs.zsh.enable             = true;
  programs.starship.enable        = true;
  programs.dconf.enable           = true;
  programs.gamemode.enable        = true;
  programs.steam.enable           = true;
  virtualisation.docker.enable    = true;
  hardware.keyboard.qmk.enable    = true;

  #Nix Package manager
  environment.systemPackages      = with pkgs; [
	
  #Apps
  baobab                            # Disk usage (Disk Usage Analyzer)
  bazaar                            # Flatpak App store
  cine                              # Video Player
  crosspipe                         # Audio patch bay 
  dialect                           # Translation Tool
  dopamine                          # Music
  fragments                         # Torrent Client
  gnome-calculator                  # Calculator
  gnome-characters                  # Emojis
  gnome-clocks                      # Clocks
  gnome-console                     # Console
  gnome-text-editor                 # Text Editor
  gnome-tweaks                      # Gnome Tweaks
  iotas                             # Notes
  keypunch                          # Typing Test
  lmstudio                          # Language Model Studio
  loupe                             # Image viewer (modern GNOME image viewer)
  nautilus                          # File Manager
  nicotine-plus                     # soulseek music sharing
  obs-studio                        # Screen Recording
  parabolic                         # Media Downloader
  pdfarranger                       # PDF Editor
  signal-desktop                    # Signal Messages
  snapshot                          # webcam
  ungoogled-chromium                # chrome
  vesktop                           # Discord

  #Design Apps
  blender                           #3D Design
  darktable                         #Photo Editing
  exhibit                           #View 3D Models
  eyedropper                        #Color Picker
  gnome-decoder                     #Create QR Codes
  gnome-font-viewer                 #Fonts
  inkscape                          #2D Design
  krita                             #Raster Design
  penpot-desktop                    #UI/UX Design
  prusa-slicer                      #3D Print Utility
  upscayl                           #Image Upscale

  #Dev Utilities
  fastfetch                         #meme terminal widget    
  gh                                #Github
  git                               #Version Control  
  inspector                         #Gnome App Debugger
  qmk                               #QMK keyboard
  vscodium                          #Dev environment   

  #System Utilities
	curl                              #data transfer utility
  unixtools.netstat                 #Network monitor

  #Themes
  adwaita-icon-theme                #Icon Packs
  capitaine-cursors                 #Cursor Packs
  papirus-icon-theme                #Icon Packs

];

fonts.packages = with pkgs; [

  nerd-fonts.jetbrains-mono
  
];

#Disable Flake Registry from DeterminateSystems
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
