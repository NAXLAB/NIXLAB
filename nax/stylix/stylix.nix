{ pkgs, nixpkgs, ... }:

{

    stylix.enable = true;
    stylix.polarity = "dark";
    stylix.targets.gtksourceview.enable = false;
    stylix.targets.gnome.enable = false;
    stylix.base16Scheme = ./naxlab-colors.yaml;

}
