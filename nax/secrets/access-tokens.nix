{ config, ... }:
{

  age.secrets.nix-access-token = {
    file  = ./nix-access-token.age;   # path to your .age file
    owner = "nax";                             # nix runs as you for the flake update
    mode  = "0400";
  };

  nix.extraOptions = ''
    !include ${config.age.secrets.nix-access-token.path}
  '';
}