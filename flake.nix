{
  description = "NixOS configuration with Noctalia";

  nixConfig = {
    extra-substituters = [ "https://noctalia.cachix.org" ];
    extra-trusted-public-keys = [ "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" ];
  };


  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  hjem = {
    url = "github:feel-co/hjem";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  noctalia = {
     url = "github:noctalia-dev/noctalia-shell";
    inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, ... }: {
    nixosConfigurations.zaigomaat = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
	      ./noctalia.nix
        inputs.hjem.nixosModules.default
      ];
    };
  };
}
