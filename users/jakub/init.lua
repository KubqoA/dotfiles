require('impatient')

-- Variables
local colorscheme='onenord'
local background='dark'

-- Basic config
local options = {
  number = true,            -- show line numbers
  relativenumber = true,    -- show the line number relative to the line with the cursor in front of each line
  cursorline = true,        -- highlight the current line
  tabstop = 2,              -- number of spaces that a <Tab> in the file counts for
  shiftwidth = 2,           -- number of spaces to use for each step of (auto)indent
  expandtab = true,         -- use the appropriate number of spaces to insert a <Tab>
  cmdheight = 2,            -- number of screen lines to use for the command-line
  fileencoding = 'utf-8',   -- file-content encoding for the current buffer
  hlsearch = true,          -- when there is a previous search pattern, highlight all its matches
  showmatch = true,         -- when a bracket is inserted, briefly jump to the matching one
  termguicolors = true,     -- enables 24-bit RGB color
  background = background,  -- sets the backround to either 'dark' or 'light'
}

-- Set the options
for k, v in pairs(options) do
  vim.opt[k] = v
end

-- Set the colorscheme
local colorschemeOk, _ = pcall(vim.cmd, 'colorscheme ' .. colorscheme)
if not colorschemeOk then
  vim.notify('colorscheme ' .. colorscheme .. ' not found!')
  return
end

-- Treesitter
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
  },
  indent = {
    enable = true,
  },
}
