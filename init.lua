vim.loader.enable()

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require('core.options').setup()
require('core.keymaps').setup()
require('core.autocmds').setup()
require('core.pack').setup()

require('plugins.ui').setup()
require('plugins.navigation').setup()
require('plugins.git').setup()
require('plugins.lsp').setup()
require('plugins.formatting').setup()
require('plugins.completion').setup()
require('plugins.treesitter').setup()
require('plugins.debugging').setup()

-- vim: ts=2 sts=2 sw=2 et
