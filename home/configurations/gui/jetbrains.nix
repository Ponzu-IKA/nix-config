{ pkgs, lib, ... }:
{
  home.packages = with pkgs.jetbrains; [
    rust-rover
    idea-community-bin
  ];
}
