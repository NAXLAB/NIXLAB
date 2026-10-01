{ pkgs, inputs, ... }:

{
  programs.niri.enable = true;

  systemd.tmpfiles.rules = [
    "d /home/nax/.config/niri 0755 nax users -"
    "L+ /home/nax/.config/niri/config.kdl - - - - /etc/nixos/nax/desktop/niri.kdl"
  ];

}