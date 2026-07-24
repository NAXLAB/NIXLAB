{ 
    config, 
    pkgs, 
    ... 
}:

{
    environment.systemPackages = with pkgs; [
        samba
        cifs-utils
    ];

    age.secrets.smb = 
    {
        file = ../secrets/smb.age;
        mode = "400";
    };

    fileSystems."/mnt/zaigomaat" = 
    {
        device = "//192.168.88.202/zaigomaat";
        fsType = "cifs";
        options = 
        [
            "credentials=/run/agenix/smb"
            "x-systemd.device-timeout=30s"
            "x-systemd.mount-timeout=30s"
            "x-systemd.stop-timeout=5s"
            "uid=1000"
            "gid=1000"
            "_netdev"
            "noauto" 
            "x-systemd.requires=network-online.target"
            "x-systemd.after=network-online.target"
        ];
    };

    systemd.automounts = [{
    where = "/mnt/zaigomaat";
    wantedBy = [ "multi-user.target" ];
    automountConfig.TimeoutIdleSec = "0";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
  }];

  services.udev.extraRules = ''
  SUBSYSTEM=="block", ENV{ID_FS_UUID}=="cbf23126-f4aa-4938-b32b-ad21a09ca681", ENV{UDISKS_IGNORE}="1"
'';

}