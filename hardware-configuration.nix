{ 
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = 
    [ 
      "nvme" 
      "xhci_pci" 
      "ahci" 
      "usbhid" 
      "usb_storage" 
      "sd_mod" 
    ];

  boot.kernelModules = 
    [
      "kvm-amd"
      "nct6775" 
      "nct6687"
    ];

  hardware.graphics = 
    {
      enable = true;
      enable32Bit = true;
    };

  boot.extraModulePackages = 
    [
      config.boot.kernelPackages.nct6687d
    ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/f5e59efc-35ce-42d7-b754-e953a93f43c6";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { 
      device  =   "/dev/disk/by-uuid/9878-EA7A";
      fsType  =   "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  swapDevices = [ ];
  boot.initrd.kernelModules = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

}
