-- Keep math fences, but do not capture Mermaid fences for image conversion.
-- An explicit query is needed because Snacks appends its diagram query.
vim.treesitter.query.set("markdown", "images", [[
(fenced_code_block
  (info_string (language) @lang)
  (#eq? @lang "math")
  (code_fence_content) @image.content
  (#set! injection.language "latex")
  (#set! image.ext "math.tex")
) @image
]])

require("snacks").setup({
  lazygit = {
    configure = false,
  },
  picker = {
    ui_select = false,
  },
  explorer = {
    hidden = true,
  },
  terminal = {},
  scroll = { enabled = true },
  -- Inline images; the explicit query above excludes diagram rendering.
  image = { enabled = true },
})

local map = vim.keymap.set

-- Lazygit
map("n", "<leader>gg", function() Snacks.lazygit() end, { desc = "Lazygit" })

-- Explorer
map("n", "<leader>e", function() Snacks.explorer() end, { desc = "Explorer (cwd)" })

-- Terminal
map({ "n", "t" }, "<C-/>", function() Snacks.terminal() end, { desc = "Toggle terminal" })

-- Picker - Files
map("n", "<leader>ff", function() Snacks.picker.files({ cwd = vim.fn.getcwd() }) end, { desc = "Files (cwd)" })
map("n", "<leader>fh", function() Snacks.picker.files({ cwd = vim.fn.getcwd(), hidden = true, ignored = true }) end, { desc = "Hidden files" })
map("n", "<leader>fb", function() Snacks.picker.buffers() end, { desc = "Buffers" })
map("n", "<leader>fr", function() Snacks.picker.recent({ filter = { cwd = true } }) end, { desc = "Recent files" })

-- Picker - Search
map("n", "<leader>sg", function() Snacks.picker.grep({ cwd = vim.fn.getcwd() }) end, { desc = "Grep (cwd)" })
map("n", "<leader>sb", function() Snacks.picker.lines() end, { desc = "Buffer lines" })
map("n", "<leader>sB", function() Snacks.picker.grep_buffers() end, { desc = "Grep open buffers" })
map("n", "<leader>sw", function() Snacks.picker.grep_word() end, { desc = "Grep word under cursor" })
map("n", "<leader>ss", function() Snacks.picker.lsp_workspace_symbols() end, { desc = "LSP workspace symbols" })
map("n", "<leader>sd", function() Snacks.picker.diagnostics() end, { desc = "Diagnostics" })
map("n", "<leader>sk", function() Snacks.picker.keymaps() end, { desc = "Keymaps" })
map("n", "<leader>su", function() Snacks.picker.undo() end, { desc = "Undo tree" })
map("n", "<leader>sR", function() Snacks.picker.resume() end, { desc = "Resume" })
map("n", "<leader>sh", function() Snacks.picker.help() end, { desc = "Help" })
map("n", "<leader>sc", function() Snacks.picker.commands() end, { desc = "Commands" })
