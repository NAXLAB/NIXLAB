{ pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
    (pkgs.symlinkJoin {
      name = "mixxx-wrapped";
      paths = [ pkgs.mixxx ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/mixxx \
          --prefix XDG_DATA_DIRS : ${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name} \
          --prefix XDG_DATA_DIRS : ${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}
      '';
    })
  ]

}