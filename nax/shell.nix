{ 
  config,
  pkgs,
  inputs, 
  ... 
}:

{

  # Aliases for Terminal Commands
  environment.shellAliases = {

    switch = "sudo nixos-rebuild switch --flake /etc/nixos#zaigomaat";
    build = "sudo nixos-rebuild build --flake /etc/nixos#zaigomaat";
    flake = "sudo nix flake update"; 
    garbage = "sudo nix-collect-garbage -d";

  };

  # Home Manager, dotted form
  home-manager.users.nax.home.file.".zshrc".text = ''

    # Lines configured by zsh-newuser-install
    HISTFILE=~/.histfile
    HISTSIZE=1000
    SAVEHIST=1000
    bindkey -e
    # End of lines configured by zsh-newuser-install

    # The following lines were added by compinstall
    zstyle :compinstall filename '/home/nax/.zshrc'
    autoload -Uz compinit
    compinit
    # End of lines added by compinstall
    fastfetch

  '';

}