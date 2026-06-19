{ pkgs, inputs, ... }:

programs.firefox = {
  enable = true;
  profiles.default = {
    # "default" becomes the profile name home-manager manages
    isDefault = true;

userChrome = ''
  /* Popup background and border */
  menupopup {
    background-color: #1e1e1e !important;  /* match your system bg */
    border: 1px solid #3a3a3a !important;
    border-radius: 8px !important;
    padding: 4px !important;
  }

  /* Individual items */
  menuitem, menu {
    border-radius: 4px !important;
    padding: 4px 8px !important;
    color: #e0e0e0 !important;
    font-weight: 400 !important;
  }

  /* Hover/selected state */
  menuitem:hover, menu:hover,
  menuitem[_moz-menuactive="true"],
  menu[_moz-menuactive="true"] {
    background-color: #3a3a3a !important;
    color: #ffffff !important;
  }

  /* Separators */
  menuseparator {
    border-color: #3a3a3a !important;
    margin: 2px 0 !important;
  }

  /* Tooltip */
  tooltip {
    background-color: #1e1e1e !important;
    border: 1px solid #3a3a3a !important;
    color: #e0e0e0 !important;
    font-weight: 400 !important;
    border-radius: 4px !important;
  }
'';

    # also enables the userChrome flag automatically
    settings = {
      "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
    };
  };
};