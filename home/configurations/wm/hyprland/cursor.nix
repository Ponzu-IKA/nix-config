{ pkgs, ...}:
{
  home.pointerCursor.name = "Volantes-Cursors";
  home.pointerCursor.package = pkgs.volantes-cursors;
  home.packages = with pkgs; [
    volantes-cursors
  ];
}
