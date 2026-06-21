{ config, lib, pkgs, ... }:

let
  cfg = config.services.goodsync;
  pkg = pkgs.callPackage ./gs-package.nix {};
in {

  options.services.goodsync = {

    enable = lib.mkEnableOption "GoodSync server";

    user = lib.mkOption {
      type        = lib.types.str;
      default     = "goodsync";
      description = "User to run gs-server as.";
    };

    dataDir = lib.mkOption {
      type        = lib.types.path;
      default     = "/var/lib/goodsync";
      description = "Where gs-server stores its data.";
    };

    openFirewall = lib.mkOption {
      type        = lib.types.bool;
      default     = false;
      description = "Open ports 11000 and 33333 in the firewall.";
    };

  };

  config = lib.mkIf cfg.enable {

    users.users.${cfg.user} = {
      isSystemUser = true;
      group        = cfg.user;
      home         = cfg.dataDir;
    };
    users.groups.${cfg.user} = {};

    systemd.tmpfiles.rules = 
        [
        "d /etc/goodsync  0750 ${cfg.user} ${cfg.user} -"
        "d ${cfg.dataDir} 0750 ${cfg.user} ${cfg.user} -"
        ];

    networking.firewall.allowedTCPPorts =
      lib.mkIf cfg.openFirewall [ 11000 33333 ];

    systemd.services.goodsync = {
    description = "GoodSync Server";
    wantedBy    = [ "multi-user.target" ];
    after       = [ "network.target" ];

    serviceConfig = {
        User      = cfg.user;
        Group     = cfg.user;
        ExecStart = "${pkg}/bin/.gs-server-unwrapped"
                    + " /resources=${pkg}/share/goodsync"
                    + " /profile=${cfg.dataDir}";
        Restart   = "on-failure";
    };
    };

    environment.systemPackages = [ pkg ];

  };
}