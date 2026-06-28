{ pkgs, ... }:
{
  services = {
    displayManager.gdm.enable = false;
    desktopManager.gnome.enable = true;
    gnome.core-apps.enable = false;
    gnome.core-developer-tools.enable = false;
    gnome.games.enable = false;
    gnome.gnome-keyring.enable = true;
  };

  #Manage Keyring
  programs.seahorse.enable = true;

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-user-docs
  ];

  environment.systemPackages = with pkgs; [
    gnome-control-center     # Settings
    gnome-software           # Gnome Package Manager
  ];



}