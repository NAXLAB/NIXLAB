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

  #Custom Packages
  imports = [
    ./flatpak.nix
    ./mixxx.nix
    ./plasticity.nix
  ];

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
  gnome-calendar                    # Calendar
  gnome-characters                  # Emojis
  gnome-clocks                      # Clocks
  gnome-console                     # Console
  gnome-text-editor                 # Text Editor
  gnome-tweaks                      # Gnome Tweaks
  iotas                             # Notes
  keypunch                          # Typing Test
  libreoffice                       # Office Suite
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
  eyedropper                        #Color Picker
  gnome-decoder                     #Create QR Codes
  gnome-font-viewer                 #Fonts
  inkscape                          #2D Design
  penpot-desktop                    #UI/UX Design
  prusa-slicer                      #3D Print Utility
  upscayl                           #Image Upscale
  inputs.solidcraft.packages.${pkgs.stdenv.hostPlatform.system}.default  #3D Modelling
  inputs.photocraft.packages.${pkgs.stdenv.hostPlatform.system}.default  #Photoshop
  inputs.vectorcraft.packages.${pkgs.stdenv.hostPlatform.system}.default #Illustrator
  inputs.figcraft.packages.${pkgs.stdenv.hostPlatform.system}.default    #Figma


  #Dev Utilities
  fastfetch                         #meme terminal widget    
  gh                                #Github
  git                               #Version Control  
  inspector                         #Gnome App Debugger
  qmk                               #QMK keyboard
  vscodium                          #Dev environment   
  cargo                             #Cargo
  nodejs_24                         #Node

  #System Utilities
	curl                              #data transfer utility
  unixtools.netstat                 #Network monitor
  mission-center                    #Task Manager
  inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default

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
