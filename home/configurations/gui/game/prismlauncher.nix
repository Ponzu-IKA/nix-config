{ pkgs, ...}:
{
  home.packages = [
    (pkgs.prismlauncher.override {
    jdks = [ pkgs.zulu8 pkgs.zulu17 pkgs.zulu21];
  })];
}
