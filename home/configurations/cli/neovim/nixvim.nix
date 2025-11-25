{ pkgs, ... }:
{
  home.packages = with pkgs; [
    wl-clipboard
  ];
  programs.nixvim = {
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

    keymaps = [
      {
        mode = "n";
        key = "<F5>";
        action = ":OverseerRun<CR>";
        options.desc = "Build & Run with Overseer";
      }
    ];

    plugins = {
      toggleterm.enable = true;
      quicker.enable = true;
      notify.enable = true;
      transparent = {
        enable = true;
        autoLoad = true;
      };

      remote-nvim = {
        enable = true;
      };
      overseer = {
        enable = true;

        settings = {
          strategy = "toggleterm";
        };

        luaConfig = {
          pre = ''
            local overseer = require("overseer")

                       local file = vim.fn.expand("%:p")
                       local bin = vim.fn.expand("%:p:r")

                       overseer.setup({
                         templates = { "builtin" },
                       })

                       -- C++
                       overseer.register_template({
                         name = "C++ build & run",
                         builder = function()  
                           return {
                             cmd = {"g++"},
                             args = { "-O2", file, "-o", bin },
                             components = {
                               { "on_result_diagnostics_quickfix", open = true },
                               { "on_output_quickfix", open = true, close = true },
                               "default",
                               {
                                 "run_after",
                                 task_names = {"Run compiled binary"}
                              },
                               { "on_complete_dispose", timeout = 1000 },
                             },
                           }
                         end,
                         condition = {
                           filetype = { "cpp" },
                         }
                       })

                       overseer.register_template({
                         name = "Run compiled binary",
                         builder = function()
                         return {
                             cmd = {bin},
                             components = {
                               "default",
                               { "on_complete_dispose", timeout = 1000 },

                             },
                           }
                         end,
                       })
          '';
        };
      };
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
          gopls.enable = true;
          clangd.enable = true;
          jsonls.enable = true;
          ts_ls.enable = true;
          groovyls = {
            enable = true;
            package = null;
            filetypes = [ "groovy" ];
            settings = {
              hostname = "localhost:25564";
            };
          };

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
            "go"
            "javascript"
            "cpp"
            "json"
            "groovy"
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
