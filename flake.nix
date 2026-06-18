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

  };

  outputs = inputs@  { 
    self,
    nixpkgs,
    agenix,
    home-manager,
    quickshell,
    nix-flatpak,
    dms,
    ...
  }:
  
  {
    nixosConfigurations.zaigomaat = nixpkgs.lib.nixosSystem{

      specialArgs = {
        inherit inputs;
      };

      modules = [

        ./hardware-configuration.nix
        ./configuration.nix
        ./nax/niri/niri.nix
        ./nax/niri/niri-sidebar/niri-sidebar.nix
        ./nax/materialshell/materialshell.nix
        ./nax/coolercontrol/coolercontrol.nix
        ./nax/drives/xdrive.nix
        ./nax/drives/stax.nix


        home-manager.nixosModules.home-manager{
          home-manager.useGlobalPkgs   = true;
          home-manager.useUserPackages = true;
          home-manager.users.nax       = ./nax/home.nix;  
        }

        agenix.nixosModules.default
        nix-flatpak.nixosModules.nix-flatpak

        # ./nax/shell/shell.nix
        #./nax/gnome/gnome.nix
        #./nax/flatpak/flatpak.nix

      ];
    };
  };
}