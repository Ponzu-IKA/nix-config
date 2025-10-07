{ pkgs, ... }:
{
  home.pointerCursor.enable = true;
  home.pointerCursor.name = "Volantes-Cursors";
  home.pointerCursor.package = pkgs.volantes-cursors;
  home.pointerCursor.hyprcursor.enable = true;
  home.packages = with pkgs; [
    volantes-cursors
  ];
}
