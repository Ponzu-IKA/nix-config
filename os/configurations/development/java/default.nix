{ pkgs, ... }:
let r = pkg :
  pkgs.runCommand "jdk-env" {
    buildInput = pkg;
  }
  '' 
    mkdir -p $out/jdks
    # pkgにあるファイルすべてをout/jdks/pkg.nameに配置.
    # pkg.nameはそのままpackageの名前を取得する.
    # (例: zulu-ca-jdk-17.0.12 )
    ln -s ${pkg}   $out/jdks/${pkg.name}
    '';
in {
  environment.systemPackages = with pkgs; [
    # /run/current-system/sw/jdks配下に生成されるよ.
    zulu21
  ];
  
}
