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
            "se.sjoerd.lockpicker"              #Reverse engineer Hash codes
            "com.usebottles.bottles"            #Windows App Compatibility Layer
            "space.gaiasky.GaiaSky"             #Interactive Space Map
            "com.odnoyko.valot"                 #Time Tracker
            "net.codelogistics.letters"         #Simple Word Processor
            "de.scrylab.ScryLab"                #Data Analytics
            "com.github.tchx84.Flatseal"        #Manage Flatpak Permissions
            "io.github.nokse22.ultimate-tic-tac-toe" #Tic-Tac-Toe Game"
            "io.github.weiteck.Lyricade"        #Manage Song Lyrics
            "org.gnome.Builder"                 #Build Gnome Apps
            "re.sonny.Workbench"                #Build Gnome Apps
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