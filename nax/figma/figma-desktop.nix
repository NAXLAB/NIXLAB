{ pkgs, ... }:
let
  figma = pkgs.appimageTools.wrapType2 {
    pname = "figma-desktop";
    version = "126.4.11";
    src = pkgs.fetchurl {
      url = "https://github.com/IliyaBrook/figma-linux/releases/download/figma-desktop-126.4.11/figma-desktop-126.4.11-amd64.AppImage";
      hash = "sha256-Yvo2+vvcWsO9gCm5OXGk04qWhvPlKAnzxxepNnH8CpI=";
    };
  };

figma-desktop-entry = pkgs.makeDesktopItem {
  name = "figma-desktop";
  desktopName = "Figma";
  exec = "env FIGMA_USE_WAYLAND=1 figma-desktop %U";  # <--
  icon = "figma";
  comment = "Figma Desktop";
  categories = [ "Graphics" ];
  mimeTypes = [ "x-scheme-handler/figma" ];
  startupWMClass = "Figma";
};
in
{
  environment.systemPackages = [ figma figma-desktop-entry ];
}