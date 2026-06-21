{ config, lib, pkgs, ... }:
{
    imports = [ ./gs-module.nix ];

    services.goodsync = 
    {
        enable      = true;         # bool, default false
        user        = "goodsync";   # string, default "goodsync"
        dataDir     = "/var/lib/goodsync";  # path, default "/var/lib/goodsync"
        openFirewall = false;       # bool, default false
    };
}