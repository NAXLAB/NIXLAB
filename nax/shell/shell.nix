# shell.nix
{ inputs, pkgs, ... }:


{
  environment.systemPackages = [
    inputs.quickshell.packages.${pkgs.system}.default
  ];

  systemd.tmpfiles.rules = [
    "L+ /home/nax/.config/quickshell - - - - /etc/nixos/nax/shell"
  ];

}