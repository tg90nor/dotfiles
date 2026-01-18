vim.g.mapleader = ','

-- Install lazy.nvim if you haven't already
local lazypath = vim.fn.stdpath("data").. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugin configuration using lazy.nvim
require("lazy").setup({
  spec = {
    { "github/copilot.vim" },
    { "ku1ik/vim-monokai" },
    { "LnL7/vim-nix" },
    { "neovim/nvim-lspconfig" },
    { "nvim-lua/plenary.nvim" },
    { "nvim-telescope/telescope.nvim", tag = "0.1.8" },
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
    },
    { "rhysd/conflict-marker.vim" },
    { import = "plugins" },
  },
})

local lspconfig = require("lspconfig")

lspconfig.gopls.setup({
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
      gofumpt = true,
    },
  },
})

lspconfig.terraformls.setup{}
vim.api.nvim_create_autocmd({"BufWritePre"}, {
  pattern = {"*.tf", "*.tfvars"},
  callback = function()
    vim.lsp.buf.format()
  end,
})

local telescope = require('telescope')
telescope.setup {
  pickers = {
    find_files = {
      find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
    }
  }
}

local tsco_builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', tsco_builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', tsco_builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', tsco_builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', tsco_builtin.help_tags, { desc = 'Telescope help tags' })

vim.opt.undofile = true
vim.opt.tabstop=2
vim.opt.shiftwidth=2
vim.opt.softtabstop=2
vim.opt.expandtab = true
vim.opt.number = true
vim.opt.ruler = true
vim.opt.cc = { 80, 140 }
--vim.opt.backspace = { 'indent', 'start' }
vim.opt.mouse = ''
vim.opt.guicursor = ''
vim.cmd 'colorscheme monokai'
vim.api.nvim_set_hl(0, 'Normal', { ctermbg="None", bg="None" })
vim.keymap.set('n', '<leader>g', '<C-]>')

if os.getenv("VIM_PROJECT_INDENT_STYLE") == "tabs" then
  print("Applying project-specific tab settings.")
  vim.opt.expandtab = false
end
