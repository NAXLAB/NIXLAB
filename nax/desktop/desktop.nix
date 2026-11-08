  { config,
    pkgs,
    inputs,
    ... 
  }:

  {
    
  #Enable Niri
  programs.niri.enable = true;

  systemd.tmpfiles.rules = [

    #Stage Niri Config File
    "d /home/nax/.config/niri 0755 nax users -"
    "L+ /home/nax/.config/niri/config.kdl - - - - /etc/nixos/nax/desktop/niri.kdl"

    #Stage Bookmarks Config File
    "d /home/nax/.config/gtk-3.0 0755 nax users -"
    "L+ /home/nax/.config/gtk-3.0/bookmarks - - - - /etc/nixos/nax/gnome/bookmarks"
  ];

  #Desktop Utilities
  services.gnome.gnome-keyring.enable             = true;
  programs.dconf.enable                           = true;
  security.polkit.enable                          = true;  
  security.pam.services.greetd.enableGnomeKeyring = true;
  environment.systemPackages                      = with pkgs; [
      xwayland-satellite                #Wayland integration
      xdg-utils                         #Desktop app rendering utils
      gnome-control-center              #Gnome Settings
      refine                            #Gnome Tweaks
      wl-clipboard                      #Clipboard 
      wl-clip-persist                   #Wayland Clipboard utility
      grim                              #screenshot
      slurp                             #select area screenshot
      qadwaitadecorations-qt6           #QT Adwaita Theme
    ];

  #Allow Apps to be managed by wayland compositors
  environment.sessionVariables = {
    NIXOS_OZONE_WL        = "1";              # Electron/Chromium apps (VS Code, Discord, Slack, etc.)
    FIGMA_USE_WAYLAND     = "1";              # Figma Wayland
    MOZ_ENABLE_WAYLAND    = "1";              # Firefox
    QT_QPA_PLATFORM       = "wayland";        # Qt apps
    QT_WAYLAND_DECORATION = "adwaita";        # QT apps
    GDK_BACKEND           = "wayland,x11";    # GTK apps
    SDL_VIDEODRIVER       = "wayland";        # SDL apps
    CLUTTER_BACKEND       = "wayland";        # Clutter apps
  };

  xdg.portal = {
  enable = true;
  extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
    ];
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