{ 
  config,
  pkgs,
  ...
}:

{

  #Mount X Drive NTFS
  systemd.tmpfiles.rules = [
      "d /mnt/xdrive 0755 nax wheel -"
      "d /mnt/.dislocker-sda2 0755 root root -"
  ];

  #System utilities for encrypted NTFS Drive
  environment.systemPackages = with pkgs; [
      dislocker
      ntfs3g
  ];

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
          password=$(cat ${config.age.secrets.xdrive-decrypt.path})
          ${pkgs.dislocker}/bin/dislocker \
            /dev/disk/by-uuid/cbf23126-f4aa-4938-b32b-ad21a09ca681 \
            --user-password="$password" \
            -- /mnt/.dislocker-sda2 &
          dislocker_pid=$!
          until [ -e /mnt/.dislocker-sda2/dislocker-file ]; do
            kill -0 $dislocker_pid 2>/dev/null || { echo "dislocker exited prematurely" >&2; exit 1; }
            sleep 0.2
          done
        '';
      in "${script}";
      ExecStop = "${pkgs.fuse}/bin/fusermount -u /mnt/.dislocker-sda2";
    };
  };

  #Mount decrypted X Drive
  systemd.mounts = [{
    what     = "/mnt/.dislocker-sda2/dislocker-file";
    where    = "/mnt/xdrive";
    type     = "ntfs-3g";
    options  = "defaults,loop,allow_other,uid=1000,gid=100,umask=002";
    after    = [ "dislocker-sda2.service" ];
    requires = [ "dislocker-sda2.service" ];
    wantedBy = [ "multi-user.target" ];
    unitConfig.DefaultDependencies = "no";
  }];

  #Share to Network

  systemd.services.samba-smbd = {
    after = [ "mnt-xdrive.mount" ];
    requires = [ "mnt-xdrive.mount" ];
  };

  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        "workgroup" = "blacksky";
        "server string" = "nixos";
        "security" = "user";
        "map to guest" = "never";
        # Only allow your LAN (adjust to your subnet)
        "hosts allow" = "192.168.88. 127.0.0.1 localhost";
        "hosts deny" = "0.0.0.0/0";
      };
      xdrive = {
        path = "/mnt/xdrive";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "valid users" = "nax";
        "create mask" = "0664";
        "directory mask" = "0775";
      };
    };
  };

  #Declare SMB Password
  systemd.services.samba-set-password-nax = {
    description = "Set Samba password for nax from agenix secret";
    wantedBy = [ "multi-user.target" ];
    before = [ "samba-smbd.service" ];
    wants = [ "samba-smbd.service" ];
    restartTriggers = [ config.age.secrets.xdrive-share.file ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      pw="$(cat ${config.age.secrets.xdrive-share.path})"
      printf '%s\n%s\n' "$pw" "$pw" | ${config.services.samba.package}/bin/smbpasswd -a -s nax
    '';
  };

 #Declare the agenix secret for X Drive
  age.secrets = {
    xdrive-decrypt.file = ../secrets/xdrive-decrypt.age;
    xdrive-share = {
      file              = ../secrets/xdrive-share.age;
      owner             = "root";
      mode              = "0400";
    };
  };
}