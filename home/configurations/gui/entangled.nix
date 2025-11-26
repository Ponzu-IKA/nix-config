{
  pkgs,
  lib,
  ...
}:

let
  noitaEW = (
    pkgs.stdenv.mkDerivation rec {
      pname = "noita_proxy";
      version = "v1.6.2";

      src = pkgs.fetchzip {
        url = "https://github.com/IntQuant/noita_entangled_worlds/releases/tag/${version}/noita-proxy-linux.zip ";
        sha256 = "sha256-0";
      };

      nativeBuildInputs = with pkgs; [
        makeWrapper
        unzip
      ];

      installPhase = ''
        mkdir -p $out/bin

        install -m755 ${pname} $out/bin/${pname}-real

        wrapProgram $out/bin/${pname}-real --prefix steam-run
      '';
    }
  );
in
{
  home.packages = with pkgs; [ noitaEW ];
}
