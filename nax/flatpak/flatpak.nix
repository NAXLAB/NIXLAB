{ ... }:

{
    # Enable flatpak (standard NixOS option)
    services.flatpak.enable = true;

    # nix-flatpak extends services.flatpak with these extra options:
    services.flatpak.remotes = [
        {
            name = "flathub";
            location = "https://flathub.org/repo/flathub.flatpakrepo";
        }
    ];

    #Allow FlatPaks to see fonts
    fonts.fontDir.enable = true;

    # Optional: auto-update on rebuild
    services.flatpak.update.onActivation = true;
}