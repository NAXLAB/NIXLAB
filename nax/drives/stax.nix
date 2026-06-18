{ 
    config, 
    pkgs, 
    ... 
}:

{
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
            "x-systemd.device-timeout=5s"
            "x-systemd.mount-timeout=5s"
            "x-systemd.stop-timeout=5s"
            "_netdev"
            "credentials=/run/agenix/smb"
            "uid=1000"
            "gid=1000"
            "x-systemd.requires=network-online.target"
        ];
    };
}