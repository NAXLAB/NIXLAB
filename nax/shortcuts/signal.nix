{ pkgs, lib, ... }:

let
signalFocusScript = pkgs.writeShellApplication {
  name = "signal-focus";
  runtimeInputs = [ pkgs.jq pkgs.niri pkgs.signal-desktop ];
  text = ''
    WIN_ID=$(niri msg -j windows | jq -r '.[] | select(.app_id == "signal") | .id' | head -n1)

    if [ -n "$WIN_ID" ]; then
        niri msg action focus-window --id "$WIN_ID"
    else
        signal-desktop &
    fi
  '';
};

  signalFocusDesktopItem = pkgs.makeDesktopItem {
    name = "signal"; # same as original, causes the collision
    desktopName = "Signal";
    genericName = "Internet Messenger";
    exec = "${signalFocusScript}/bin/signal-focus %U";
    icon = "signal-desktop";
    categories = [ "Network" "InstantMessaging" "Chat" ];
    keywords = [ "signal" "message" "chat" "encrypted" ];
    mimeTypes = [ "x-scheme-handler/signal" ];
    startupWMClass = "signal-desktop";
  };
in
lib.hiPrio (pkgs.symlinkJoin {
  name = "signal-focus-shortcut";
  paths = [ signalFocusScript signalFocusDesktopItem ];
})