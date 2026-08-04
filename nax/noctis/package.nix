{ lib
, stdenv
, fetchurl
, autoPatchelfHook
, makeWrapper
, copyDesktopItems
, makeDesktopItem
, fontconfig
, freetype
, zlib
, bzip2
, libpng
, expat
, brotli
, icu
, openssl
, glib
, libGL
, libX11
, libICE
, libSM
, libXcursor
, libXext
, libXi
, libXrandr
, libvlc
}:

let
  pname = "noctis";
  version = "1.3.8";

  # Upstream publishes a self-contained tarball per RID; no source build needed.
  platforms = {
    x86_64-linux = {
      archive = "Noctis-linux-x64.tar.gz";
      hash = "sha256-kUaeFh50LHtCddYhMg0NhbWNThwrSES6UOlPARj0sAU=";
    };
    aarch64-linux = {
      archive = "Noctis-linux-arm64.tar.gz";
      hash = "sha256-95wI0fkAUH9vZL1O0KUnlzK+N8GrvkhFvN1pD8Jt/nY=";
    };
  };

  plat =
    platforms.${stdenv.hostPlatform.system}
      or (throw "noctis: no prebuilt release published for ${stdenv.hostPlatform.system} (only x86_64-linux and aarch64-linux)");

  # Upstream's self-contained publish embeds all icons as compiled Avalonia
  # resources, so there's nothing to extract from the tarball itself. Grab
  # the app's logo straight from the tagged source instead, for a desktop
  # icon.
  icon = fetchurl {
    url = "https://raw.githubusercontent.com/heartached/Noctis/v${version}/src/Noctis/Assets/Icons/Noctis%20Logo%20Clean.png";
    hash = "sha256-x/Vl3ewFMQ3K+eiEku/UtbPJVD+9PRSz+sy9vZY2JJ8=";
  };
in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/heartached/Noctis/releases/download/v${version}/${plat.archive}";
    hash = plat.hash;
  };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  # The tarball ships its managed .dll assemblies (PE/COFF, not ELF) with
  # the executable bit set, which is an artifact of how `dotnet publish`
  # writes them out. Everything is installed under $out/lib/noctis, which
  # falls inside stdenv's default stripDebugList ("lib", "bin", etc), so
  # without this, the default fixupPhase runs `strip` against those DLLs
  # as if they were native binaries and corrupts their PE headers --
  # manifesting at runtime as "incorrect format" / 0x8007000B when
  # CoreCLR tries to load System.Private.CoreLib.dll. The bundled native
  # .so files are already pre-stripped upstream, so nothing is lost here.
  dontStrip = true;

  # libcoreclrtraceptprovider.so links against liblttng-ust for optional
  # LTTng tracing support. CoreCLR handles its absence gracefully at
  # runtime (tracing is just unavailable) -- but autoPatchelfHook treats
  # every DT_NEEDED as mandatory unless told otherwise, so tell it this
  # one's fine to leave unresolved rather than pulling in lttng-ust just
  # to satisfy a feature nothing here uses.
  autoPatchelfIgnoreMissingDeps = [ "liblttng-ust.so.0" ];

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    copyDesktopItems
  ];

  # Direct ELF (DT_NEEDED) dependencies of the bundled native libs
  # (mainly libSkiaSharp.so). autoPatchelfHook rewrites RPATHs against
  # these automatically.
  buildInputs = [
    stdenv.cc.cc.lib
    fontconfig
    freetype
    zlib
    bzip2
    libpng
    expat
    brotli
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "noctis";
      desktopName = "Noctis";
      genericName = "Music Player";
      comment = "A modern lossless music player";
      exec = "noctis %U";
      icon = "noctis";
      terminal = false;
      categories = [ "Audio" "Music" "Player" "AudioVideo" ];
      startupWMClass = "Noctis";
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/lib/noctis" "$out/bin"
    tar -xzf "$src" -C "$out/lib/noctis"
    chmod -R u+w "$out/lib/noctis"
    chmod +x "$out/lib/noctis/Noctis" "$out/lib/noctis/ffmpeg"

    # LibVLCSharp's native loader (Core.Initialize) resolves the plain
    # names "libvlc" / "libvlccore", which on Linux only round-trip
    # through dlopen("libvlc.so") / dlopen("libvlccore.so") -- the
    # *unversioned* symlinks that upstream distros only ship in their
    # "-dev" packages. nixpkgs' libvlc only carries the versioned
    # libvlc.so.5 / libvlccore.so.9, so materialize the unversioned
    # names ourselves rather than guessing the exact version number.
    mkdir -p "$out/lib/noctis/vlc-shim"
    ln -s "$(find ${libvlc}/lib -maxdepth 1 -name 'libvlc.so.*' | sort -V | tail -1)" \
      "$out/lib/noctis/vlc-shim/libvlc.so"
    ln -s "$(find ${libvlc}/lib -maxdepth 1 -name 'libvlccore.so.*' | sort -V | tail -1)" \
      "$out/lib/noctis/vlc-shim/libvlccore.so"

    install -Dm444 ${icon} "$out/share/icons/hicolor/512x512/apps/noctis.png"

    runHook postInstall
  '';

  # Everything below is dlopen()'d by managed code at runtime (LibVLC,
  # ICU globalization, OpenSSL, and Avalonia's X11/GL backend) rather
  # than linked at the ELF level, so autoPatchelfHook can't discover it
  # on its own -- it has to go on LD_LIBRARY_PATH explicitly.
  postInstall = ''
    makeWrapper "$out/lib/noctis/Noctis" "$out/bin/noctis" \
      --set VLC_PLUGIN_PATH "${libvlc}/lib/vlc/plugins" \
      --prefix LD_LIBRARY_PATH : "$out/lib/noctis/vlc-shim:${lib.makeLibraryPath [
        libvlc
        icu
        openssl
        glib
        libGL
        libX11
        libICE
        libSM
        libXcursor
        libXext
        libXi
        libXrandr
      ]}"
  '';

  meta = {
    description = "Modern lossless music player built on Avalonia with rich library features";
    longDescription = ''
      Noctis is a lossless-first desktop music player (FLAC, ALAC, WAV,
      AIFF, APE, WavPack, plus the usual lossy formats) with a library
      browser, cover flow, synced lyrics, a 10-band equalizer, smart
      playlists, Navidrome/SMB/WebDAV remote sources, Last.fm scrobbling
      and Discord rich presence.

      This derivation repackages upstream's self-contained Linux release
      tarball (autoPatchelf'd for NixOS) rather than building from
      source, since a from-source build would require reproducing a
      NuGet lockfile for the whole dependency graph.
    '';
    homepage = "https://github.com/heartached/Noctis";
    changelog = "https://github.com/heartached/Noctis/releases/tag/v${version}";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    mainProgram = "noctis";
    maintainers = [ ];
  };
}
