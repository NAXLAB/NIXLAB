{ 
  config,
  pkgs,
  inputs, 
  ... 
}:

{

  boot.kernelPackages = pkgs.linuxPackages_7_2;

  # Bootloader
  boot.loader = 
    {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
    };

  #Swapfile
  swapDevices = 
    [
      {
        device = "/swapfile";
        size = 32000; # 32GB in MB
      }
    ];

}