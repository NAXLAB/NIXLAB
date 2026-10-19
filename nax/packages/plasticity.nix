{ pkgs, ... }:

{

    environment.systemPackages = [
        pkgs.plasticity
    ];

    nixpkgs.overlays = [
        (final: prev: {
        plasticity = prev.plasticity.overrideAttrs (old: {
            nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ final.makeWrapper ];
            postFixup = (old.postFixup or "") + ''
            wrapProgram $out/bin/Plasticity \
                --add-flags "--ozone-platform=wayland" \
                --prefix LD_LIBRARY_PATH : "${final.libglvnd}/lib"
            '';
        });
        })
    ];
}