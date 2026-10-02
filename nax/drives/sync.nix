{ 
  config,
  pkgs, 
  ... 
}:

{

  agenix.nixosModules.default

  services.goodsync = 
    {
      enable = true;
      user = "nax";
    };
}