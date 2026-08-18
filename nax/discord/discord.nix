{ pkgs, ... }:

{
  home.file.".config/vesktop/settings.json".source =
    (pkgs.formats.json {}).generate "vesktop-settings" {
      discordBranch = "stable";
      minimizeToTray = true;
      arRPC = false;
      splashColor = "rgb(239, 239, 241)";
      splashBackground = "rgb(18, 18, 20)";
      customTitleBar = false;
      enableSplashScreen = false;
      staticTitle = false;
      hardwareAcceleration = true;
      enableMenu = false;
      splashPixelated = false;
      clickTrayToShowHide = false;
      hardwareVideoAcceleration = false;
      splashTheming = false;
      tray = true;
      disableMinSize = false;
      disableSmoothScroll = false;
      spellCheckLanguages = [ "en-US" "en" ];

      css = ''
        :root {
          --custom-app-top-bar-height: 0px !important;
        }

        div[data-window-chrome="true"] {
        display: none !important;
        }
      '';
      
    };
}