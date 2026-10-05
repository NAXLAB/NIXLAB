  { 
    pkgs,
    config,
    inputs, 
    ...
  }:

  {

    #Networking
    services.openssh.enable           = true;
    networking.hostName               = "zaigomaat";
    networking.networkmanager = {
      enable = true;
      plugins = [ pkgs.networkmanager-openvpn ];
    };

  }