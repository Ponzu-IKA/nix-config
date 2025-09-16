{ pkgs, ...}:
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };

  programs.nixvim = {
    enable = true;
    
    defaultEditor = true;
    extraPlugins = [ pkgs.vimPlugins.kanagawa-nvim ];
    colorschemes.kanagawa = {
      enable = true;
      settings.theme = "wave";
      autoLoad = true;
    };
  };
}
