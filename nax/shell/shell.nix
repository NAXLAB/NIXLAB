  { 
    config,
    pkgs,
    inputs, 
    ... 
  }:

  {

    # Aliases for Terminal Commands
    environment.shellAliases = {

      switch = "sudo nixos-rebuild switch --flake /etc/nixos#zaigomaat";
      build = "sudo nixos-rebuild build --flake /etc/nixos#zaigomaat";
      flake = "sudo nix flake update"; 
      garbage = "sudo nix-collect-garbage -d";

    };

  }