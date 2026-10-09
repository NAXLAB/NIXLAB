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

     musnix  = { 
      url                         = "github:musnix/musnix"; 
      inputs.nixpkgs.follows      = "nixpkgs";
    };

    photocraft = {
      url                         = "github:NAXLAB/photocraft-flake";
      inputs.nixpkgs.follows      = "nixpkgs";
    };

    # flake.nix
    solvecraft = {
      url                         = "github:NAXLAB/solvecraft-flake";
      inputs.nixpkgs.follows      = "nixpkgs";
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
      musnix,
      photocraft,
      solvecraft,
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
        ./nax/screenshare.nix
        ./nax/networking.nix
        ./nax/user.nix
        ./nax/shell/shell.nix
        inputs.agenix.nixosModules.default

        #Packages
        ./nax/packages.nix
        ./nax/flatpak/flatpak.nix
        ./nax/plasticity/plasticity.nix
        ./nax/mixxx/mixxx.nix
        nix-flatpak.nixosModules.nix-flatpak
        figma-desktop.nixosModules.default
        
        #Hardware
        ./nax/hardware.nix
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
        ./nax/drives/xdrive.nix
        ./nax/drives/stax.nix
        ./nax/drives/sync.nix

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
        ./nax/tty/tty.nix
        
      ];
    };
  };
}
