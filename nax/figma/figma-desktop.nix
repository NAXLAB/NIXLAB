# figma-desktop.nix
{ lib, appimageTools, fetchurl, makeWrapper }:

let
  pname = "figma-desktop";
  version = "126.4.11";

  src = fetchurl {
    url = "https://github.com/IliyaBrook/figma-linux/releases/download/figma-desktop-${version}/figma-desktop-${version}-amd64.AppImage";
    hash = "sha256-Yvo2+vvcWsO9gCm5OXGk04qWhvPlKAnzxxepNnH8CpI=";
  };

  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  nativeBuildInputs = [ makeWrapper ];

  extraInstallCommands = ''
    install -Dm444 ${appimageContents}/io.github.nickvdp.figma-desktop-linux.desktop \
      $out/share/applications/figma-desktop.desktop
    install -Dm444 ${appimageContents}/io.github.nickvdp.figma-desktop-linux.png \
      $out/share/icons/hicolor/256x256/apps/io.github.nickvdp.figma-desktop-linux.png

    substituteInPlace $out/share/applications/figma-desktop.desktop \
      --replace 'Exec=AppRun %u' 'Exec=figma-desktop %u'

    wrapProgram $out/bin/figma-desktop \
      --add-flags "--ozone-platform=wayland --enable-features=WaylandWindowDecorations"
  '';

  meta = with lib; {
    description = "Unofficial Figma desktop client (community AppImage build)";
    homepage = "https://github.com/IliyaBrook/figma-linux";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    mainProgram = "figma-desktop";
  };
}