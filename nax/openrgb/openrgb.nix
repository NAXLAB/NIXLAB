{ pkgs, inputs, ... }:

{

systemd.tmpfiles.rules = 
[

    "L+ /home/nax/.config/openRGB/naxlab.orp - - - - /etc/nixos/nax/openrgb/naxlab.orp"
    "L+ /home/nax/.config/openRGB/openRGB.json - - - - /etc/nixos/nax/openrgb/openRGB.json"

];

}