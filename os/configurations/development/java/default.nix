{ pkgs, lib, ... }:
let r = pkg :
  pkgs.runCommand "jdk-env" {
    buildInput = pkg;
  }
  '' 
    mkdir -p $out/jdks
    ln -s ${pkg}   $out/jdks/${pkg.name}
    '';
in {
  environment.systemPackages = with pkgs; [
    (r zulu8)
    (r zulu17)
    (r zulu21)
  ];
  
}
