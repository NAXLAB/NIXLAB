{ pkgs, inputs, ... }:
{
  systemd.tmpfiles.rules = [
    "L+ /home/nax/.config/niri/config.kdl - - - - /etc/nixos/nax/niri/config.kdl"
  ];
}