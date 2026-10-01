{ lib, pkgs, inputs, ... }:

{

  #Enable Coolercontrol module
  programs.coolercontrol.enable = true;

  #Live link coolercontrol config to nix repo
  systemd.tmpfiles.rules = [
    "d /etc/coolercontrol 0755 root root -"
    "L+ /etc/coolercontrol/config.toml      - - - - /etc/nixos/nax/coolercontrol/config.toml"
    "L+ /etc/coolercontrol/config-ui.json   - - - - /etc/nixos/nax/coolercontrol/config-ui.json"
  ];

}