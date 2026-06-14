{ ... }:

{

  systemd.tmpfiles.rules = [
    "L+ /home/nax/.config/quickshell/shell.qml - - - - /etc/nixos/nax/shell/shell.qml"
  ];

}