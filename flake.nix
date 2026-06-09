{
  description = "ZaiGoMaat";

  nixConfig = {
    extra-substituters = [ "https://noctalia.cachix.org" ];
    extra-trusted-public-keys = [ "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" ];
  };

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

 outputs = inputs@{ self, nixpkgs, agenix, home-manager, quickshell, ... }: {
    nixosConfigurations.zaigomaat = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [

        ./configuration.nix
        ./nax/noctalia/noctalia.nix
        ./nax/gnome/gnome.nix
        ./nax/coolercontrol/coolercontrol.nix

        agenix.nixosModules.default

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.nax = import ./nax/home.nix;
       }

      ];
    };
  };

}
