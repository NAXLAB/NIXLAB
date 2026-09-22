{ pkgs, config, ... }:
{
  services = {
    displayManager.gdm.enable = false;
    desktopManager.gnome.enable = true;
    gnome.core-apps.enable = false;
    gnome.core-developer-tools.enable = false;
    gnome.games.enable = false;
    gnome.gnome-keyring.enable = true;
  };

  #Dconf
  programs.dconf.enable = true;

  #Policy Kit
  security.polkit.enable = true;  

  #Manage Keyring
  programs.seahorse.enable = true;

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-user-docs
  ];
    
  xdg.portal = {
    enable = true;
    extraPortals = [ 
      pkgs.xdg-desktop-portal-gtk 
      ];
  };

  systemd.tmpfiles.rules = [
    "d /home/nax/.config/gtk-3.0 0755 nax users -"
    "L+ /home/nax/.config/gtk-3.0/bookmarks - - - - /etc/nixos/nax/gnome/bookmarks"
  ];



}