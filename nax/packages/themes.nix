{ config,
  pkgs,
  inputs,
  ... 
}:

{
  
  programs.adwair = {
    enable  = true;
    color   = "teal";        # optional: blue green orange pink purple red slate teal yellow
    # coloredApps = true;  # optional, requires `color`
  };
  
}