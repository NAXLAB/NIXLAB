{ config, pkgs, ... }:

{

systemd.tmpfiles.rules = [
    #Mount X Drive NTFS
    "d /mnt/xdrive 0755 nax wheel -"
    "d /mnt/.dislocker-sda2 0755 root root -"
];

#System utilities for encrypted NTFS Drive
environment.systemPackages = with pkgs; [
    dislocker
    ntfs3g
];

#Declare the agenix secret for X Drive
age.secrets.xdrive = {
  file = ./secrets/xdrive.age;
};

#Decrypt X Drive
systemd.services.dislocker-sda2 = {

  description   =   "Dislocker decrypt sda2";
  after         = [ "sysinit.target" "blockdev@dev-sda2.target" ];
  wants         = [ "blockdev@dev-sda2.target" ];
  wantedBy      = [ "multi-user.target" ];
  
  serviceConfig = {
    Type = "oneshot";
    RemainAfterExit = true;
    ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p /mnt/.dislocker-sda2";
    
    ExecStart = let
      script = pkgs.writeShellScript "dislocker-start" ''
        password=$(cat ${config.age.secrets.xdrive.path})
        ${pkgs.dislocker}/bin/dislocker \
          /dev/disk/by-uuid/cbf23126-f4aa-4938-b32b-ad21a09ca681 \
          --user-password="$password" \
          -- /mnt/.dislocker-sda2 &
        dislocker_pid=$!
        until [ -e /mnt/.dislocker-sda2/dislocker-file ]; do
          kill -0 $dislocker_pid 2>/dev/null || { echo "dislocker exited prematurely" >&2; exit 1; }
        done
      '';
    in "${script}";
    ExecStop = "${pkgs.fuse}/bin/fusermount -u /mnt/.dislocker-sda2";
  };
};

#Mount decrypted X Drive
systemd.mounts = [{
  what      =   "/mnt/.dislocker-sda2/dislocker-file";
  where     =   "/mnt/xdrive";
  type      =   "ntfs-3g";
  options   =   "defaults,uid=1000,gid=1,umask=022,loop,allow_other";
  after     = [ "dislocker-sda2.service" ];
  requires  = [ "dislocker-sda2.service" ];
  wantedBy  = [ "multi-user.target"      ];
}];

}