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

    #DankMaterialShell
    dms = {
      url                         = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows      = "nixpkgs";
    };

    #Dank Plugins
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

    figma-desktop = {
      url                         = "github:NAXLAB/figma-desktop-flake";
      inputs.nixpkgs.follows      = "nixpkgs";
    };

    goodsync = {
      url                         = "github:NAXLAB/goodsync-flake";
      inputs.nixpkgs.follows      = "nixpkgs";
    };

    punktfunk = {
      url                         = "git+https://git.unom.io/unom/punktfunk";
    };
    
  };

  outputs = inputs@  
    { 
      self,
      nixpkgs,
      agenix,
      home-manager,
      quickshell,
      nix-flatpak,
      dms,
      dms-plugin-registry,
      figma-desktop,
      goodsync,
      punktfunk,
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
        ./configuration.nix

        #Packages
        ./packages.nix
        ./nax/flatpak/flatpak.nix
        ./nax/plasticity/plasticity.nix
        ./nax/screenshare.nix
        nix-flatpak.nixosModules.nix-flatpak
        figma-desktop.nixosModules.default
        
        #Hardware
        ./nax/audio.nix
        ./nax/coolercontrol/coolercontrol.nix
        ./nax/openrgb/openrgb.nix
        ./nax/printer.nix

        #Desktop
        ./nax/desktop/niri.nix
        ./nax/desktop/wayland.nix
        ./nax/shortcuts/shortcuts.nix
        ./nax/materialshell/materialshell.nix
        ./nax/gnome/gnome.nix

        #Storage
        goodsync.nixosModules.default 
        ./nax/drives/xdrive.nix
        ./nax/drives/stax.nix
        ./nax/drives/sync.nix

        #Home Manager
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs   = true;
          home-manager.useUserPackages = true;
          home-manager.users.nax       = ./nax/home.nix;  
        }

        #Experiments
        ./nax/labshell/shell.nix

        #Themes
        ./nax/tty/tty.nix
        
      ];
    };
  };
}
