-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Basic settings (aligned with vimrc)
-- File Management
vim.opt.fileencoding = "utf-8" -- デフォルトファイルエンコーディング
vim.opt.backup = false         -- バックアップファイル無効
vim.opt.swapfile = false       -- スワップファイル無効
vim.opt.autoread = true        -- 外部変更の自動読み込み
vim.opt.hidden = true          -- 未保存バッファの切り替え許可

-- Interface and Input
vim.opt.showcmd = true         -- 部分コマンド表示
vim.opt.wildmenu = true        -- コマンドライン補完強化
vim.opt.wildmode = "list:longest" -- 全マッチをリスト表示
vim.opt.backspace = "indent,eol,start" -- バックスペース動作
vim.opt.mouse = "a"            -- 全モードでマウス有効
vim.opt.ttimeoutlen = 50       -- キーコード遅延削減
vim.opt.cmdheight = 2          -- メッセージ表示領域拡大

-- Visual Appearance
vim.opt.cursorline = true      -- カレント行ハイライト
vim.opt.cursorcolumn = true    -- カレント列ハイライト
vim.opt.visualbell = true      -- ビジュアルベル
vim.opt.showmatch = true       -- 対応括弧表示
vim.opt.matchtime = 1          -- 括弧表示時間(0.1秒)
vim.opt.laststatus = 2         -- 常にステータスライン表示
vim.opt.display = "lastline"   -- 最終行を可能な限り表示
vim.opt.number = true          -- 行番号表示
vim.opt.signcolumn = "yes"     -- サインカラム常時表示(LSP用)
vim.opt.scrolloff = 8          -- カーソル上下の余白行数
vim.opt.sidescrolloff = 16     -- カーソル左右の余白文字数
vim.opt.ambiwidth = "double"   -- 曖昧幅文字の適切な処理

-- Text Formatting
vim.opt.expandtab = true       -- タブをスペースに変換
vim.opt.tabstop = 2            -- タブ幅
vim.opt.shiftwidth = 2         -- インデント幅
vim.opt.smartindent = true     -- スマートインデント
vim.opt.breakindent = true     -- 折り返し行のインデント保持
vim.opt.showbreak = ">"        -- 折り返し行のプレフィックス

-- Search Behavior
vim.opt.ignorecase = true      -- 検索時大文字小文字無視
vim.opt.smartcase = true       -- 大文字含む場合は区別
vim.opt.incsearch = true       -- インクリメンタル検索
vim.opt.wrapscan = true        -- 検索時にファイル先頭へループ
vim.opt.hlsearch = true        -- 検索結果ハイライト
vim.opt.gdefault = true        -- 置換でg flagをデフォルト有効

-- Performance Optimization
vim.opt.lazyredraw = true      -- マクロ実行中の画面更新抑制
vim.opt.ttyfast = true         -- 高速ターミナル接続
vim.opt.updatetime = 1000      -- スワップファイル書き込み遅延
vim.opt.maxmempattern = 2000000 -- パターンマッチング用メモリ増加
vim.opt.re = 0                 -- 新しい正規表現エンジン
vim.opt.synmaxcol = 200        -- シンタックスハイライトの列数制限

-- Additional settings
vim.opt.termguicolors = true   -- True colorサポート
vim.opt.list = true            -- 不可視文字を表示
vim.opt.listchars = { tab = '>-', trail = '-', nbsp = '+' }

-- Syntax and filetype
vim.cmd("syntax enable")       -- シンタックスハイライト有効
vim.cmd("filetype plugin indent on") -- ファイルタイプ検出と設定

-- Key Mappings
-- Clear search highlighting (from vimrc)
vim.keymap.set('n', '<leader><Space>', ':nohlsearch<CR>', { desc = 'Clear search highlighting' })

-- Window split keymaps
vim.keymap.set('n', '<leader>sv', ':vsplit<CR>', { desc = 'Split window vertically' })
vim.keymap.set('n', '<leader>sh', ':split<CR>', { desc = 'Split window horizontally' })
vim.keymap.set('n', '<leader>se', '<C-w>=', { desc = 'Make splits equal size' })
vim.keymap.set('n', '<leader>sx', ':close<CR>', { desc = 'Close current split' })

-- Window navigation
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Move to left window' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Move to bottom window' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Move to top window' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Move to right window' })

-- Terminal keymaps
vim.keymap.set('n', '<leader>t', ':terminal<CR>', { desc = 'Open terminal' })
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- UI enhancements
    {
      "folke/noice.nvim",
      event = "VeryLazy",
      opts = {},
      dependencies = {
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify",
      }
    },
    {
      'nvim-lualine/lualine.nvim',
      dependencies = { 'nvim-tree/nvim-web-devicons' },
      config = function()
        require('lualine').setup({
          options = {
            theme = 'auto',
            component_separators = '|',
            section_separators = '',
          },
        })
      end,
    },

    -- File explorer
    {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v3.x",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        "nvim-tree/nvim-web-devicons",
      },
      lazy = false,
      keys = {
        { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle Neo-tree" },
      },
      config = function()
        require("neo-tree").setup({
          close_if_last_window = false,
          popup_border_style = "rounded",
          enable_git_status = true,
          enable_diagnostics = true,
          window = {
            position = "left",
            width = 30,
            mapping_options = {
              noremap = true,
              nowait = true,
            },
          },
          filesystem = {
            follow_current_file = {
              enabled = true,
              leave_dirs_open = false,
            },
            hijack_netrw_behavior = "open_current",
          },
        })

        -- 起動時に自動表示
        vim.api.nvim_create_autocmd("VimEnter", {
          callback = function()
            vim.cmd("Neotree show")
            -- ファイルを開いた場合はエディタにフォーカス
            if vim.fn.argc() > 0 then
              vim.cmd("wincmd p")
            end
          end,
        })
      end,
    },

    -- Rainbow delimiters
    {
      "HiPhish/rainbow-delimiters.nvim"
    },

    -- Indent guides
    {
      "lukas-reineke/indent-blankline.nvim",
      main = "ibl",
      opts = {
        indent = {
          char = "|",
        },
        scope = {
          enabled = true,
          show_start = true,
          show_end = false,
        },
      },
    },

    -- Telescope (fuzzy finder)
    {
      'nvim-telescope/telescope.nvim',
      tag = '0.1.8',
      dependencies = {
        'nvim-lua/plenary.nvim',
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      },
      keys = {
        { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
        { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
        { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find buffers" },
        { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
        { "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document symbols" },
        { "<leader>fd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
      },
      config = function()
        require('telescope').setup({
          defaults = {
            mappings = {
              i = {
                ["<C-j>"] = "move_selection_next",
                ["<C-k>"] = "move_selection_previous",
              },
            },
          },
        })
        require('telescope').load_extension('fzf')
      end,
    },

    -- LSP and Mason
    {
      "williamboman/mason.nvim",
      config = function()
        require("mason").setup()
      end,
    },
    {
      "williamboman/mason-lspconfig.nvim",
      dependencies = { "williamboman/mason.nvim" },
      config = function()
        local capabilities = require('cmp_nvim_lsp').default_capabilities()

        require("mason-lspconfig").setup({
          ensure_installed = {
            "gopls",           -- Go
            "pyright",         -- Python
            "ruby_lsp",        -- Ruby
            "terraformls",     -- Terraform
            "ansiblels",       -- Ansible
            "yamlls",          -- YAML
          },
          automatic_installation = true,
          handlers = {
            -- Default handler for all servers
            function(server_name)
              require("lspconfig")[server_name].setup({
                capabilities = capabilities,
              })
            end,
            -- Custom handler for yamlls
            ["yamlls"] = function()
              require("lspconfig").yamlls.setup({
                capabilities = capabilities,
                settings = {
                  yaml = {
                    schemas = {
                      kubernetes = "*.yaml",
                      ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
                      ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
                      ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
                    },
                  },
                },
              })
            end,
          },
        })
      end,
    },
    {
      "neovim/nvim-lspconfig",
      dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
      },
      config = function()
        -- LSP keymaps
        vim.api.nvim_create_autocmd('LspAttach', {
          group = vim.api.nvim_create_augroup('UserLspConfig', {}),
          callback = function(ev)
            local opts = { buffer = ev.buf }
            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
            vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
            vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
            vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
            vim.keymap.set('n', '<leader>f', function()
              vim.lsp.buf.format { async = true }
            end, opts)
          end,
        })

        -- Configure diagnostics display
        vim.diagnostic.config({
          virtual_text = true,
          signs = true,
          update_in_insert = false,
          underline = true,
          severity_sort = true,
          float = {
            border = 'rounded',
            source = 'always',
          },
        })

        -- Diagnostic signs
        local signs = { Error = "E", Warn = "W", Hint = "H", Info = "I" }
        for type, icon in pairs(signs) do
          local hl = "DiagnosticSign" .. type
          vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
        end
      end,
    },

    -- Completion
    {
      "hrsh7th/nvim-cmp",
      dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
      },
      config = function()
        local cmp = require('cmp')
        local luasnip = require('luasnip')

        cmp.setup({
          snippet = {
            expand = function(args)
              luasnip.lsp_expand(args.body)
            end,
          },
          mapping = cmp.mapping.preset.insert({
            ['<C-b>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.abort(),
            ['<CR>'] = cmp.mapping.confirm({ select = true }),
            ['<Tab>'] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
              else
                fallback()
              end
            end, { 'i', 's' }),
            ['<S-Tab>'] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
              else
                fallback()
              end
            end, { 'i', 's' }),
          }),
          sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
            { name = 'buffer' },
            { name = 'path' },
          }),
          formatting = {
            format = function(entry, vim_item)
              vim_item.menu = ({
                nvim_lsp = '[LSP]',
                luasnip = '[Snippet]',
                buffer = '[Buffer]',
                path = '[Path]',
              })[entry.source.name]
              return vim_item
            end,
          },
        })
      end,
    },

    -- Auto-formatting
    {
      "stevearc/conform.nvim",
      event = { "BufWritePre" },
      cmd = { "ConformInfo" },
      keys = {
        {
          "<leader>fm",
          function()
            require("conform").format({ async = true, lsp_fallback = true })
          end,
          mode = "",
          desc = "Format buffer",
        },
      },
      opts = {
        formatters_by_ft = {
          go = { "gofmt", "goimports" },
          python = { "black", "isort" },
          ruby = { "rubocop" },
          terraform = { "terraform_fmt" },
          yaml = { "prettier" },
          json = { "prettier" },
          markdown = { "prettier" },
        },
        format_on_save = {
          timeout_ms = 500,
          lsp_fallback = true,
        },
      },
    },

    -- Markdown preview
    {
      "iamcco/markdown-preview.nvim",
      cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
      ft = { "markdown" },
      build = function() vim.fn["mkdp#util#install"]() end,
      keys = {
        { "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown Preview" },
      },
    },

    -- Diagnostics list
    {
      "folke/trouble.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      keys = {
        { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
        { "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics" },
        { "<leader>xl", "<cmd>Trouble loclist toggle<cr>", desc = "Location List" },
        { "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List" },
      },
      opts = {},
    },

    -- Claude Code
    {
      "coder/claudecode.nvim",
      dependencies = { "folke/snacks.nvim" },
      config = true,
      keys = {
        { "<leader>a", nil, desc = "AI/Claude Code" },
        { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
        { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
        { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
        { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
        { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
        { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
        { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
        { "<leader>as", "<cmd>ClaudeCodeTreeAdd<cr>", desc = "Add file",
          ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" } },
        { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
        { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
      },
    }
  },
  install = { colorscheme = { "habamax" } },
  checker = { enabled = true },
})
