{ pkgs, ... }:
{
  home.packages = with pkgs; [
    wl-clipboard
  ];
  programs.nixvim.config = {
    enable = true;
    defaultEditor = true;

    colorschemes.kanagawa = {
      enable = true;
      settings.theme = "dragon";
    };

    opts = {
      number = true;
      expandtab = true;
      shiftwidth = 2;
      tabstop = 2;
      smartindent = true;
      hlsearch = true;
      incsearch = true;
      clipboard = "unnamedplus";
    };

    plugins = {

      telescope = {
        enable = true;
        settings = {
          defaults = {
            fileIgnorePatterns = [
              "node_modules"
              ".git/"
            ];
          };
        };
      };

      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          sources = [
            {
              name = "nvim_lsp";
              priority = 1000;
            }
            {
              name = "path";
            }
            {
              name = "buffer";
              max_item_count = 5;
            }
            {
              name = "luasnip";
            }
          ];

          mapping = {
            "<C-n>" = "cmp.mapping.select_next_item()";
            "<C-p>" = "cmp.mapping.select_prev_item()";
            "<Tab>" =
              "cmp.mapping(function(fallback) if cmp.visible() then cmp.confirm({ select = true }) else fallback() end end, { 'i', 's' })";
          };
          formatting = {
            expandable_indicator = true;
            fields = [
              "kind"
              "abbr"
              "menu"
            ];
            experimental = {
              ghost_text = true;
            };
          };
        };
      };

      cmp-nvim-lsp.enable = true;
      cmp-buffer.enable = true;
      cmp-path.enable = true;
      luasnip.enable = true;
      lspkind.enable = true;

      lsp = {
        enable = true;
        servers = {
          nixd.enable = true;
          lua_ls.enable = true;
          yamlls.enable = true;
          nil_ls = {
            enable = true;
            settings = {
              nil = {
                completion = {
                  enable = true;
                };
                diagnostics = {
                  ignored = [ "unused_binding" ];
                };
              };
              nix = {
                flake = {
                  autoArchive = true;
                };
              };
            };
          };
          rust_analyzer = {
            enable = true;
            installRustc = true;
            installCargo = true;

          };
        };
      };

      lsp-format.enable = true;
      nvim-autopairs.enable = true;

      treesitter = {
        enable = true;
        settings = {
          ensure_installed = [
            "yaml"
            "toml"
            "nix"
            "lua"
            "rust"
            "javascript"
          ];
          highlight = {
            enable = true;
          };
          indent.enable = true;
        };
      };

    };
  };

}
