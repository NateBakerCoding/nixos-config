{ pkgs, ... }:
{
  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    # System dependencies (language servers, etc.)
    extraPackages = with pkgs; [
      nodePackages.typescript-language-server
      nodePackages.typescript
      nodejs
      rust-analyzer
      lua-language-server
    ];

    plugins = {
      # Existing core plugins
      plenary_nvim = { enable = true; };

      telescope_nvim = {
        enable = true;
        type = "lua";
        config = ''
          local builtin = require("telescope.builtin")
          vim.keymap.set("n", "<leader>pf", builtin.find_files, {})
          vim.keymap.set("n", "<C-p>", builtin.git_files, {})
          vim.keymap.set("n", "<leader>ps", function()
            builtin.grep_string({ search = vim.fn.input("Grep > ") })
          end)
        '';
      };

      vim_moonfly_colors = {
        enable = true;
        type = "lua";
        config = ''
          function ColorMyPencils(color)
            color = color or "moonfly"
            vim.cmd.colorscheme(color)
            vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
            vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
            vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
            vim.api.nvim_set_hl(0, "LineNr", { bg = "none" })
            vim.api.nvim_set_hl(0, "CursorLineNr", { bg = "none" })
            vim.api.nvim_set_hl(0, "VertSplit", { bg = "none" })
            vim.api.nvim_set_hl(0, "ColorColumn", { bg = "none" })
          end
          ColorMyPencils()
        '';
      };

      treesitter = {
        enable = true;
        type = "lua";
        config = ''
          require("nvim-treesitter.configs").setup {
            highlight = {
              enable = true,
              additional_vim_regex_highlighting = false,
            }
          }
          vim.opt.runtimepath:append(vim.fn.stdpath("data") .. "/treesitter")
          require("nvim-treesitter.install").prefer_git = false
        '';
      };

      playground = { enable = true; };

      harpoon = {
        enable = true;
        type = "lua";
        config = ''
          local mark = require("harpoon.mark")
          local ui = require("harpoon.ui")
          vim.keymap.set("n", "<leader>a", mark.add_file)
          vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)
          vim.keymap.set("n", "<C-h>", function() ui.nav_file(1) end)
          vim.keymap.set("n", "<C-t>", function() ui.nav_file(2) end)
          vim.keymap.set("n", "<C-n>", function() ui.nav_file(3) end)
          vim.keymap.set("n", "<C-s>", function() ui.nav_file(4) end)
        '';
      };

      undotree = {
        enable = true;
        type = "lua";
        config = ''
          vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
        '';
      };

      vim_fugitive = {
        enable = true;
        type = "lua";
        config = ''
          vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
        '';
      };

      # LSP and completion related plugins
      mason_nvim             = { enable = true; };
      mason_lspconfig_nvim   = { enable = true; };
      nvim_lspconfig         = { enable = true; };
      lsp_zero_nvim          = { enable = true; };
      luasnip                = { enable = true; };
      nvim_cmp               = { enable = true; };
      cmp_nvim_lsp           = { enable = true; };
      cmp_buffer             = { enable = true; };
      cmp_path               = { enable = true; };
      cmp_calc               = { enable = true; };
      cmp_spell              = { enable = true; };
      cmp_emoji              = { enable = true; };
      cmp_nvim_lua           = { enable = true; };

      # Additional QOL Plugins:
      which_key = {
        enable = true;
        type = "lua";
        config = ''
          require("which-key").setup {}
        '';
      };

      gitsigns = {
        enable = true;
        type = "lua";
        config = ''
          require("gitsigns").setup()
        '';
      };

      null_ls = {
        enable = true;
        type = "lua";
        config = ''
          local null_ls = require("null-ls")
          null_ls.setup({
            sources = {
              null_ls.builtins.formatting.prettier,  -- JS/TS, HTML, CSS, MD
              null_ls.builtins.formatting.black,     -- Python
              null_ls.builtins.formatting.rustfmt,     -- Rust
              null_ls.builtins.formatting.stylua,      -- Lua
              null_ls.builtins.formatting.clang_format -- C
            },
          })
        '';
      };

      chatgpt = {
        enable = true;
        type = "lua";
        config = ''
          require("chatgpt").setup({
            keymaps = {
              submit = "<C-Enter>",
              yank_last = "<leader>gy",
              yank_last_code = "<leader>gc",
              scroll_down = "<C-f>",
              scroll_up = "<C-b>",
              toggle_settings = "<leader>gs",
              new_session = "<leader>gn",
              cycle_windows = "<Tab>"
            },
            chat = {
              keymaps = {
                close = { "<Esc>" },
              },
            },
          })
        '';
      };
    };

    extraConfigLua = ''
      -- Basic settings
      vim.opt.guicursor = ""
      vim.opt.nu = true
      vim.opt.relativenumber = true
      vim.opt.tabstop = 4
      vim.opt.softtabstop = 4
      vim.opt.shiftwidth = 4
      vim.opt.expandtab = true
      vim.opt.smartindent = true
      vim.opt.wrap = false
      vim.opt.swapfile = false
      vim.opt.backup = false
      vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
      vim.opt.undofile = true
      vim.opt.hlsearch = false
      vim.opt.incsearch = true
      vim.opt.termguicolors = true
      vim.opt.scrolloff = 8
      vim.opt.signcolumn = "yes"
      vim.opt.isfname:append("@-@")
      vim.opt.updatetime = 50
      vim.opt.colorcolumn = "80"
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "vim.treesitter.foldexpr()"
      vim.opt.foldlevel = 99
      vim.opt.foldlevelstart = 0

      -- Leader and keymaps
      vim.g.mapleader = " "
      vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

      -- LSP Setup with lsp-zero, now with additional language servers
      local lsp_zero = require("lsp-zero")
      local lspconfig = require("lspconfig")

      lsp_zero.preset("recommended")

      require("mason").setup({})
      require("mason-lspconfig").setup({
        ensure_installed = {
          "ts_ls", "rust_analyzer", "lua_ls",
          "pyright", "sqls", "clangd", "html", "cssls"
        },
        handlers = { lsp_zero.default_setup }
      })

      lsp_zero.set_preferences({
        suggest_lsp_servers = true,
        sign_icons = { error = "E", warn = "W", hint = "H", info = "I" }
      })

      lsp_zero.on_attach(function(client, bufnr)
        local opts = { buffer = bufnr, remap = false }
        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
        vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
        vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
      end)

      -- Completion configuration
      local cmp = require("cmp")
      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-o>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
          { name = "calc" },
          { name = "spell" },
          { name = "emoji" },
          { name = "nvim_lua" },
        }),
      })

      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      lsp_zero.setup({ capabilities = capabilities })

      vim.diagnostic.config({ virtual_text = true })
    '';
  };
}

