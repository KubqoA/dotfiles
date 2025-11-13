return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		main = "nvim-treesitter.configs",
		opts = {
			auto_install = false,
			ensure_installed = {},
			highlight = { enable = true },
			indent = { enable = true },
		},
	},
	{
		"windwp/nvim-ts-autotag",
		lazy = false,
		opts = {},
	},
}
