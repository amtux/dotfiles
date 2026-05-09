-- Briefly highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

-- Auto-equalize split sizes when the terminal window is resized
vim.api.nvim_create_autocmd("VimResized", {
	group = vim.api.nvim_create_augroup("resize_splits", { clear = true }),
	callback = function()
		local current_tab = vim.fn.tabpagenr()
		vim.cmd("tabdo wincmd =")
		vim.cmd("tabnext " .. current_tab)
	end,
})

-- Close help, quickfix, lspinfo, checkhealth windows with q
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("close_with_q", { clear = true }),
	pattern = {
		"help",
		"qf",
		"lspinfo",
		"checkhealth",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
	end,
})

-- Detect Helm chart templates and set filetype to helm
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	group = vim.api.nvim_create_augroup("helm_filetype", { clear = true }),
	pattern = {
		"**/templates/**/*.yaml",
		"**/templates/**/*.yml",
		"**/templates/**/*.tpl",
	},
	callback = function()
		vim.bo.filetype = "helm"
	end,
})

-- Re-enter terminal mode when focusing a terminal buffer. Needed because terminals
-- like Ghostty/WezTerm send focus events that drop Neovim out of terminal mode on
-- tab-away and return, leaving tools like lazygit visible but unresponsive.
vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter", "FocusGained", "TermOpen" }, {
	group = vim.api.nvim_create_augroup("term_insert", { clear = true }),
	callback = function()
		if vim.bo.buftype == "terminal" then
			vim.cmd("startinsert")
		end
	end,
})

-- Auto-reload files changed externally (e.g. git operations in another terminal)
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
	group = vim.api.nvim_create_augroup("auto_reload", { clear = true }),
	callback = function()
		vim.cmd("checktime")
	end,
})
