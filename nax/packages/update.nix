{ config,
  pkgs,
  inputs,
  ... 
}:

{

imports = [ inputs.nixos-updater.nixosModules.default ];
programs.nixos-updater = {
  enable = true;
  autoBuild = false;
  checkFrequency = "weekly";  # daily | weekly | monthly 
  directory = "/etc/nixos";
};
}