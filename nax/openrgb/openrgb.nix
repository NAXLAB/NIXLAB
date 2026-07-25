{ pkgs, inputs, ... }:

{
#Install OpenRGB
services.hardware.openrgb = {
  enable = true;
  motherboard = "amd";
};

systemd.user.services.openrgb-profile = {
  description = "Load OpenRGB profile";
  wantedBy = [ "graphical-session.target" ];
  after = [ "graphical-session.target" ];
  serviceConfig = {
    Type = "oneshot";
    ExecStart = "${pkgs.openrgb}/bin/openrgb --profile \"naxlab\"";
    RemainAfterExit = true;
  };
};

  systemd.tmpfiles.rules = [
    "d /home/nax/.config/OpenRGB 0755 nax users - -"
    "L+ /home/nax/.config/OpenRGB/naxlab.orp - - - - /etc/nixos/nax/openrgb/naxlab.orp"
    "L+ /home/nax/.config/OpenRGB/OpenRGB.json - - - - /etc/nixos/nax/openrgb/OpenRGB.json"
  ];

}
