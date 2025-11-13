return {
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},

	{
		"saghen/blink.cmp",
		-- optional: provides snippets for the snippet source
		dependencies = { "rafamadriz/friendly-snippets" },
		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			sources = {
				-- add lazydev to your completion providers
				default = { "lazydev", "lsp", "path", "snippets", "buffer" },
				providers = {
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						-- make lazydev completions top priority (see `:h blink.cmp`)
						score_offset = 100,
					},
				},
			},

			keymap = { preset = "super-tab" },

			appearance = {
				nerd_font_variant = "mono",
			},
		},
	},

	{
		"neovim/nvim-lspconfig",
		config = function()
			-- spellcheck
			vim.lsp.config("harper_ls", {
				settings = {
					["harper-ls"] = {
						linters = {
							SentenceCapitalization = false,
							SpellCheck = false,
							ToDoHyphen = false,
						},
					},
				},
			})

			-- nextls doesn't have a default `cmd`
			vim.lsp.config("nextls", {
				cmd = { "nextls", "--stdio" },
			})

			vim.lsp.config("yamlls", {
				settings = {
					yaml = {
						schemas = {
							["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
						},
					},
				},
			})

			vim.lsp.enable({
				"astro",
				"harper_ls",
				"jsonls",
				"lua_ls",
				"marksman",
				"nextls",
				"nil_ls",
				"phpactor",
				"ruby_lsp",
				"ruff",
				"rust_analyzer",
				"tailwindcss",
				"tsgo",
				"yamlls",
			})
		end,
	},
}
