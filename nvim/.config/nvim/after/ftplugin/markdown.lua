vim.opt_local.conceallevel = 2
vim.opt_local.concealcursor = "nc"

vim.opt_local.wrap = true
vim.opt_local.linebreak = true
vim.opt_local.breakindent = true
vim.opt_local.showbreak = "↪ "

vim.keymap.set({ "n", "v" }, "j", "gj", { buffer = true })
vim.keymap.set({ "n", "v" }, "k", "gk", { buffer = true })

vim.opt_local.spell = true
vim.opt_local.spelllang = "en_us"

vim.opt_local.formatoptions:append("ron")
vim.opt_local.comments = "b:- [ ],b:- [x],b:-,b:*,b:+,b:>"

vim.opt_local.foldmethod = "expr"
vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt_local.foldlevel = 99

vim.keymap.set("v", "<leader>mb", 'c**<C-r>"**<Esc>', { buffer = true, desc = "Bold" })
vim.keymap.set("v", "<leader>mi", 'c_<C-r>"_<Esc>', { buffer = true, desc = "Italic" })
vim.keymap.set("v", "<leader>mc", 'c`<C-r>"`<Esc>', { buffer = true, desc = "Code" })
