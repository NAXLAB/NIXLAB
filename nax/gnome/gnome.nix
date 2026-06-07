{ pkgs, ... }:
{
  services = {
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    gnome.core-apps.enable = false;
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
    gnome-font-viewer       # Fonts
    gnome-characters        # Characters
    baobab                  # Disk usage (Disk Usage Analyzer)
    loupe                   # Image viewer (modern GNOME image viewer)
    nwg-look                #GTK settings
    refine                  #More Gnome Tweaks
    gdm-settings            #Customize Gnome Login Manager
  ];

}