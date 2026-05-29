{ config, pkgs, ... }:
{
  home.username = "nax";
  home.homeDirectory = "/home/nax";
  home.stateVersion = "25.11";

  home.file = {
    ".config/user-dirs.dirs".source = ./xdg/user-dirs;
    ".gitconfig".source = ./git/config;
    ".config/niri/config.kdl".source = ./niri/config.kdl;
    ".zshrc".source = ./zsh/zshrc;
    ".zprofile".source = ./zsh/zprofile;
    ".config/fastfetch/config.jsonc".source = ./fastfetch/config.jsonc;
  };
}