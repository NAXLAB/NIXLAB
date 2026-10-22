{
  config,
  pkgs,
  ... 
}:

{

  home = {
    username       = "nax";
    homeDirectory  = "/home/nax";
    stateVersion   = "26.11";
  };

  home.file =
    {
      ".gitconfig".source                       = ./git/config;
      ".config/fastfetch/config.jsonc".source   = ./fastfetch/config.jsonc;
    };

  imports = [
    ./firefox/firefox.nix
    ./discord/discord.nix
  ];

  gtk = 
    {
      enable  = true;
      theme   = 
        {
          name    = "adw-gtk3";
          package = pkgs.adw-gtk3;
        };

    gtk4 = {
      theme = config.gtk.theme;
      extraCss = ''
        @import url("dank-colors.css");
      '';
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk3"; # make Qt apps follow GTK theme
  };


}
