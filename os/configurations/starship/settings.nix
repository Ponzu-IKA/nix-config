{
  programs.starship = {
    enable = true;
    settings = {
    format = "$os:$username@$hostname $directory>";
      username = {
        style_user = "green bold";
        style_root = "red bold";
        format = "[$user]($style)";
        show_always = true;
      };

      hostname = {
        ssh_only = false;
        format = "[$ssh_symbol$hostname](bold white)";
      };

      os = {
        disabled = false;
        format = "[$symbol]($style)";
        style = "bold cyan";
      };
    };
  };
}
