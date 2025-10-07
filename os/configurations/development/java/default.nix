{ pkgs, ... }:

let
  r =
    pkg:
    pkgs.runCommand "jdk-env"
      {
        buildInput = pkg;
      }
      ''
        mkdir -p $out/jdks
        # pkgにあるファイルすべてをout/jdks/pkg.nameに配置.
        # pkg.nameはそのままpackageの名前を取得する.
        # (例: zulu-ca-jdk-17.0.12 )
        ln -s ${pkg}   $out/jdks/${pkg.name}
      '';
in
{
  environment.systemPackages = with pkgs; [
    (r zulu25)
    (r zulu21)
    (r zulu17)
    (r zulu8)
  ];

}
