{ 
    config, 
    pkgs, 
    ... 
}:

{

  fileSystems."/mnt/xdrive" = {
    device = "/dev/disk/by-uuid/b3c268d4-d8d0-4d69-af63-c8f4358b5066";
    fsType = "ext4";
    options = [ "defaults" "noatime" "nofail" "x-gvfs-show" "x-gvfs-name=XDRIVE" ];
  };

  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        "server string" = "zaigomaat";
        "security" = "user";
        "map to guest" = "never";
        # optional: restrict to LAN
         "hosts allow" = "192.168.88. ";
        "hosts deny" = "0.0.0.0/0";
      };

      xdrive = {
        "path" = "/mnt/xdrive";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "valid users" = "nax";
        "force user" = "nax";
        "force group" = "users"; 
        "create mask" = "0644";
        "directory mask" = "0755";
      };
    };
  };


  age.secrets.xdrive-share = {
    file = ../secrets/xdrive-share.age;
    owner = "root";
    mode = "0400";
  };

  # Set the SMB password from the agenix secret
  systemd.services.samba-xdrive-password = {
    description = "Set Samba password for nax from agenix secret";
    wantedBy = [ "multi-user.target" ];
    after = [ "samba-smbd.service" "agenix.service" ];
    requires = [ "samba-smbd.service" ];
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

}