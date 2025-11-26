{
  pkgs,
  lib,
  ...
}:
let
  version = "v1.6.2";
in
{
  home.packages = [
    (pkgs.stdenv.mkDerivation {
      pname = "noita-proxy";
      version = version;
      src = pkgs.fetchzip {
        url = "https://github.com/IntQuant/noita_entangled_worlds/releases/tag/${version}/noita-proxy-linux.zip";
        sha256 = "sha256-1xq67ksmq90mzz0kqiymm8maky7cin6sardwjv397m2qjqkn79hg";
      };

      nativeBuildPackages = with pkgs; [
        makeWrapper
      ];

      installPhase = ''
        mkdir -p $out/bin
        wrapProgram $out/bin/noita-proxy --run 'fastfetch'
      '';
    })
  ];
}
