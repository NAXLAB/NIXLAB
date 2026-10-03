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


    imports = [ 

      inputs.musnix.nixosModules.musnix

    ];

    #Low Latency Configutation Tool
    musnix = {

      enable = true;

      # Optional: real-time kernel (rebuilds your kernel)
      #kernel.realtime = true;
      #kernel.packages = pkgs.linuxPackages_latest;  # mainline >= 6.12 gets PREEMPT_RT natively

      # Optional extras
      rtcqs.enable = true;               # analyzer that suggests audio-friendly tweaks
      
  };

  #Audio Management Group
  users.users.nax.extraGroups = [ "audio" ];

  }