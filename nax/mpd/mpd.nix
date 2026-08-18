# mpd.nix
#
# Home-manager module that reproduces:
#   mkdir ~/.mpd
#   ~/.mpd/mpd.conf  (db_file, state_file, pulse audio_output "Music")
#   systemctl --user enable --now mpd.socket

{ config, pkgs, ... }:

{
  services.mpd = {
    enable = true;

    musicDirectory = "${config.home.homeDirectory}/Music";

    dataDir = "${config.home.homeDirectory}/.mpd";
    dbFile  = "${config.home.homeDirectory}/.mpd/database";

    extraConfig = ''
      audio_output {
        type "pulse"
        name "Music"
      }
    '';
  };

  home.packages = with pkgs; [
    mpd           #Music Player Daemon
    euphonica     #MPD Client
    plattenalbum  #MPD Client
  ];
}
