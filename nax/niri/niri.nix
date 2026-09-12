{ pkgs, inputs, ... }:

{

  programs.niri.enable = true;

  systemd.tmpfiles.rules = [
    "L+ /home/nax/.config/niri/config.kdl - - - - /etc/nixos/nax/niri/config.kdl"
  ];

  #Allow Apps to be managed by Niri
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";        # Electron/Chromium apps (VS Code, Discord, Slack, etc.)
    MOZ_ENABLE_WAYLAND = "1";    # Firefox
    QT_QPA_PLATFORM = "wayland";  # Qt apps
    GDK_BACKEND = "wayland";      # GTK apps
    SDL_VIDEODRIVER = "wayland";  # SDL apps
    CLUTTER_BACKEND = "wayland";  # Clutter apps
  };

}