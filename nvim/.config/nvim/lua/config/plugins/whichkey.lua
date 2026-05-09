require("which-key").setup({
	preset = "helix",
	icons = {
		mappings = true,
	},
	spec = {
		{ "<leader>c", group = "code" },
		{ "<leader>f", group = "find" },
		{ "<leader>g", group = "git" },
		{ "<leader>s", group = "search" },
		{ "<leader>t", group = "toggle" },
	},
})
