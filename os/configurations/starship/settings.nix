{
  programs.starship = {
    enable = true;
    settings = {
    #│
    format = ''
┌─\[$directory\](-\[$vcsh$fossil_branch$fossil_metrics$git_branch$git_commit$git_state$git_metrics$git_status$hg_branch\])(-\[$c$cmake$cobol$daml$dart$deno$dotnet$elixier$elm$erlang$fennel$gleam$golang$guix_shell$haskell$haxe$helm$java$julia$kotlin$gradle$lua$nim$nodejs$ocaml$opa$perl$php$pulumi$purescript$python$quatro$raku$rlang$red$ruby$rust$scala$solidity$swift$terraform$typst$vlang$vagrant$zig$buf\])(-\[$time\])
└─\[$os$username@$hostname\]$sudo[](green bold) 
'';
      git_status = {
        style = "cyan bold";
        staged = "[󰸩 +\($count\)](green)";
        modified = "󱞂 ";
        stashed = "󰆧 ";
        ahead = " [$count](green bold)";
        behind = " [$count](red bold)";
      };
      sudo = {
        disabled = false;
      };
      directory = {
        fish_style_pwd_dir_length = 1;
      };
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
        format = "[ ]($style)";
        style = "bold cyan";
      };
    };
  };
}
