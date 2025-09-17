return {
	"webhooked/kanso.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		require("kanso").setup({
			compile = true,
			background = { -- map the value of 'background' option to a theme
				dark = "zen", -- try "ink" !
				light = "pearl",
			},
		})
		vim.cmd("colorscheme kanso")
	end,
}
