vim.g.mapleader = ','

local Plug = vim.fn['plug#']

vim.call('plug#begin')

Plug('neovim/nvim-lspconfig')
Plug('sickill/vim-monokai')
Plug('nvim-lua/plenary.nvim')
Plug('nvim-telescope/telescope.nvim', { ['tag'] = '0.1.8' })
Plug('nvim-telescope/telescope-fzf-native.nvim', { ['do'] = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release' })
Plug('LnL7/vim-nix')

vim.call('plug#end')

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
vim.keymap.set('n', '<leader>g', '<C-]>')
