  { config,
    pkgs,
    inputs,
    ... 
  }:

  {

    programs.niri.enable = true;

    systemd.tmpfiles.rules = [
      "d /home/nax/.config/niri 0755 nax users -"
      "L+ /home/nax/.config/niri/config.kdl - - - - /etc/nixos/nax/desktop/niri.kdl"
    ];

    #Desktop Utilities
    environment.systemPackages    = with pkgs; [

      xwayland-satellite                #Wayland integration
      xdg-desktop-portal-gnome          #App Compatibility portal
      xdg-utils                         #Desktop app rendering utils
      refine                            #More Gnome Tweaks
      wl-clipboard                      #Clipboard 
      wl-clip-persist                   #Wayland Clipboard utility
      grim                              #screenshot
      slurp                             #select area screenshot
      gvfs                              #Gnome Filesystem Compatibility
      qadwaitadecorations-qt6           #QT Adwaita Theme

    ];

  #Allow Apps to be managed by wayland compositors
  environment.sessionVariables = {
    
    NIXOS_OZONE_WL        = "1";         # Electron/Chromium apps (VS Code, Discord, Slack, etc.)
    FIGMA_USE_WAYLAND     = "1";       # Figma Wayland
    MOZ_ENABLE_WAYLAND    = "1";     # Firefox
    QT_QPA_PLATFORM       = "wayland";  # Qt apps
    QT_WAYLAND_DECORATION = "adwaita";
    GDK_BACKEND           = "wayland";      # GTK apps
    SDL_VIDEODRIVER       = "wayland";  # SDL apps
    CLUTTER_BACKEND       = "wayland";  # Clutter apps

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