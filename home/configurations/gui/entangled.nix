{
  pkgs,
  lib,
  ...
}:
let
  pname = "noita-proxy";
  version = "v1.6.2";
in
{
  home.packages = [
    (pkgs.stdenv.mkDerivation {
      pname = pname;
      version = version;
      src = pkgs.fetchzip {
        url = "https://github.com/IntQuant/noita_entangled_worlds/releases/download/${version}/noita-proxy-linux.zip";
stripRoot=false;
        sha256 = "sha256-08+W4uGTzVrnX4tsnoLFwvEuLPozdJbKAJZQJoqjXBA=";
      };

      installPhase = ''
        mkdir -p $out/bin

        cp libsteam_api.so $out/
        install -m755 noita_proxy.x86_64 $out/${pname}
        cat > $out/bin/${pname} << EOF
        #!/bin/sh
        echo ${pname} ${version}
        exec steam-run $out/${pname} "\$@"
        EOF
        chmod +x $out/bin/${pname}
      '';
    })
  ];
}
