{ pkgs, ... }:

{
  environment.systemPackages = [
    (pkgs.callPackage ./package-local.nix { })
  ];
}