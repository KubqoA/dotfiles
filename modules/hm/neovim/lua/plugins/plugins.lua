return {
	{
		"tpope/vim-vinegar",
		config = function()
			vim.g.netrw_list_hide = "\\(^\\|\\s\\s\\)\\zs\\.\\S\\+,\\.DS_Store$,\\.git/$" -- hide .DS_Store, and .git directories from netrw
		end,
	},
	{ "lewis6991/gitsigns.nvim", event = { "VeryLazy" }, opts = {} },
	{ "nvim-tree/nvim-web-devicons", event = { "VeryLazy" }, opts = {} },
}
