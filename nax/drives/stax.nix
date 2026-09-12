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
        "x-systemd.automount"
        "x-systemd.idle-timeout=0"
        "x-systemd.requires=network-online.target"
        "uid=1000"
        "gid=1000"
        "_netdev"
        "noauto"
      ];
  };

  services.udev.extraRules = ''
  SUBSYSTEM=="block", ENV{ID_FS_UUID}=="cbf23126-f4aa-4938-b32b-ad21a09ca681", ENV{UDISKS_IGNORE}="1"
'';

}