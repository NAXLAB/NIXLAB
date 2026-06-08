{ pkgs, inputs, ... }:

{
  
  systemd.tmpfiles.rules = [
    "d /etc/coolercontrol"
    "L+ /etc/coolercontrol/config.toml - - - - /etc/nixos/nax/coolercontrol/config.toml"
    "L+ /etc/coolercontrol/config-ui.json - - - - /etc/nixos/nax/coolercontrol/config-ui.json"
  ];

}