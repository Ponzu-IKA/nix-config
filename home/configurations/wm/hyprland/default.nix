{
  imports = [
    ./cursor.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;

    package = null;
    portalPackage = null;

    extraConfig = (builtins.readFile ../../../config/hyprland/hyprland.conf);
    /*
      systemd.variables = [ "--all" ];
      systemd.enable = true;
    */
  };

}
