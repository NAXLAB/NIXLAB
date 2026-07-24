{ pkgs, ... }:

{
  environment.systemPackages = [
    (pkgs.callPackage ./vesktop.nix { })
    (pkgs.callPackage ./signal.nix { })
  ];
}