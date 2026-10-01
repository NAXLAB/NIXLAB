  #printer.nix

  { 
    pkgs, 
    inputs, 
    ...
  }:

  {
    #Printing
      services.printing = {
        enable          = true;
        drivers         = [ pkgs.brlaser ];
        browsed.enable  = false;
      };

      hardware.printers = {
        ensurePrinters = [
          {
            name = "Brother-HL-L2300D";
            deviceUri = "usb://Brother/HL-L2300D%20series?serial=U63878J5N186821";
            model = "drv:///brlaser.drv/brl2300d.ppd";
          }
        ];
        ensureDefaultPrinter = "Brother-HL-L2300D";
      };
    }