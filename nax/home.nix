{ config, pkgs, ... }:
{
  home.username = "nax";
  home.homeDirectory = "/home/nax";
  home.stateVersion = "25.11";

  #Disable middle click paste
  services.cliphist = {
  enable = true;
  allowImages = true; # optional
  extraOptions = [];
};

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
    ".zprofile".source = ./zsh/zprofile;
    ".config/fastfetch/config.jsonc".source = ./fastfetch/config.jsonc;
  };
}
