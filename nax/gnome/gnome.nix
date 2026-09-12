{ pkgs, config, ... }:
{
  services = {
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    gnome.core-apps.enable = false;
    gnome.core-developer-tools.enable = false;
    gnome.games.enable = false;
    gnome.gnome-keyring.enable = true;
  };

  #Policy Kit
  security.polkit.enable = true;  

  #Manage Keyring
  programs.seahorse.enable = true;

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-user-docs
  ];

  systemd.tmpfiles.rules = [
  "d /var/lib/gdm/seat0/config 0711 gdm gdm - -"
  "L+ /var/lib/gdm/seat0/config/monitors.xml - - - - ${pkgs.writeText "gdm-monitors.xml" ''
    <monitors version="2">
      <configuration>
        <layoutmode>physical</layoutmode>
        <logicalmonitor>
          <x>1920</x>
          <y>0</y>
          <scale>1</scale>
          <monitor>
            <monitorspec>
              <connector>DP-1</connector>
              <vendor>AUS</vendor>
              <product>ASUS VP249</product>
              <serial>0x00020f77</serial>
            </monitorspec>
            <mode>
              <width>1920</width>
              <height>1080</height>
              <rate>143.855</rate>
            </mode>
          </monitor>
        </logicalmonitor>
        <logicalmonitor>
          <x>0</x>
          <y>0</y>
          <scale>1</scale>
          <primary>yes</primary>
          <monitor>
            <monitorspec>
              <connector>DP-2</connector>
              <vendor>MSI</vendor>
              <product>MSI G241</product>
              <serial>0x00000cae</serial>
            </monitorspec>
            <mode>
              <width>1920</width>
              <height>1080</height>
              <rate>143.855</rate>
            </mode>
          </monitor>
        </logicalmonitor>
      </configuration>
      <configuration>
        <layoutmode>logical</layoutmode>
        <logicalmonitor>
          <x>0</x>
          <y>0</y>
          <scale>1</scale>
          <primary>yes</primary>
          <monitor>
            <monitorspec>
              <connector>DP-2</connector>
              <vendor>MSI</vendor>
              <product>MSI G241</product>
              <serial>0x00000cae</serial>
            </monitorspec>
            <mode>
              <width>1920</width>
              <height>1080</height>
              <rate>143.855</rate>
            </mode>
          </monitor>
        </logicalmonitor>
        <logicalmonitor>
          <x>1920</x>
          <y>0</y>
          <scale>1</scale>
          <monitor>
            <monitorspec>
              <connector>DP-1</connector>
              <vendor>AUS</vendor>
              <product>ASUS VP249</product>
              <serial>0x00020f77</serial>
            </monitorspec>
            <mode>
              <width>1920</width>
              <height>1080</height>
              <rate>143.855</rate>
            </mode>
          </monitor>
        </logicalmonitor>
      </configuration>
    </monitors>
  ''}"
];

}