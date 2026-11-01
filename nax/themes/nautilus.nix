# configuration.nix
{ inputs, pkgs, ... }:
let
  nautilusIconTheme = "Adwair";  # or "Adwair-dark"; must match the dir name under share/icons
  nautilusIconPackage = inputs.adwair.packages.${pkgs.stdenv.hostPlatform.system}.default;

  # Compiled dconf db containing only the icon-theme override
  nautilusDb = pkgs.runCommand "nautilus-icon-dconf-db" {
    nativeBuildInputs = [ pkgs.dconf ];
  } ''
    mkdir keyfiles $out
    cat > keyfiles/00-icons <<'EOF'
    [org/gnome/desktop/interface]
    icon-theme='${nautilusIconTheme}'
    EOF
    dconf compile $out/nautilus keyfiles
  '';

  # Default layering, with the override inserted below user-db
  nautilusProfile = pkgs.writeText "nautilus-dconf-profile" ''
    user-db:user
    file-db:${nautilusDb}/nautilus
    system-db:local
  '';
in
{
  nixpkgs.overlays = [
    (final: prev: {
      nautilus = prev.nautilus.overrideAttrs (old: {
        preFixup = (old.preFixup or "") + ''
          gappsWrapperArgs+=(
            --set DCONF_PROFILE ${nautilusProfile}
            --prefix XDG_DATA_DIRS : ${nautilusIconPackage}/share
          )
        '';
      });
    })
  ];
}