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

}