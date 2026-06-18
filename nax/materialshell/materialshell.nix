{ pkgs, inputs, ... }:
{


#Autologin Nax
services.getty.autologinUser = "nax";
 
#Enable DMS Nixos module and supply package via flakes
programs.dms-shell = 
    {
    enable = true;
    package = inputs.dms.packages.${pkgs.stdenv.hostPlatform.system}.default;

    systemd = 
    {
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

environment.systemPackages = with pkgs; 
[
    dsearch   #dms file search
];

systemd.tmpfiles.rules = 
[
    "L+ /home/nax/.config/niri/dms/alttab.kdl - - - - /etc/nixos/nax/materialshell/alttab.kdl"
    "L+ /home/nax/.config/niri/dms/binds.kdl - - - - /etc/nixos/nax/materialshell/binds.kdl"
    "L+ /home/nax/.config/niri/dms/colors.kdl - - - - /etc/nixos/nax/materialshell/colors.kdl"
    "L+ /home/nax/.config/niri/dms/cursor.kdl - - - - /etc/nixos/nax/materialshell/cursor.kdl"
    "L+ /home/nax/.config/niri/dms/layout.kdl - - - - /etc/nixos/nax/materialshell/layout.kdl"
    "L+ /home/nax/.config/niri/dms/outputs.kdl - - - - /etc/nixos/nax/materialshell/outputs.kdl"
    "L+ /home/nax/.config/niri/dms/windowrules.kdl - - - - /etc/nixos/nax/materialshell/windowrules.kdl"
    "L+ /home/nax/.config/niri/dms/wpblur.kdl - - - - /etc/nixos/nax/materialshell/wpblur.kdl"
];
}