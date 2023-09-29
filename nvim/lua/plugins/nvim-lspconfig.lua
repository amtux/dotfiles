return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      terraformls = {
        cmd = { "terraform-ls", "serve" },
        filetypes = { "terraform", "tf", "hcl" },
        root_dir = require("lspconfig/util").root_pattern(".terraform", ".git"),
        settings = {
          ["terraform"] = {
            ["format"] = { enable = true },
            ["diagnostics"] = { enable = true },
          },
        },
      },
      yamlls = {},
    },
  },
}
