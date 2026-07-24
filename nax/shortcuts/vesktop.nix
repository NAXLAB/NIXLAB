{ pkgs, lib, ... }:

let
  vesktopFocusScript = pkgs.writeShellApplication {
    name = "vesktop-focus";
    runtimeInputs = [ pkgs.jq pkgs.niri pkgs.vesktop ];
    text = ''
      WIN_ID=$(niri msg -j windows | jq -r '.[] | select(.app_id == "vesktop") | .id' | head -n1)

      if [ -n "$WIN_ID" ]; then
          niri msg action focus-window --id "$WIN_ID"
      else
          vesktop &
      fi
    '';
  };

  vesktopFocusDesktopItem = pkgs.makeDesktopItem {
    name = "vesktop"; # same as original, causes the collision
    desktopName = "Vesktop";
    genericName = "Internet Messenger";
    exec = "${vesktopFocusScript}/bin/vesktop-focus %U";
    icon = "vesktop";
    categories = [ "Network" "InstantMessaging" "Chat" ];
    keywords = [ "discord" "vencord" "electron" "chat" ];
    mimeTypes = [ "x-scheme-handler/discord" ];
    startupWMClass = "Vesktop";
  };
in
lib.hiPrio (pkgs.symlinkJoin {
  name = "vesktop-focus-shortcut";
  paths = [ vesktopFocusScript vesktopFocusDesktopItem ];
})