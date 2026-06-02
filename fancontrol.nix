{ config, pkgs, ... }:

{
  boot.kernelModules = [ "nct6775" ];

  services.fan2go = {
    enable = true;
    config = {
      fans = [
        {
          id = "case_fans";
          hwmon = {
            platform = "nct6799";
            channel = 1;
            pwmChannel = 1;
          };
        }
      ];
      sensors = [
        {
          id = "gpu_junction";
          hwmon = {
            platform = "amdgpu";
            channel = 1;
            tempChannel = 2;
          };
        }
      ];
      curves = [
        {
          id = "gpu_curve";
          linear = {
            sensor = "gpu_junction";
            steps = {
              "30" = 0;
              "60" = 20;
              "70" = 40;
              "80" = 60;
              "90" = 100;
            };
          };
        }
      ];
      fanControls = [
        {
          fan = "case_fans";
          curve = "gpu_curve";
        }
      ];
    };
  };
}