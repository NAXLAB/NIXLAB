{ pkgs, inputs, ... }:
{

nix.settings = {
  extra-substituters = [ "https://noctalia.cachix.org" ];
  extra-trusted-public-keys = [
    "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
  ];
};

  #Install Noctalia & Quickshell
  environment.systemPackages = [
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    pkgs.quickshell
  ];

  #Start Noctalia as a system service
  systemd.user.services.noctalia-shell = {
    description = "Noctalia Shell";
    after = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/noctalia-shell";
      Restart = "on-failure";
      RestartSec = 3;
      Environment = "PATH=/run/current-system/sw/bin:/usr/bin:/bin";
    };
  };

  systemd.tmpfiles.rules = [
    "d /home/nax/.config/noctalia 0755 nax users -"
    "L+ /home/nax/.config/noctalia/colors.json - - - - /etc/nixos/nax/noctalia/colors.json"
    "L+ /home/nax/.config/noctalia/settings.json - - - - /etc/nixos/nax/noctalia/settings.json"
    "L+ /home/nax/.config/noctalia/colorschemes - - - - /etc/nixos/nax/noctalia/colorschemes"
  ];
}