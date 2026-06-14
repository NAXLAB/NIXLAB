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
    ".gitconfig".source                     = ./git/config;
    ".zshrc".source                         = ./zsh/zshrc;
    ".config/fastfetch/config.jsonc".source = ./fastfetch/config.jsonc;
    #".config/quickshell/shell.qml".source   = ./shell/shell.qml;
    #".config/niri/config.kdl".source        = ./niri/config.kdl;
  };

#Declare GTK Theme
gtk = {
  enable = true;
  theme = {
    name = "Adwaita-dark";
    package = pkgs.gnome-themes-extra;
  };
  gtk3.extraConfig = {
    gtk-application-prefer-dark-theme = true;
  };
  gtk4.extraConfig = {
    gtk-application-prefer-dark-theme = true;
  };
};

dconf.settings."org/gnome/desktop/interface" = {
  color-scheme = "prefer-dark";
  font-name = "SF Pro Display 11";
  monospace-font-name = "JetBrainsMonoNL Nerd Font 11";
};

xdg.configFile."gtk-4.0/gtk-dark.css".text = ''

'';

#GTK Compatibility
xdg.userDirs.setSessionVariables = true;
gtk.gtk4.theme = config.gtk.theme;

services.mako = {
    enable = true;
    settings = {
      font = "SF";
      default-timeout = 4000;
      on-button-right = "dismiss";
      background-color = "#353540";
      border-color = "#353540";
      padding = "12,16,12,16";
      border-radius = 16;
    };
  };



xdg.desktopEntries.figma = {
  name = "Figma";
  exec = ''chromium --user-agent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"'';
  icon = "chromium";
  type = "Application";
};

systemd.user.services.figma-agent = {
  Unit.Description = "Figma Agent";
  Install.WantedBy = [ "default.target" ];
  Service = {
    ExecStart = "${pkgs.figma-agent}/bin/figma-agent";
    Restart = "on-failure";
  };
};

}
