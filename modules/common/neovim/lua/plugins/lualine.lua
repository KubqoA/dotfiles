return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	opts = {
		options = {
			component_separators = "",
			section_separators = "",
		},
		sections = {
			lualine_b = { "branch" },
			lualine_c = {},
			lualine_x = {},
			lualine_y = {},
			lualine_z = { "location" },
		},
	},
}
