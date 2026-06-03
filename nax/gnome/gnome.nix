{ pkgs, ... }:
{
  services = {
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    gnome.core-apps.enable = true;
    gnome.core-developer-tools.enable = false;
    gnome.games.enable = false;
  };

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-user-docs
  ];

  environment.systemPackages = with pkgs; [
    nautilus                # File Manager
    gnome-console           # Console
    gnome-calculator        # Calculator
    gnome-control-center    # Settings - probably already comes with gnome
    resources               # Resources (system monitor)
    gnome-text-editor       # Text editor
    gnome-font-viewer       # Fonts
    gnome-characters        # Characters
    baobab                  # Disk usage (Disk Usage Analyzer)
    loupe                   # Image viewer (modern GNOME image viewer)
    gnome-music             # Music
    nwg-look                #GTK settings
    gnome-tweaks            #Gnome Tweaks
  ];

systemd.tmpfiles.rules = [
  "L+ /var/lib/gdm/.config/monitors.xml - - - - /etc/gdm-monitors.xml"
];

environment.etc."gdm-monitors.xml".text = ''
  <monitors version="2">
    <configuration>
      <logicalmonitor>
        <x>0</x>
        <y>0</y>
        <scale>1</scale>
        <primary>yes</primary>
        <monitor>
          <monitorspec>
            <connector>DP-1</connector>
            <vendor>...</vendor>
            <product>...</product>
            <serial>...</serial>
          </monitorspec>
          <mode>
            <width>2560</width>
            <height>1440</height>
            <rate>144.000</rate>
          </mode>
        </monitor>
      </logicalmonitor>
      <!-- second monitor -->
    </configuration>
  </monitors>
'';

}