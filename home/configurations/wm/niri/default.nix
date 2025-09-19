{ pkgs, ... }:
{
  home.packages = with pkgs; [
    niri
  ];
}
