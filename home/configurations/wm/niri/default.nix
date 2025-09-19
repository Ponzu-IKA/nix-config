{ pkgs, ... }:
{
  home.packages = with pkgs; [
    niri
    xwayland-satellite
  ];
}
