{ pkgs, inputs, ... }:
{

    #Autologin Nax
    services.getty.autologinUser = "nax";

    #Enable DMS Nixos module and supply package via flakes
    programs.dms-shell = {
    enable = true;
    package = inputs.dms.packages.${pkgs.stdenv.hostPlatform.system}.default;

    systemd = {
    enable = true;
    restartIfChanged = true;
    target = "niri.service";
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