  { 
    pkgs,
    config,
    inputs, 
    ...
  }:
  
  {

    #System & Hardware Services
    systemd.services.systemd-rfkill.enable  = false;
    hardware.bluetooth.enable               = false;
    services.upower.enable                  = true;

    #Mouse Compatibility
    environment.etc."libinput/local-overrides.quirks".text = ''
      [Logitech G502 Wheel Quirk]
      MatchVendor=0x046D
      MatchProduct=0x407F
      MatchUdevType=mouse
      AttrEventCode=-REL_WHEEL_HI_RES;-REL_HWHEEL_HI_RES;
    '';

    #AMD Overclocking
    environment.systemPackages = with pkgs; [
      lact
    ];

    systemd.services.lact = {
      description = "AMDGPU Control Daemon";
      after = ["multi-user.target"];
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        ExecStart = "${pkgs.lact}/bin/lact daemon";
      };
      enable = true;
    };

    hardware.amdgpu.overdrive = {
      enable = true;
      ppfeaturemask = "0xffffffff";  # default; unlocks all PowerPlay features
    };

  }