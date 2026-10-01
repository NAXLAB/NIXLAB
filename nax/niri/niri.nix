{ pkgs, inputs, ... }:

{
  programs.niri.enable = true;

  systemd.tmpfiles.rules = [
    "d /home/nax/.config/niri 0755 nax users -"
    "L+ /home/nax/.config/niri/config.kdl - - - - /etc/nixos/nax/niri/config.kdl"
  ];

  #Allow Apps to be managed by Niri
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";         # Electron/Chromium apps (VS Code, Discord, Slack, etc.)
    MOZ_ENABLE_WAYLAND = "1";     # Firefox
    QT_QPA_PLATFORM = "wayland";  # Qt apps
    GDK_BACKEND = "wayland";      # GTK apps
    SDL_VIDEODRIVER = "wayland";  # SDL apps
    CLUTTER_BACKEND = "wayland";  # Clutter apps

  };

  #Clipboard configuration
  systemd.user.services.wl-clip-persist = {
    description   = "Persist Wayland clipboard";
    partOf        = [ "graphical-session.target" ];
    after         = [ "graphical-session.target" ];
    wantedBy      = [ "graphical-session.target" ];
    serviceConfig = 
      {
        ExecStart = "${pkgs.wl-clip-persist}/bin/wl-clip-persist --clipboard regular --write-timeout 5000 --ignore-event-on-error" ;
        Restart   = "on-failure";
      };
  };

}