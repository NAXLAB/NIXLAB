{ pkgs, inputs, ... }:

{
programs.firefox = {
  enable = true;
  profiles.default = {
    # "default" becomes the profile name home-manager manages
    isDefault = true;
    search.force = true;

userChrome = ''
  
'';

    # also enables the userChrome flag automatically
    settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "devtools.debugger.remote-enabled" = true;
    };
  };
};

}