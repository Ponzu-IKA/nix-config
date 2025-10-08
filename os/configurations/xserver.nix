{
  programs.xwayland = {
    enable = true;
  };

  services.xserver = {
    enable = true;

    xkb = {
      layout = "jp";
      model = "pc104";
    };
  };
}
