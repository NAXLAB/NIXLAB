{ 
  config,
  pkgs,
  inputs,
   ... 
}:

{

  environment.systemPackages      = with pkgs; [
	  vesktop                           # Discord
  ];
  
home-manager.users.nax.home.file.".config/vesktop/settings/quickCss.css".text = ''
  :root {
    --custom-app-top-bar-height: 0px !important;
  }

  div[data-window-chrome="true"] {
    display: none !important;
  }

  /* Push the left server column's contents down */
  nav[aria-label="Servers sidebar"] {
    padding-top: 8px !important;
    box-sizing: border-box !important;
  }
'';
}