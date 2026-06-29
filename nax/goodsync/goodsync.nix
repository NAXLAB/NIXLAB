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
    ExecStartPre = "${pkgs.bash}/bin/bash -c '"
  + "if [ ! -f /etc/goodsync/server/settings.tix ]; then "
  + "${gspkg}/bin/gsync /generate-local-server-user /etc/goodsync/server; "
  + "fi'";
    ExecStart   = "${gspkg}/bin/.gs-server-unwrapped"
                  + " /resources=${gspkg}/share/goodsync"
                  + " /profile=/etc/goodsync/server";
    Restart     = "on-failure";
  };
};

#Runner watches for file changes
systemd.services.goodsync-runner = {
  description = "GoodSync Job Runner";
  wantedBy    = [ "multi-user.target" ];
  after = [ "goodsync.service" "mnt-xdrive.mount" "mnt-zaigomaat.mount" ];
  requires = [ "mnt-xdrive.mount" "mnt-zaigomaat.mount" ];

  serviceConfig = {
    User       = "nax";
    Group      = "users";
    ExecStart = "${gspkg}/bin/gsync /runner";
    Restart   = "always";
    RestartSec = "10s";
    KillMode       = "process";
    TimeoutStopSec = "5s";
  };
};

    #Declare Sync Job
    systemd.services.zaigomaat-sync = {
  description = "GoodSync: declare xdrive <-> zaigomaat sync job";
  wantedBy    = [ "multi-user.target" ];
  after       = [ "goodsync.service" "goodsync-runner.service" ];

  # Run once at boot to create/update the job definition, then exit.
  serviceConfig = 
    {
        Type  = "oneshot";
        User  = "nax";          # same user as goodsync-runner
        Group = "users";
        SuccessExitStatus = [ 255 ]; #Exit Status 255 is interpreted as an error by default, but is actually fine and should be accepted.
        ExecStart = ''
          ${gspkg}/bin/gsync \
            job "zaigomaat-sync" \
            /f1=file:///mnt/xdrive \
            /f2=file:///mnt/zaigomaat \
            /dir=2way \
            /on-file-change=sync \
            /on-folder-connect=sync \
            /auto-unattended=yes \
            /limit-changes=20
            /exclude=\steamapps\compatdata
        '';
    };
};

  environment.systemPackages = [ gspkg ];
}
