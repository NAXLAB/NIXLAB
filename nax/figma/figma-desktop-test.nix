{ 
  lib, 
  stdenv, 
  appimageTools, 
  fetchurl, 
  makeWrapper, 
  asar, 
  perl, 
  useSystemTitlebar ? true
}:

let
  pname = "figma-desktop";
  version = "126.4.11";

  upstreamSrc = fetchurl {
    url = "https://github.com/IliyaBrook/figma-linux/releases/download/figma-desktop-${version}/figma-desktop-${version}-amd64.AppImage";
    hash = "sha256-Yvo2+vvcWsO9gCm5OXGk04qWhvPlKAnzxxepNnH8CpI=";
  };

  # Already just an extracted directory (AppRun, desktop file, app.asar, etc.)
  upstreamContents = appimageTools.extractType2 { inherit pname version; src = upstreamSrc; };

  # A copy of upstreamContents with the titlebar patch reversed inside app.asar.
  # No AppImage repacking involved — this stays a plain directory.
  patchedContents = stdenv.mkDerivation {
    pname = "${pname}-client-titlebar-contents";
    inherit version;
    dontUnpack = true;
    nativeBuildInputs = [ asar perl ];

    buildPhase = ''
      runHook preBuild
      cp -r ${upstreamContents} ./contents
      chmod -R u+w ./contents

      asarPath=$(find ./contents -name app.asar | head -1)
      if [[ -z $asarPath ]]; then
        echo "ERROR: could not locate app.asar inside extracted AppImage contents" >&2
        exit 1
      fi
      echo "Found asar at: $asarPath"

      asar extract "$asarPath" ./app-contents

      if ! grep -q 'frame:true' ./app-contents/main.js; then
        echo "ERROR: expected 'frame:true' not found — upstream patch may have changed" >&2
        exit 1
      fi
      sed -i 's/frame:true/frame:!1/g' ./app-contents/main.js
      sed -i 's/titleBarStyle:"default"/titleBarStyle:"hidden"/g' ./app-contents/main.js

      if ! grep -q '__MINIMIZE_CAPTION_BUTTON__' ./app-contents/shell.html; then
        echo "ERROR: expected caption-button CSS not found in shell.html" >&2
        exit 1
      fi
      perl -0777 -pi -e 's/<style>\s*#__MINIMIZE_CAPTION_BUTTON__.*?<\/style>\n?//s' ./app-contents/shell.html

      rm "$asarPath"
      asar pack ./app-contents "$asarPath"
      runHook postBuild
    '';

    installPhase = ''
      cp -r ./contents $out
    '';
  };

  finalContents = if useSystemTitlebar then upstreamContents else patchedContents;
in
appimageTools.wrapAppImage {
  inherit pname version;
  src = finalContents;

  nativeBuildInputs = [ makeWrapper ];

  extraInstallCommands = ''
    install -Dm444 ${upstreamContents}/io.github.nickvdp.figma-desktop-linux.desktop \
      $out/share/applications/figma-desktop.desktop
    install -Dm444 ${upstreamContents}/io.github.nickvdp.figma-desktop-linux.png \
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
} // {
  passthru = { inherit patchedContents upstreamContents; };
}