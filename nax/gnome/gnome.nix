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
    evince                  # Document viewer
    resources               # Resources (system monitor)
    gnome-text-editor       # Text editor
    gnome-font-viewer       # Fonts
    gnome-characters        # Characters
    baobab                  # Disk usage (Disk Usage Analyzer)
    loupe                   # Image viewer (modern GNOME image viewer)
    gnome-music             # Music
    nwg-look                #GTK settings 
  ];
}