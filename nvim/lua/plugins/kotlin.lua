return {

  -- lsp configuration
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- @type lspconfig.options
      servers = {
        kotlin_language_server = {},
      },
    },
  },

  -- cmdline tools and lsp servers
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "kotlin-language-server",
      },
    },
  },
}
