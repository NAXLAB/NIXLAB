{

  description = "ZaiGoMaat";

  inputs = {

    #Nix Packages
    nixpkgs.url                   = "github:nixos/nixpkgs/nixos-unstable";

    #Agenix
    agenix = {
      url                         = "github:ryantm/agenix";
      inputs.nixpkgs.follows      = "nixpkgs";
    };

    #Dux Shell
    dms = {
      url                         = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows      = "nixpkgs";
    };

    #Dux Plugins
    dms-plugin-registry = {
      url                         = "github:AvengeMedia/dms-plugin-registry";
      inputs.nixpkgs.follows      = "nixpkgs";
    };

    #Home Manager
    home-manager = {
      url                         = "github:nix-community/home-manager";
      inputs.nixpkgs.follows      = "nixpkgs";
    };

    #Quickshell
    quickshell = {
      url                         = "git+https://git.outfoxxed.me/quickshell/quickshell/";
      inputs.nixpkgs.follows      = "nixpkgs";
    };

    #Flatpak
    nix-flatpak = {
      url                         = "github:gmodena/nix-flatpak/?ref=latest";
    };

    #Figma
    figma-desktop = {
      url                         = "github:NAXLAB/figma-desktop-flake";
      inputs.nixpkgs.follows      = "nixpkgs";
    };

    #Goodsync
    goodsync = {
      url                         = "github:NAXLAB/goodsync-flake";
      inputs.nixpkgs.follows      = "nixpkgs";
    };

    #Musnix Low latency tools
     musnix  = { 
      url                         = "github:musnix/musnix"; 
      inputs.nixpkgs.follows      = "nixpkgs";
    };
    
    #PhotoCraft
    photocraft = {
      url                         = "github:NAXLAB/photocraft-flake";
      inputs.nixpkgs.follows      = "nixpkgs";
    };

    #Solidcraft
    solidcraft = {
      url                         = "github:tangency-labs/solidcraft";
      inputs.nixpkgs.follows      = "nixpkgs";
    };
    
    #VectorCraft
    vectorcraft = {
      url                         = "github:NAXLAB/vectorcraft-flake";
      inputs.nixpkgs.follows      = "nixpkgs";
    };

    #EffectCraft
    effectcraft = {
      url                         = "github:NAXLAB/effectcraft-flake";
      inputs.nixpkgs.follows      = "nixpkgs";
    };


    #FigCraft
    figcraft = {
      url                         = "github:NAXLAB/figcraft-flake";
      inputs.nixpkgs.follows      = "nixpkgs";
    };

    #Adwair Icons
    adwair = {
      url                         = "github:NAXLAB/adwair-flake";
      inputs.nixpkgs.follows      = "nixpkgs";
    };

    #MTSync
    mtsync = {
      url                         = "github:NAXLAB/mtsync-flake";
      inputs.nixpkgs.follows      = "nixpkgs";
    };

    #AppGlider
    appglider = {
      url                         = "github:Vyrnexis/AppGlider";
      inputs.nixpkgs.follows      = "nixpkgs";
    };

  };

  outputs = inputs@  
    { 
      self,
      nixpkgs,
      home-manager,
      nix-flatpak,
      figma-desktop,
      adwair,
      ...
    }:
  
  {
    nixosConfigurations.zaigomaat = nixpkgs.lib.nixosSystem{
      
      specialArgs = 
      {
        inherit inputs;
        colors = import ./nax/themes/base16.nix;
      };

      modules = [

        #System
        ./hardware-configuration.nix
        ./boot.nix
        ./configuration.nix
        #./nax/screenshare.nix
        ./nax/networking.nix
        ./nax/user.nix
        ./nax/shell.nix
        inputs.agenix.nixosModules.default

        #Packages
        ./nax/packages/packages.nix
        figma-desktop.nixosModules.default
        nix-flatpak.nixosModules.nix-flatpak
        
        #Hardware
        ./nax/hardware.nix
        ./nax/audio.nix
        ./nax/coolercontrol/coolercontrol.nix
        ./nax/openrgb/openrgb.nix
        ./nax/printer.nix
        ./nax/gpu.nix

        #Desktop
        ./nax/desktop/desktop.nix
        ./nax/shortcuts/shortcuts.nix
        ./nax/materialshell/materialshell.nix
        ./nax/gnome/gnome.nix

        #Storage
        ./nax/drives/stax.nix
        ./nax/drives/sync.nix
        ./nax/drives/xdrive.nix

        #Home Manager
        home-manager.nixosModules.home-manager
        {
          home-manager.users.nax       = ./nax/home.nix; 
          home-manager.useGlobalPkgs   = true;
          home-manager.useUserPackages = true; 
        }

        #Experiments
        ./nax/labshell/shell.nix

        #Themes
        ./nax/tty.nix
        adwair.nixosModules.default
        
      ];
    };
  };
}
