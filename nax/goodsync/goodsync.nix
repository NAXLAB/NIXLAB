{ pkgs, lib, ... }:

let
  gspkg = pkgs.callPackage ./gs-package.nix {};
in {

  users.users.goodsync = {
    isSystemUser = true;
    group        = "goodsync";
    home         = "/etc/goodsync";
  };
  users.groups.goodsync = {};

  systemd.tmpfiles.rules = [
    "d /etc/goodsync        0775 goodsync goodsync -"
    "d /etc/goodsync/server 0775 goodsync goodsync -"
  ];

  systemd.services.goodsync = {
    description = "GoodSync Server";
    wantedBy    = [ "multi-user.target" ];
    after       = [ "network.target" ];

    serviceConfig = {
      User        = "goodsync";
      Group       = "goodsync";
      Environment = "GS_OS_SERVER_PROFILE=/etc/goodsync";
      ExecStartPre = "${gspkg}/bin/gsync /generate-local-server-user /etc/goodsync/server";
      ExecStart   = "${gspkg}/bin/.gs-server-unwrapped"
                    + " /resources=${gspkg}/share/goodsync"
                    + " /profile=/etc/goodsync/server";
      Restart     = "on-failure";
    };
  };

  environment.systemPackages = [ gspkg ];
}
