{ ... }:

{
    services.flatpak = {
        enable = true;
        packages = [
            "io.github.flattool.Warehouse"      #Manage Flatpaks
            "com.surfshark.Surfshark"           #VPN
            "io.github.josephmawa.Gauge"        #Unit Conversion
            "org.gnome.Boxes"                   #Virtual Machines
            "io.github.gaheldev.Millisecond"    #Reduce System Latency
            "com.usebottles.bottles"            #Windows App Compatibility Layer
            "com.odnoyko.valot"                 #Time Tracker
            "com.github.tchx84.Flatseal"        #Manage Flatpak Permissions
            "io.github.weiteck.Lyricade"        #Manage Song Lyrics
            "org.gnome.Builder"                 #Build Gnome Apps
            "re.sonny.Workbench"                #Build Gnome Apps

            #"space.gaiasky.GaiaSky"             #Interactive Space Map
            #"de.scrylab.ScryLab"                #Data Analytics
        ];

        update.auto = {
            enable = true;
            onCalendar = "weekly";
        };
    };

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