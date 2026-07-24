{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  wrapGAppsHook4,
  glib,
  gtkmm4,
  libadwaita,
  libsoup_3,
  cairo,
  nlohmann_json,
  rclone,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mtsync";
  version = "0.9.13";

  src = fetchFromGitHub {
    owner = "gavindi";
    repo = "MtSync";
    tag = finalAttrs.version;
    hash = "sha256-CvKa5q5ODJx0w+jH80QgF0f7j/UIB6HJI3Eb6ywP53g=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    glib
    wrapGAppsHook4
  ];

  buildInputs = [
    gtkmm4
    libadwaita
    libsoup_3
    cairo
    nlohmann_json
  ];

  cmakeBuildType = "Release";

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : ${lib.makeBinPath [ rclone ]}
    )
  '';

  meta = {
    description = "GTK4/libadwaita frontend to rclone, for mounting and syncing network storage";
    homepage = "https://github.com/gavindi/MtSync";
    changelog = "https://github.com/gavindi/MtSync/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    mainProgram = "mtsync";
  };
})