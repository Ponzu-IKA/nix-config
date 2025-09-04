{
  programs = {
    bash = {
      interactiveShellInit = "fish";
    };

    fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting
        fastfetch
        starship init fish | source
      '';
    };
  };
}
