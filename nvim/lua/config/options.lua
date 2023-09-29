-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local opt = vim.opt

opt.wrap = true -- enable wrap
-- opt.completeopt = "menu,menuone,noselect,noinsert"

vim.lsp.buf.format({ timeout_ms = 5000 })
