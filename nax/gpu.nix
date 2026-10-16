{ 
  pkgs,
  config,
  inputs, 
  ...
}:

{

    boot.initrd.kernelModules =
    [ 
      "amdgpu"
    ];

  hardware.graphics = 
    {
      enable      = true;
      enable32Bit = true;
	    extraPackages = with pkgs;
        [
		      mesa
		    ];
    };

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