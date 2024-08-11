vim.loader.enable()

local autocmd = vim.api.nvim_create_autocmd
local colorscheme = "rose-pine"
local background = "light"

--- Basic config
local options = {
  number = true,          -- show line numbers
  relativenumber = true,  -- show the line number relative to the line with the cursor in front of each line
  cursorline = true,      -- highlight the current line
  tabstop = 2,            -- number of spaces that a <Tab> in the file counts for
  shiftwidth = 2,         -- number of spaces to use for each step of (auto)indent
  expandtab = true,       -- use the appropriate number of spaces to insert a <Tab>
  cmdheight = 2,          -- number of screen lines to use for the command-line
  fileencoding = "utf-8", -- file-content encoding for the current buffer
  hlsearch = true,        -- when there is a previous search pattern, highlight all its matches
  showmatch = true,       -- when a bracket is inserted, briefly jump to the matching one
  termguicolors = true,   -- enables 24-bit RGB color
  background = background, -- sets the backround to either 'dark' or 'light'
}

-- Automatically set the working directory to the parent directory of opened file
autocmd("VimEnter", {
  pattern = "?*",
  callback = function()
    vim.cmd(":cd %:h")
  end,
})

--- Plugin settings
-- nvim-cmp
local cmp = require("cmp")

autocmd("InsertEnter", {
  pattern = "*",
  callback = function()
    cmp.setup({
      mapping = cmp.mapping.preset.insert({
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
      }),
      snippet = {
        expand = function(args)
          require("snippy").expand_snippet(args.body)
        end,
      },
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "snippy" },
      }),
      -- }, {
      -- 	{ name = "buffer" },
      -- }),
    })
  end,
})
autocmd("CmdlineEnter", {
  pattern = "*",
  callback = function()
    cmp.setup.cmdline({ "/", "?" }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = "buffer" },
      },
    })

    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "path" },
      }, {
        { name = "cmdline" },
      }),
      matching = { disallow_symbol_nonprefix_matching = false },
    })
  end,
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- LSP config
require("lspconfig").nixd.setup({
  cmd = { "nixd" },
  settings = {
    nixd = {
      nixpkgs = {
        expr = 'import (builtins.getFlake "/persist/dotfiles").inputs.nixpkgs { }',
      },
      options = {
        nixos = {
          expr = '(builtins.getFlake "/persist/dotfiles").nixosConfigurations.harmonium.options',
        },
        home_manager = {
          expr = '(builtins.getFlake "/persist/dotfiles").homeConfigurations.jakub.options',
        },
      },
    },
  },
  capabilities = capabilities,
})

require("lspconfig").lua_ls.setup({
  on_init = function(client)
    local path = client.workspace_folders[1].name
    if vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc") then
      return
    end

    client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
      runtime = {
        -- Tell the language server which version of Lua you're using
        -- (most likely LuaJIT in the case of Neovim)
        version = "LuaJIT",
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
        library = vim.api.nvim_get_runtime_file("", true),
      },
    })
  end,
  settings = {
    Lua = {},
  },
  capabilities = capabilities,
})

require("lspconfig").clangd.setup({})

-- Treesitter config
require("nvim-treesitter.configs").setup({
  highlight = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
  },
  indent = {
    enable = true,
  },
})

-- Conform (formatters)
require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "isort", "black" },                       -- Runs both formatters
    javascript = { { "biome", "prettierd", "prettier" } }, -- Runs first available
    nix = { "alejandra" },
  },
  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
  },
})

-- Lazy load Copilot
-- autocmd("InsertEnter", {
-- 	pattern = "*",
-- 	callback = function()
-- 		require("copilot").setup({})
-- 		vim.cmd("Copilot")
-- 	end,
-- })

require("gitsigns").setup()

--- Misc

-- Highlight cursor line briefly when neovim regains focus.  This helps to
-- reorient the user and tell them where they are in the buffer.
-- Stolen from https://developer.ibm.com/tutorials/l-vim-script-5.
autocmd("FocusGained", {
  pattern = "*",
  callback = function()
    vim.opt.cursorline = true
    vim.cmd("redraw")
    vim.cmd("sleep 1000m")
    vim.opt.cursorline = false
  end,
})

--- Bolierplate
-- Set the options
for k, v in pairs(options) do
  vim.opt[k] = v
end

-- Set the colorscheme
if colorscheme == "rose-pine" then
  require("rose-pine").setup({
    dim_inactive_windows = false,
    extend_background_behind_borders = true,

    enable = {
      terminal = true,
    },
  })
end

local colorschemeOk, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not colorschemeOk then
  vim.notify("colorscheme " .. colorscheme .. " not found!")
  return
end
