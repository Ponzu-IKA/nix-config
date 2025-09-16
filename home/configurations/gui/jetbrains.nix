{ pkgs, lib, ...}:
{      
  home.packages = with pkgs; [
    rustup
    gcc
  ];
  programs.jetbrains-remote = {
    enable = true;
    ides = with pkgs.jetbrains; [
      rust-rover
    ];
  };
}
