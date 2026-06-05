# nax/icons/icons.nix
{ pkgs, ... }:

let
  papirus = pkgs.papirus-icon-theme;
in
{
  xdg.dataFile = {

    # Vesktop -> Discord icon
    "applications/vesktop.desktop".text = ''
      [Desktop Entry]
      Name=Vesktop
      Exec=vesktop
      Icon=${papirus}/share/icons/Papirus/48x48/apps/discord.svg
      Type=Application
      Categories=Network;InstantMessaging;
    '';

    # Add more below, same pattern:
    # "applications/some-app.desktop".text = ''
    #   [Desktop Entry]
    #   Name=Some App
    #   Exec=some-app
    #   Icon=${papirus}/share/icons/Papirus/48x48/apps/some-icon.svg
    #   Type=Application
    #   Categories=...;
    # '';

  };
}