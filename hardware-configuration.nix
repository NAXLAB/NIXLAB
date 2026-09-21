{ 
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{

  boot.kernelParams = [ "amd_iommu=on" ];

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
      "i2c-dev"
    ];

  boot.extraModulePackages = 
    [
      config.boot.kernelPackages.nct6687d
    ];

  boot.initrd.kernelModules =
    [ 
      "amdgpu"
    ];

  hardware.graphics = 
    {
      enable      = true;
      enable32Bit = true;
	    extraPackages = with pkgs;
        [
		      mesa
		    ];
    };

fileSystems."/" =
    { device = "/dev/disk/by-uuid/56f4064e-08de-4aba-8c97-bff99cd7b16c";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/770D-0260";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

}
