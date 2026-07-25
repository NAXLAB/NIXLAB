{ pkgs, inputs, ... }:

{

  programs.niri.enable = true;

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.niri}/bin/niri-session";
        user = "nax";
      };
    };
  };

  systemd.tmpfiles.rules = [
    "L+ /home/nax/.config/niri/config.kdl - - - - /etc/nixos/nax/niri/config.kdl"
  ];

  #Allow Electron Apps to be managed by Niri
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

}