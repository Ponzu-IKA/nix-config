{ pkgs, ... }:
{
  home.packages = with pkgs; [
    waytrogen
  ];
  services = {
    swww = {
      enable = true;
    };
  };
}
