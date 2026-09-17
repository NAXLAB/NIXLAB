{ pkgs, inputs, ... }:

{

  programs.coolercontrol.enable = true;


  systemd.tmpfiles.rules = [
    "d /etc/coolercontrol 0755 root root -"
    "L+ /etc/coolercontrol/config.toml      - - - - /etc/nixos/nax/coolercontrol/config.toml"
    "L+ /etc/coolercontrol/config-ui.json   - - - - /etc/nixos/nax/coolercontrol/config-ui.json"
  ];

}