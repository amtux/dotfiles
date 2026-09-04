require("lualine").setup({
	options = {
		theme = "auto", -- picks up the active colorscheme (tokyonight)
		component_separators = "|",
		section_separators = "",
	},
	sections = {
		lualine_c = {
			{
				"filename",
				path = 1, -- relative path
			},
		},
	},
})
