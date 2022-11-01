local tmux = require('nvim-tmux-navigation')
local keymap = vim.keymap.set

tmux.setup {
    disable_when_zoomed = true
}

keymap('n', "<C-h>", tmux.NvimTmuxNavigateLeft)
keymap('n', "<C-j>", tmux.NvimTmuxNavigateDown)
keymap('n', "<C-k>", tmux.NvimTmuxNavigateUp)
keymap('n', "<C-l>", tmux.NvimTmuxNavigateRight)
keymap('n', "<C-Space>", tmux.NvimTmuxNavigateLastActive)
