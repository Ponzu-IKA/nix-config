{
  programs.xwayland = {
    enable = true;
  };
  
  services.xserver = {
    enable = false;

    xkb = {
      layout = "jp";
      model = "pc104";
    };

  };
}
