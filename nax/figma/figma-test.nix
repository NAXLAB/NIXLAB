# figma-desktop.nix
{ lib
, stdenv
, appimageTools
, fetchFromGitHub
, fetchurl
, nodejs_24
, p7zip
, imagemagick
, wget
, cacert
, makeWrapper
, autoPatchelfHook
, zlib
, unixtools
}:

let
  pname = "figma-desktop";
  version = "126.4.11-patched";

  figma-linux-src = fetchFromGitHub {
    owner = "IliyaBrook";
    repo = "figma-linux";
    rev = "figma-desktop-126.4.11";
    hash = "sha256-C+SmUbTJ6qbuPUyDF28Td4wcVLeF/KtmD9w9Qf+6IgM=";
  };

  # --- Appimagetool for NixOS ---
  appimagetool-src = fetchurl {
    url = "https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage";
    hash = "sha256-uQ9KixiWdUX9p4pEWydoChZC8e+UiM7Si2U5jyvnrdI=";
  };

  appimagetool-appdir = appimageTools.extract {
    pname = "appimagetool";
    version = "continuous";
    src = appimagetool-src;
  };

  appimagetool = stdenv.mkDerivation {
    pname = "appimagetool";
    version = "continuous";
    dontUnpack = true;
    nativeBuildInputs = [ autoPatchelfHook ];
    buildInputs = [ zlib ];
    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r ${appimagetool-appdir}/. $out/
      chmod -R u+w $out
      mkdir -p $out/bin
      ln -s $out/usr/bin/appimagetool $out/bin/appimagetool
      runHook postInstall
    '';
  };

  figma-appimage-patched = stdenv.mkDerivation {
    pname = "figma-desktop-appimage-patched";
    inherit version;
    src = figma-linux-src;

    nativeBuildInputs = [ nodejs_24 p7zip imagemagick wget cacert unixtools.getent makeWrapper appimagetool ];

    postPatch = ''
      # 1. Fix @electron/asar version drift (same as before)
      
      substituteInPlace build.sh \
        --replace "echo 'Electron and Asar installation command finished.'" \
          "echo 'Electron and Asar installation command finished.'
      sed -i 's/throw new HeaderValidationError(entryPath, .*);/return;/' \"\$work_dir/node_modules/@electron/asar/lib/disk.js\" || true
      sed -i \"1s|^#!.*|#!${nodejs_24}/bin/node|\" \"\$work_dir/node_modules/@electron/asar/bin/asar.mjs\" || true
      find \"\$work_dir/node_modules/.bin\" -type f 2>/dev/null | while read -r f; do
        sed -i \"1s|^#!/usr/bin/env node|#!${nodejs_24}/bin/node|\" \"\$f\" || true
      done"

      # 2. Skip native-frame patches so Figma's custom titlebar survives
      substituteInPlace build.sh \
        --replace 'sed -i '"'"'s/frame:!1/frame:true/g'"'"' "$main_js"' \
          'true # frame:!1 patch skipped (keep custom titlebar)'
      substituteInPlace build.sh \
        --replace 'sed -i '"'"'s/frame:!0/frame:true/g'"'"' "$main_js"' \
          'true # frame:!0 patch skipped (keep custom titlebar)'
      substituteInPlace build.sh \
        --replace 'sed -i '"'"'s/frame[[:space:]]*:[[:space:]]*false/frame:true/g'"'"' "$main_js"' \
          'true # frame:false patch skipped (keep custom titlebar)'
      substituteInPlace build.sh \
        --replace 'sed -i '"'"'s/titleBarStyle:"hidden"/titleBarStyle:"default"/g'"'"' "$main_js"' \
          'true # titleBarStyle patch skipped (keep custom titlebar)'
      substituteInPlace build.sh \
        --replace 'sed -i '"'"'s/frame:!1/frame:true/g'"'"' "$shell_js"' \
          'true # frame:!1 patch skipped in shell_js (keep custom titlebar)'
      substituteInPlace build.sh \
        --replace 'sed -i '"'"'s/frame:!0/frame:true/g'"'"' "$shell_js"' \
          'true # frame:!0 patch skipped in shell_js (keep custom titlebar)'
    '';

    buildPhase = ''
      runHook preBuild
      export HOME=$TMPDIR
      export SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt
      patchShebangs .
      ./build.sh
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      appimg=$(find . -maxdepth 3 -name '*.AppImage' -print -quit)
      [ -n "$appimg" ] || { echo "build.sh produced no .AppImage — check log above" >&2; exit 1; }
      cp "$appimg" $out
      runHook postInstall
    '';

    outputHashMode = "flat";
    outputHashAlgo = "sha256";
    outputHash = lib.fakeHash; # this WILL need to be re-derived since output changed
  };

  appimageContents = appimageTools.extractType2 { inherit pname version; src = figma-appimage-patched; };
in
appimageTools.wrapType2 {
  inherit pname version;
  src = figma-appimage-patched;

  nativeBuildInputs = [ makeWrapper ];

  extraInstallCommands = ''
    install -Dm444 ${appimageContents}/io.github.nickvdp.figma-desktop-linux.desktop \
        $out/share/applications/figma-desktop.desktop
    install -Dm444 ${appimageContents}/io.github.nickvdp.figma-desktop-linux.png \
        $out/share/icons/hicolor/256x256/apps/io.github.nickvdp.figma-desktop-linux.png
    substituteInPlace $out/share/applications/figma-desktop.desktop \
        --replace 'Exec=AppRun %u' 'Exec=figma-desktop %u'
  '';

  meta = with lib; {
    description = "Figma desktop client (self-built from source, custom titlebar)";
    homepage = "https://github.com/IliyaBrook/figma-linux";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    mainProgram = "figma-desktop";
  };
}