{ pkgs, ... }:
{

    programs.dms-shell = {
    enable = true;

    systemd = {
        enable = true;             # Systemd service for auto-start
        restartIfChanged = true;   # Auto-restart dms.service when dms-shell changes
    };
  
    # Core features
    enableSystemMonitoring = true;     # System monitoring widgets (dgop)
    enableVPN = true;                  # VPN management widget
    enableCalendarEvents = true;       # Calendar integration (khal)
    enableClipboardPaste = true;       # Pasting from the clipboard history (wtype)
    #enableDynamicTheming = true;       # Wallpaper-based theming (matugen)
    #enableAudioWavelength = true;      # Audio visualizer (cava)
};

}