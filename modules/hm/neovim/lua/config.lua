vim.g.mapleader = " " -- space leader key
vim.o.termguicolors = true -- enable 24-bit colors
vim.o.tabstop = 2 -- tab = 2 spaces
vim.o.softtabstop = 2
vim.o.shiftwidth = 2 -- number of spaces when using >> or <<
vim.o.expandtab = true -- use appropriate number of spaces with tab
vim.o.smartindent = true -- correct indenting after {
vim.o.autoindent = true -- copy indent of current line
vim.o.scrolloff = 8 -- keep 8 lines above/below cursor
vim.o.wrap = false
vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true -- enable cursor line
vim.o.signcolumn = "yes" -- always show sign column
vim.o.clipboard = "unnamedplus" -- use system clipboard
vim.o.laststatus = 0
vim.o.incsearch = true

vim.diagnostic.config({ virtual_text = true }) -- inline diagnostics
