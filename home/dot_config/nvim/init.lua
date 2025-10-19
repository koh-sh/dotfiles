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
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
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
      dependencies = { 'nvim-tree/nvim-web-devicons' }
    },
    {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v3.x",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        "nvim-tree/nvim-web-devicons",
      },
      lazy = false,
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
              enabled = true, -- 現在のファイルに自動で追従
              leave_dirs_open = false,
            },
            hijack_netrw_behavior = "open_current",
          },
        })
        
        -- 起動時に自動表示
        vim.api.nvim_create_autocmd("VimEnter", {
          callback = function()
            -- 引数なしで起動した場合のみNeo-treeを表示
            if vim.fn.argc() == 0 then
              vim.cmd("Neotree show")
            else
              vim.cmd("Neotree show")
              vim.cmd("wincmd p") -- ファイルを開いた場合はエディタにフォーカス
            end
          end,
        })
      end,
    },
    {
      "HiPhish/rainbow-delimiters.nvim"
    },
    {
      "neoclide/coc.nvim",
      branch = "release", -- coc.nvimにはbranchの指定を推奨
    }
  },
  install = { colorscheme = { "habamax" } },
  checker = { enabled = true },
})
