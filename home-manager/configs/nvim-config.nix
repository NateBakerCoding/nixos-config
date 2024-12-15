{pkgs, ...}: 
let
  customVimPlugins = pkgs.vimPlugins;
in
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    # Add required system dependencies
    extraPackages = with pkgs; [
      # Language servers and their dependencies
      nodePackages.typescript-language-server
      nodePackages.typescript
      nodejs
      # Rust
      rust-analyzer
      # Lua
      lua-language-server
    ];

    plugins = with pkgs.vimPlugins; [
      # Core plugins
      plenary-nvim
      {
        plugin = telescope-nvim;
        type = "lua";
        config = ''
          local builtin = require('telescope.builtin')
          vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
          vim.keymap.set('n', '<C-p>', builtin.git_files, {})
          vim.keymap.set('n', '<leader>ps', function() 
            builtin.grep_string({ search = vim.fn.input('Grep > ')})
          end)
        '';
      }
      {
        plugin = customVimPlugins.vim-moonfly-colors;
        type = "lua";
        config = ''
          function ColorMyPencils(color)
            color = color or 'moonfly'
            vim.cmd.colorscheme(color)
            -- Make background transparent
            vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' }) 
            vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
            -- Make sign column transparent
            vim.api.nvim_set_hl(0, 'SignColumn', { bg = 'none' })
            -- Make line number column transparent
            vim.api.nvim_set_hl(0, 'LineNr', { bg = 'none' })
            vim.api.nvim_set_hl(0, 'CursorLineNr', { bg = 'none' })
            -- Make the vertical split line transparent
            vim.api.nvim_set_hl(0, 'VertSplit', { bg = 'none' })
            -- Make the color column transparent
            vim.api.nvim_set_hl(0, 'ColorColumn', { bg = 'none' })
          end
          ColorMyPencils()
        '';
      }
      # Treesitter and syntax
      {
        plugin = nvim-treesitter.withAllGrammars;
        type = "lua";
        config = ''
          require('nvim-treesitter.configs').setup {
            highlight = {
              enable = true,
              additional_vim_regex_highlighting = false,
            }
          }

          -- Set parser installation directory
          vim.opt.runtimepath:append(vim.fn.stdpath("data") .. "/treesitter")
          require("nvim-treesitter.install").prefer_git = false
        '';
      }
      playground
      {
        plugin = harpoon;
        type = "lua";
        config = ''
          local mark = require('harpoon.mark')
          local ui = require('harpoon.ui')
          vim.keymap.set('n', '<leader>a', mark.add_file)
          vim.keymap.set('n', '<C-e>', ui.toggle_quick_menu)
          vim.keymap.set('n', '<C-h>', function() ui.nav_file(1) end)
          vim.keymap.set('n', '<C-t>', function() ui.nav_file(2) end)
          vim.keymap.set('n', '<C-n>', function() ui.nav_file(3) end)
          vim.keymap.set('n', '<C-s>', function() ui.nav_file(4) end)
        '';
      }
      {
        plugin = undotree;
        type = "lua";
        config = ''
          vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)
        '';
      }
      {
        plugin = vim-fugitive;
        type = "lua";
        config = ''
          vim.keymap.set('n', '<leader>gs', vim.cmd.Git)
        '';
      }

      # LSP and completion
      mason-nvim
      mason-lspconfig-nvim
      nvim-lspconfig
      lsp-zero-nvim
      luasnip
      
      # Completion sources
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-calc
      cmp-spell
      cmp-emoji
      cmp-nvim-lua
    ];

    extraLuaConfig = ''
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

      -- Keymaps
      vim.g.mapleader = " "
      vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

      -- LSP Setup
      local lsp_zero = require('lsp-zero')
      local lspconfig = require('lspconfig')

      lsp_zero.preset("recommended")

      -- Mason setup first
      require('mason').setup({})
      require('mason-lspconfig').setup({
        ensure_installed = {
          'ts_ls',
          'rust_analyzer',
          'lua_ls',
        },
        handlers = {
          lsp_zero.default_setup,
        }
      })

      lsp_zero.set_preferences({
        suggest_lsp_servers = true,
        sign_icons = {
          error = 'E',
          warn = 'W',
          hint = 'H',
          info = 'I'
        }
      })

      lsp_zero.on_attach(function(client, bufnr)
        local opts = {buffer = bufnr, remap = false}
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

      -- Completion setup
      local cmp = require('cmp')
      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-o>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer' },
          { name = 'path' },
          { name = 'calc' },
          { name = 'spell' },
          { name = 'emoji' },
          { name = 'nvim_lua' },
        }),
      })

      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      lsp_zero.setup({ capabilities = capabilities })

      vim.diagnostic.config({
        virtual_text = true
      })
    '';
  };
}
