{ pkgs, inputs, ... }:

{



programs.firefox = {
  enable = true;
  profiles.default = {
    search.force = true;

userChrome = ''
  
'';

    # also enables the userChrome flag automatically
    settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
    };
  };
};

}