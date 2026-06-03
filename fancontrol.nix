{ config, pkgs, ... }:

{
  boot.kernelModules = [ "nct6775" ];

  environment.etc."fan2go/fan2go.yaml".text = ''
    dbPath: /var/lib/fan2go/fan2go.db
    runFanInitializationInParallel: false

    fans:
      - id: case_fans
        hwmon:
          platform: nct6799
          rpmChannel: 1
          pwmChannel: 1
        curve: gpu_curve

    sensors:
      - id: gpu_junction
        hwmon:
          platform: amdgpu
          index: 1

    curves:
      - id: gpu_curve
        linear:
          sensor: gpu_junction
          steps:
            - 30: 0
            - 60: 20
            - 70: 40
            - 80: 60
            - 90: 100
  '';

  systemd.services.fan2go = {
    description = "fan2go fan control daemon";
    after = [ "systemd-modules-load.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.fan2go}/bin/fan2go -c /etc/fan2go/fan2go.yaml --no-style";
      Restart = "always";
      RestartSec = 10;
      StateDirectory = "fan2go";
    };
  };
}
