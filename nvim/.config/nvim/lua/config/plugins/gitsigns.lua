require("gitsigns").setup({
	signs = {
		add = { text = "│" },
		change = { text = "│" },
		delete = { text = "_" },
		topdelete = { text = "‾" },
		changedelete = { text = "~" },
		untracked = { text = "┆" },
	},
	on_attach = function(buffer)
		local gs = package.loaded.gitsigns

		local function map(mode, l, r, desc)
			vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
		end

		map("n", "]h", gs.next_hunk, "Next git hunk")
		map("n", "[h", gs.prev_hunk, "Previous git hunk")
		map("n", "<leader>gs", gs.stage_hunk, "Stage hunk")
		map("n", "<leader>gr", gs.reset_hunk, "Reset hunk")
		map("v", "<leader>gs", function()
			gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, "Stage hunk")
		map("v", "<leader>gr", function()
			gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, "Reset hunk")
		map("n", "<leader>gS", gs.stage_buffer, "Stage buffer")
		map("n", "<leader>gu", gs.undo_stage_hunk, "Undo stage hunk")
		map("n", "<leader>gR", gs.reset_buffer, "Reset buffer")
		map("n", "<leader>gp", gs.preview_hunk, "Preview hunk")
		map("n", "<leader>gb", function()
			gs.blame_line({ full = true })
		end, "Blame line")
		map("n", "<leader>gd", gs.diffthis, "Diff file")
		map("n", "<leader>tb", gs.toggle_current_line_blame, "Toggle inline blame")
		map("n", "<leader>td", gs.toggle_deleted, "Toggle show deleted lines")
	end,
})
