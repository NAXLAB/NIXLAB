{ config, pkgs, ... }:
{

  home.username = "nax";
  home.homeDirectory = "/home/nax";
  home.stateVersion = "25.11";


  #App compatibility with symlinked home folders
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

  programs.bash.shellAliases = {
    slurp = "slurp -b 1B1F28CC -c CDD6F4FF -s 1B1F28AA -B 1B1F28CC";
  };

  #Declare GTK Theme
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    font = {
      name = "Inter";
      package = pkgs.inter;
      size = 11;
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
  settings.default-timeout = "2000";
};

#GTK Compatibility
xdg.userDirs.setSessionVariables = true;

}
