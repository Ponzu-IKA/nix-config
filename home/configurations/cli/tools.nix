{ pkgs, ... }:
{
  home.packages = with pkgs; [
    #   btop
    btop-cuda
    p7zip
    pakku
  ];
}
