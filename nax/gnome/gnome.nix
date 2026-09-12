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

}