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
      url                         = "github:AvengeMedia/DankMaterialShell/stable";
      inputs.nixpkgs.follows      = "nixpkgs";
    };

    #Home Manager
    home-manager = {
      url                         = "github:nix-community/home-manager";
      inputs.nixpkgs.follows      = "nixpkgs";
    };

    #Quickshell
    quickshell = {
      url                         = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows      = "nixpkgs";
    };

    #Flatpak
    nix-flatpak = {
      url                         = "github:gmodena/nix-flatpak/?ref=latest";
    };
    
    #Nautilus My Computer
    nautilus-my-computer = {
      url                         = "github:yannmasoch/nautilus-my-computer?dir=packaging/nix";
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
      nautilus-my-computer,
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

        ./hardware-configuration.nix
        ./configuration.nix
        ./packages.nix
        ./nax/shortcuts/shortcuts.nix
        ./nax/niri/niri.nix
        ./nax/materialshell/materialshell.nix
        ./nax/coolercontrol/coolercontrol.nix
        ./nax/drives/xdrive.nix
        ./nax/drives/stax.nix
        ./nax/gnome/gnome.nix
        ./nax/flatpak/flatpak.nix
        ./nax/openrgb/openrgb.nix
        ./nax/tty/tty.nix

        #./nax/figma/figma-desktop.nix
         ./nax/shell/shell.nix
        #./nax/goodsync/goodsync.nix
        #./nax/mtsync/mtsync.nix

        agenix.nixosModules.default
        nix-flatpak.nixosModules.nix-flatpak
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs   = true;
          home-manager.useUserPackages = true;
          home-manager.users.nax       = ./nax/home.nix;  
        }


      ];
    };
  };
}