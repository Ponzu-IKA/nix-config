{
  programs = {
    bash = {
      interactiveShellInit = "fish";
    };

    fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting
        fastfetch --logo-color-1 "#2280ae" --logo-color-2 "#6680ce"
        starship init fish | source
      '';
    };
  };
}
