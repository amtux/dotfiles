local M = {
  "alexghergh/nvim-tmux-navigation",
  lazy = false,
  priority = 2000, -- make sure to load this before all the other start plugins
}

function M.config()
  require("nvim-tmux-navigation").setup {
    disable_when_zoomed = true
  }
end

return M
