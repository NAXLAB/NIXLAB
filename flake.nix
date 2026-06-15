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

    #Flatpak
    nix-flatpak = {
      url                         = "github:gmodena/nix-flatpak/?ref=latest";
      inputs.nixpkgs.follows      = "nixpkgs";
    };

    #Home Manager
    home-manager = {
      url                         = "github:nix-community/home-manager";
      inputs.nixpkgs.follows      = "nixpkgs";
    };

    #Noctalia Shell
    noctalia = {
      url                         = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows      = "nixpkgs";
    };

    #Quickshell
    quickshell = {
      url                         = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows      = "nixpkgs";
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
        ./configuration.nix
        ./nax/niri/niri.nix
        ./nax/gnome/gnome.nix

        ./nax/shell/shell.nix
        ./nax/coolercontrol/coolercontrol.nix
        ./nax/materialshell/materialshell.nix

         agenix.nixosModules.default
         nix-flatpak.nixosModules.nix-flatpak

        home-manager.nixosModules.home-manager{
          home-manager.useGlobalPkgs   = true;
          home-manager.useUserPackages = true;
          home-manager.users.nax       = ./nax/home.nix;  
        }

        #./nax/noctalia/noctalia.nix
        #./nax/flatpak/flatpak.nix
      ];
    };
  };
}