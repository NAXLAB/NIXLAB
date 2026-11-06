{ pkgs, ... }:

{

environment.systemPackages = [
  (pkgs.symlinkJoin {
    name = "fontforge-x11";
    paths = [ pkgs.fontforge ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/fontforge --set GDK_BACKEND x11
    '';
  })
];

}
