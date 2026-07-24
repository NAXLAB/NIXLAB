{ pkgs, inputs, ... }:

{
  systemd.tmpfiles.rules = [
    "d /home/nax/.config/OpenRGB 0755 nax users - -"
    "L+ /home/nax/.config/OpenRGB/naxlab.orp - - - - /etc/nixos/nax/openrgb/naxlab.orp"
    "L+ /home/nax/.config/OpenRGB/OpenRGB.json - - - - /etc/nixos/nax/openrgb/OpenRGB.json"
  ];
}