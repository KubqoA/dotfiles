return {
	"Bekaboo/dropbar.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("dropbar").setup({
			bar = {
				sources = function(buf, _)
					local sources = require("dropbar.sources")
					if vim.bo[buf].ft == "markdown" then
						return {
							sources.path,
							sources.markdown,
						}
					end
					if vim.bo[buf].buftype == "terminal" then
						return {
							sources.terminal,
						}
					end
					return {
						sources.path,
						sources.lsp,
					}
				end,
			},
			fzf = {},
			icons = {},
			menu = {
				preview = false,
			},
			sources = {
				lsp = {
					max_depth = 3,
				},
			},
			symbol = {},
		})

		local dropbar_api = require("dropbar.api")
		vim.keymap.set("n", "<Leader>;", dropbar_api.pick, { desc = "Pick symbols in winbar" })
		vim.keymap.set("n", "[;", dropbar_api.goto_context_start, { desc = "Go to start of current context" })
		vim.keymap.set("n", "];", dropbar_api.select_next_context, { desc = "Select next context" })
	end,
}
