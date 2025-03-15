return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"saghen/blink.cmp",
			{
				"folke/lazydev.nvim",
				opts = {
					library = {
						{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
					},
				},
			},
		},
		config = function()
			local lspconfig = require("lspconfig")
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			lspconfig.astro.setup({ capabilities = capabilities })
			lspconfig.harper_ls.setup({ capabilities = capabilities }) -- spell checker
			lspconfig.lua_ls.setup({ capabilities = capabilities })
			lspconfig.nixd.setup({
				cmd = { "nixd" },
				settings = {
					nixd = {
						nixpkgs = {
							expr = 'import (builtins.getFlake "/Users/jakub/.config/dotfiles").inputs.nixpkgs { }',
						},
						options = {
							nixos = {
								expr = '(builtins.getFlake "/Users/jakub/.config/dotfiles").options.nixos',
							},
							darwin = {
								expr = '(builtins.getFlake "/Users/jakub/.config/dotfiles").options.darwin',
							},
							home_manager = {
								expr = '(builtins.getFlake "/Users/jakub/.config/dotfiles").options.home-manager',
							},
						},
					},
				},
				capabilities = capabilities,
			})
			lspconfig.phpactor.setup({ capabilities = capabilities })
			lspconfig.ruby_lsp.setup({ capabilities = capabilities })
			lspconfig.ruff.setup({ capabilities = capabilities }) -- python
			lspconfig.rust_analyzer.setup({ capabilities = capabilities })
			lspconfig.stimulus_ls.setup({ capabilities = capabilities })
			lspconfig.tailwindcss.setup({ capabilities = capabilities })
			-- lspconfig.turbo_ls.setup({ capabilities = capabilities }) -- currently not in nixpkgs nvim-lspconfig
		end,
	},
}
