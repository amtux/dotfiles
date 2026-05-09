require("mini.pairs").setup({
	mappings = {
		-- Don't auto-pair ` when prev char is already ` (so ``` stays as 3, not 4)
		["`"] = { action = "closeopen", pair = "``", neigh_pattern = "[^\\`].", register = { cr = false } },
	},
})
