{ config, pkgs, inputs, ... }:


#Set up virtualisation
virtualisation.libvirtd = {
    enable = true;

    # Enable TPM emulation (for Windows 11)
    qemu = {
      swtpm.enable = true;
      ovmf.packages = [ pkgs.OVMFFull.fd ];
    };
  };

  # Enable USB redirection
  virtualisation.spiceUSBRedirection.enable = true;
}

# Allow VM management
users.groups.libvirtd.members = [ "your-account-here" ];
users.groups.kvm.members = [ "your-account-here" ];

# Enable VM networking and file sharing
environment.systemPackages = with pkgs; [
    # ... your other packages ...
    gnome-boxes # VM management
    dnsmasq # VM networking
    phodav # (optional) Share files with guest VMs
];

