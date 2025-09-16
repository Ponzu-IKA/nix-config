{
  imports = [
    ./cursor.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    extraConfig = ( builtins.readFile ../../../config/hyprland/hyprland.conf );
  };
}
