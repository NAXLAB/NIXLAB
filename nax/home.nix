{
  config,
  pkgs,
  ... 
}:

{

  home.username       = "nax";
  home.homeDirectory  = "/home/nax";
  home.stateVersion   = "26.11";

  imports = [
    ./firefox/firefox.nix
  ];

  #GTK Compatibility
  xdg.userDirs.setSessionVariables = true;


  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3";
      package = pkgs.adw-gtk3;
    };

    gtk4 = {
      theme = config.gtk.theme;
      extraCss = ''
        @import url("dank-colors.css");
      '';
    };

  };


  #App compatibility with symlinked home folders
  xdg.userDirs =
    {
      enable            = true;
      createDirectories = false;
      templates         = null;
      publicShare       = null;
      videos            = null;      
      desktop           = "${config.home.homeDirectory}/Desktop";
      download          = "${config.home.homeDirectory}/Downloads";
      music             = "${config.home.homeDirectory}/Music";
      documents         = "${config.home.homeDirectory}/Documents";
      pictures          = "${config.home.homeDirectory}/Pictures";
    };

  home.file =
    {
      ".gitconfig".source                       = ./git/config;
      ".zshrc".source                           = ./zsh/zshrc;
      ".config/fastfetch/config.jsonc".source   = ./fastfetch/config.jsonc;
    };
  
    dconf.settings."org/gnome/desktop/interface" = 
    {
      color-scheme        = "prefer-dark";
      font-name           = "SF Pro Display 11";
      monospace-font-name = "JetBrainsMonoNL Nerd Font 11";
    };

}
