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

            "x-systemd.device-timeout=5s"
            "x-systemd.mount-timeout=5s"
            "x-systemd.stop-timeout=5s"

            "uid=1000"
            "gid=1000"

            "x-systemd.requires=network-online.target"
            "x-systemd.after=network-online.target" 

            "x-systemd.automount"
            "_netdev"
            "noauto"

        ];
    };

    systemd.automounts = [{
    where = "/mnt/zaigomaat";
    automountConfig.TimeoutIdleSec = "0";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
  }];

}