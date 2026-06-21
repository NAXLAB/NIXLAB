{
    stdenv,
    fetchurl,
    autoPatchelfHook,
    makeWrapper,
    glibc,
    libxcrypt-legacy,
    gcc-unwrapped,
    lib 
}:

stdenv.mkDerivation
{
    pname   = "gsync";
    version = "12.11.2";
    
    src = fetchurl 
        {
            url  = "https://www.goodsync.com/download/goodsync-release-x86_64.tar.gz";
            hash = "sha256-s1HHhWnEqGXB27pzzSRHLIXFscyz0xKF3Z9ccmjoL/0=";
        };

    nativeBuildInputs = 
        [ 
            autoPatchelfHook
            makeWrapper
        ];

    buildInputs = 
        [ 
            glibc 
            libxcrypt-legacy 
            gcc-unwrapped
        ];

    installPhase = 
        ''
            install -Dm755 gsync            $out/bin/gsync
            install -Dm755 gscp             $out/bin/gscp
            install -Dm755 gs-server        $out/bin/.gs-server-unwrapped
            install -Dm644 gs-server.crt    $out/share/goodsync/gs-server.crt
            install -Dm644 gs-server.key    $out/share/goodsync/gs-server.key

            mkdir -p                        $out/share/goodsync
            cp -r html-templates            $out/share/goodsync/    

            makeWrapper $out/bin/.gs-server-unwrapped $out/bin/gs-server \
            --add-flags "/resources=$out/share/goodsync" \
            --add-flags '/profile=$HOME/.config/goodsync'         
            
        '';

    meta = with lib; 
        {
            description      = "GoodSync command-line sync tool and web GUI";
            homepage         = "https://www.goodsync.com/platforms/unix";
            license          = licenses.unfree;
            platforms        = [ "x86_64-linux" ];
            sourceProvenance = with sourceTypes; [ binaryNativeCode ];
        };
}