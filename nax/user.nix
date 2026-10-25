{
  config,
  pkgs,
  inputs,
  ...
}:

{

  #User Profile
  users.users.nax = {
      shell         = pkgs.zsh;
      isNormalUser  = true;
      description   = "Nax Lab";
      extraGroups   = 
        [ 
          "i2c"
          "networkmanager"
          "wheel"
          "libvirt" 
          "qemu-libvirtd"
          "docker"
          "xshare"
        ];
  };

  #App compatibility with symlinked home folders
  home-manager.users.nax.xdg.userDirs = {
    enable              = true;
    setSessionVariables = true;
    createDirectories   = false;
    desktop             = "${config.users.users.nax.home}/Desktop";
    download            = "${config.users.users.nax.home}/Downloads";
    music               = "${config.users.users.nax.home}/Music";
    documents           = "${config.users.users.nax.home}/Documents";
    pictures            = "${config.users.users.nax.home}/Pictures";
  };

  #File System Config
  systemd.tmpfiles.rules = [

    #etc/nixos owned by nax
    "Z /etc/nixos - nax wheel - -"

    #Mount ZaigoMaat SMB share
    "d /mnt/zaigomaat 0755 nax users -"

    #Mount X Drive
    "d /mnt/xdrive 0755 nax users -"

    #Create desktop folders manually
    "d /home/nax/Desktop    0755 nax users -"
    "d /home/nax/Downloads  0755 nax users -"

    #Symlink Desktop folders to X Drive
    "L+ /home/nax/Archives - - - - /mnt/xdrive/Archives"
    "L+ /home/nax/Documents - - - - /mnt/xdrive/Documents"
    "L+ /home/nax/Fonts - - - - /mnt/xdrive/Fonts"
    "L+ /home/nax/Music - - - - /mnt/xdrive/Music"
    "L+ /home/nax/Pictures - - - - /mnt/xdrive/Photos"
    "L+ /home/nax/Torrents - - - - /mnt/xdrive/Torrents"

    #Connect font folder to X Drive
    "L+ /home/nax/.local/share/fonts - - - - /mnt/xdrive/Fonts"

  ];

}