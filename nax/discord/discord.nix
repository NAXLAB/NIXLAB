{ pkgs, ... }:

{
home.file.".config/vesktop/settings/quickCss.css".text = ''
  :root {
    --custom-app-top-bar-height: 0px !important;
  }

  div[data-window-chrome="true"] {
    display: none !important;
  }
'';
}