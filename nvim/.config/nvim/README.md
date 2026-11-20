# Neovim Config

Minimal config for Neovim 0.12+ using native `pack/` for plugin management.

## Plugin Management

- Plugins are git-cloned into `~/.local/share/nvim/site/pack/plugins/start/`
- `:PackUpdate` — pull latest for all unpinned plugins
- `:PackClean` — remove plugins not in the list
- Pin a plugin to a tag/commit by adding `pin = "v1.0.0"` in `init.lua`

## Completion

Uses Neovim's native LSP completion (no plugin).

- Auto-triggers on `.` (and other LSP trigger characters)
- `<C-n>` — open completion / next item
- `<C-p>` — previous item
- `<C-y>` — accept selection
- `<C-e>` — dismiss popup
- `<C-f>` — filename completion (shorthand for `<C-x><C-f>`; chain for nested paths)

Unlike blink.cmp or nvim-cmp, native completion does **not** trigger on every keystroke. Press `<C-n>` to trigger manually when typing a symbol name.

## Keymaps

Leader key: `<Space>`

### General
| Key | Action |
|---|---|
| `<C-s>` | Save file |
| `<Esc>` | Clear search highlights |

### Windows
| Key | Action |
|---|---|
| `<C-h/j/k/l>` | Move between windows |
| `<C-Up/Down/Left/Right>` | Resize windows |

### Buffers
| Key | Action |
|---|---|
| `<S-h>` / `<S-l>` | Previous / next buffer |
| `<leader>x` | Delete buffer |

### Lines
| Key | Action |
|---|---|
| `<A-j>` / `<A-k>` | Move line(s) up/down |
| `<` / `>` (visual) | Indent and reselect |

### LSP
| Key | Action |
|---|---|
| `gd` | Go to definition (snacks picker with preview) |
| `gr` | Go to references (snacks picker with preview) |
| `gI` | Go to implementation (snacks picker with preview) |

| `K` | Hover documentation |
| `<leader>cr` | Rename |
| `<leader>ca` | Code action |
| `<leader>cy` | Yank diagnostic message |

### Diagnostics
| Key | Action |
|---|---|
| `[d` / `]d` | Previous / next diagnostic |

### Git
| Key | Action |
|---|---|
| `<leader>gg` | Lazygit |
| `]h` / `[h` | Next / previous hunk |
| `<leader>gs` | Stage hunk |
| `<leader>gr` | Reset hunk |
| `<leader>gS` | Stage buffer |
| `<leader>gR` | Reset buffer |
| `<leader>gu` | Undo stage hunk |
| `<leader>gp` | Preview hunk |
| `<leader>gb` | Blame line |
| `<leader>gd` | Diff file |
| `<leader>gy` | Yank git link |
| `<leader>gY` | Open git link in browser |
| `<leader>tb` | Toggle inline blame |
| `<leader>td` | Toggle show deleted lines |
| `<leader>tw` | Toggle word wrap |

### Files / Search (snacks picker)
| Key | Action |
|---|---|
| `<leader>ff` | Files (cwd) |
| `<leader>fh` | Hidden files |
| `<leader>fb` | Buffers |
| `<leader>fr` | Recent files |
| `<leader>sg` | Grep (cwd) |
| `<leader>sb` | Buffer lines |
| `<leader>sB` | Grep open buffers |
| `<leader>sw` | Grep word under cursor |
| `<leader>ss` | LSP workspace symbols |
| `<leader>sd` | Diagnostics |
| `<leader>sk` | Keymaps |
| `<leader>su` | Undo tree |
| `<leader>sR` | Resume last picker |
| `<leader>sh` | Help |
| `<leader>sc` | Commands |

### Explorer / Terminal
| Key | Action |
|---|---|
| `<leader>e` | File explorer (cwd) |
| `<C-/>` | Toggle terminal |

### Formatting
| Key | Action |
|---|---|
| `<leader>cf` | Format buffer |
| (auto) | Format on save |

### Folding
| Key | Action |
|---|---|
| `za` | Toggle fold under cursor |
| `zM` | Close all folds |
| `zR` | Open all folds |

### Jump (flash.nvim)
| Key | Mode | Action |
|---|---|---|
| `s{chars}` | normal / visual / op-pending | Flash jump — type 1–2 chars, then a label letter to jump |
| `S` | normal / visual / op-pending | Flash treesitter — jump to a syntax node |
| `r` | op-pending | Remote flash — operate on a target without moving cursor (e.g. `yr` yanks remotely) |
| `R` | op-pending / visual | Treesitter search |
| `<C-s>` | command | Toggle flash inside `/` search |

### Surround (mini.surround)
Prefix is `gs` (so `s` is free for flash).

| Key | Action |
|---|---|
| `gsa{motion}{char}` | Add surrounding (e.g. `gsaiw"` wraps inner word in `"`) |
| `gsa{char}` (visual) | Add surrounding to selection |
| `gsd{char}` | Delete surrounding |
| `gsr{old}{new}` | Replace surrounding |
| `gsf` / `gsF` | Find next / previous surrounding |
| `gsh` | Highlight surrounding |

### Markdown (in markdown buffers)
| Key | Action |
|---|---|
| `<leader>mb` (visual) | Wrap selection in `**bold**` |
| `<leader>mi` (visual) | Wrap selection in `_italic_` |
| `<leader>mc` (visual) | Wrap selection in `` `code` `` |
| `j` / `k` | Move by visible (wrapped) line |

Markdown buffers also enable: conceal (hide `**`/`_`/`` ` `` markers, reveal on cursor line), word-wrap with break-indent, spellcheck, list-marker continuation on Enter / `o`, and treesitter folding by heading. Images render inline via snacks.image. Mermaid code fences remain plain code; an explicit Markdown image query in the Snacks config disables diagram rendering.

## Plugins

1. tokyonight.nvim — theme (night, transparent)
2. nvim-treesitter — syntax highlighting, indentation, folding
3. nvim-lspconfig — LSP server configurations
4. conform.nvim — format on save
5. gitsigns.nvim — git gutter + hunk operations
6. snacks.nvim — picker, explorer, lazygit, terminal, inline images
7. lualine.nvim — statusline
8. bufferline.nvim — buffer tabs
9. which-key.nvim — keybinding help popup
10. gitlinker.nvim — GitHub file links
11. nvim-web-devicons — file icons
12. mini.pairs — auto-close brackets, quotes, and indent between pairs on enter
13. mini.surround — add/change/delete surrounding pairs (quotes, brackets, etc.)
14. flash.nvim — fast cursor jumping with labeled targets

## External Dependencies

Run `install-deps.sh` to install all dependencies, or install manually:

**Treesitter**: `tree-sitter-cli`
**LSP servers**: `lua-language-server`, `gopls`, `rust-analyzer`, `cue`, `bash-language-server`, `vscode-langservers-extracted` (json), `yaml-language-server`, `helm-ls`
**Formatters**: `prettier`, `stylua`, `shfmt`, `gofumpt`, `rustfmt`
**Image rendering**: `imagemagick` — used by snacks.image for inline images in markdown (requires a kitty-graphics terminal, e.g. Ghostty). No browser or diagram-rendering CLI is required.
**Other**: `jq` (powers the `:Jq` / `:JqPeek` user commands)
