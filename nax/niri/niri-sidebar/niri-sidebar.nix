{ 
    inputs, 
    pkgs, 
    ... 
}:

{
  environment.systemPackages = 
  [
    (pkgs.rustPlatform.buildRustPackage 
    {
        pname = "niri-sidebar";
        version = "unstable";

        src = pkgs.fetchFromGitHub 
        {
            owner = "Vigintillionn";
            repo = "niri-sidebar";
            rev = "main";
            hash = "sha256-MYP1ZiwV9+yJhl0zpuri6NQkQHlaYZjGBhXpZEaPZyI=";
        };

        cargoLock.lockFile = ./Cargo.lock;

        meta = 
        {
            description = "A lightweight sidebar manager for Niri";
            homepage = "https://github.com/Vigintillionn/niri-sidebar";
            mainProgram = "niri-sidebar";
      };
    })
  ];
}