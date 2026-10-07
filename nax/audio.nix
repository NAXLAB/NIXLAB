  { 
    pkgs,
    config,
    inputs, 
    lib,
    ...
  }:

  {
    
    #Enable Audio Service
    services.pulseaudio.enable  = false;
    security.rtkit.enable       = true;
    services.pipewire = 
      {
        enable                  = true;
        pulse.enable            = true;
        alsa = 
          {
            enable              = true;
            support32Bit        = true;
          };
      };

    #Power Profile Management
    services.power-profiles-daemon.enable = false;
    powerManagement.cpuFreqGovernor = lib.mkForce "performance";

    #Low Latency Configutation Tool
    imports = [ 
      inputs.musnix.nixosModules.musnix
    ];

    musnix = {
      enable = true;
      rtcqs.enable = true; # analyzer that suggests audio-friendly tweaks
    };

    #Audio Management Group
    users.users.nax.extraGroups = [ "audio" ];

  }