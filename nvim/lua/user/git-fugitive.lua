local M = {
  "tpope/vim-fugitive",
  event = "BufReadPre",
  dependencies = {
    {
      "tpope/vim-rhubarb",
      lazy = true,
    },
  },
}

return M
