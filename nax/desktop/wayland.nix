  { config,
    pkgs,
    inputs,
    ... 
  }:

  {

    #Desktop Utilities
    environment.systemPackages    = with pkgs; [

      xwayland-satellite                #Wayland integration
      xdg-desktop-portal-gnome          #App Compatibility portal
      xdg-utils                         #Desktop app rendering utils
      refine                            #More Gnome Tweaks
      wl-clipboard                      #Clipboard 
      wl-clip-persist                   #Wayland Clipboard Fuck you
      grim                              #screenshot
      slurp                             #select area screenshot
      gvfs                              #Gnome Filesystem Compatibility

  ];

  #Allow Apps to be managed by wayland compositors
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