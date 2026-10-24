  { 
    pkgs,
    config,
    inputs, 
    ...
  }:
  
  {

    #System & Hardware Services
    systemd.services.systemd-rfkill.enable  = false;
    services.upower.enable                  = true;
    hardware.bluetooth.enable               = false;
    hardware.keyboard.qmk.enable            = true;
    hardware.spacenavd.enable               = true;

    #Mouse Compatibility
    environment.etc."libinput/local-overrides.quirks".text = ''
      [Logitech G502 Wheel Quirk]
      MatchVendor=0x046D
      MatchProduct=0x407F
      MatchUdevType=mouse
      AttrEventCode=-REL_WHEEL_HI_RES;-REL_HWHEEL_HI_RES;
    '';

  }