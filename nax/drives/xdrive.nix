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

}