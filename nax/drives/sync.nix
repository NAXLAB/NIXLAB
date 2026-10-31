{ 
  config,
  pkgs,
  inputs,
  ... 
}:

{

  imports = [
    inputs.goodsync.nixosModules.default
  ];

  services.goodsync = 
  {
      enable        = true;
      user          = "nax";
      package       = inputs.goodsync.packages.${pkgs.stdenv.hostPlatform.system}.default;
  };

/*
services.syncthing = {
  enable = true;
  openDefaultPorts = true; # Open ports in the firewall for Syncthing. (NOTE: this will not open syncthing gui port)
};
*/

}