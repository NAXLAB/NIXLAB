{ pkgs, lib, ... }:
(pkgs.callPackage ./package.nix { }).overrideAttrs (old: {
  src = lib.cleanSource (/. + "/home/nax/Documents/Code Projects/MtSync");
  version = "local-bisync-fix";
})