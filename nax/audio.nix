  { 
    pkgs,
    config,
    inputs, 
    ...
  }:

  {
    
    #Enable Audio Service
    services.pulseaudio.enable  = false;
    security.rtkit.enable       = true;
    services.pipewire = 
      {
        enable = true;
        pulse.enable = true;
        alsa = 
          {
            enable = true;
            support32Bit = true;
          };
      };

    #Low level hardware control permissions for low latency audio optimization
    security.pam.loginLimits = [
      { domain = "@audio"; item = "memlock"; type = "-"; value = "unlimited"; }
      { domain = "@audio"; item = "rtprio"; type = "-"; value = "99"; }
    ];

  }