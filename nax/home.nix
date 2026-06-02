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
}
