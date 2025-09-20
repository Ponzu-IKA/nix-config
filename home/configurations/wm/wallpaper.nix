{ pkgs, ... }:
{
  home.packages = with pkgs; [
    waytrogen
  ];
  services.hyprpaper = {
    enable = true;
  };
}
