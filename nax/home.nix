{ config, pkgs, ... }:
{


  home.username = "nax";
  home.homeDirectory = "/home/nax";
  home.stateVersion = "25.11";

  xdg.userDirs = {
    enable = true;
    createDirectories = false;
    desktop = "${config.home.homeDirectory}/Desktop";
    download = "${config.home.homeDirectory}/Downloads";
    music = "${config.home.homeDirectory}/Music";
    documents = "${config.home.homeDirectory}/Documents";
    pictures = "${config.home.homeDirectory}/Photos";
    templates = null;
    publicShare = null;
    videos = null;
  };

  home.file = {
    ".gitconfig".source = ./git/config;
    ".config/niri/config.kdl".source = ./niri/config.kdl;
    ".zshrc".source = ./zsh/zshrc;
    ".config/fastfetch/config.jsonc".source = ./fastfetch/config.jsonc;
  };


  #Declare GTK Theme
  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3";
      package = pkgs.adw-gtk3;
    };
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
    font = {
      name = "Inter";
      package = pkgs.inter;
      size = 11;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
    gtk4 = {
      theme = null;
      extraConfig = {
        gtk-application-prefer-dark-theme = true;
      };
    };
  };

  dconf.settings = {
  "org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
    font-name = "Inter 11";
    document-font-name = "Inter 11";
    monospace-font-name = "Iosevka Nerd Font Mono 11";
  };
};

services.mako = {
  enable = true;
  settings.font = "Iosevka Nerd Font 11";
};

#GTK Compatibility
xdg.userDirs.setSessionVariables = true;

}
