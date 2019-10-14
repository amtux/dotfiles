" utf-8 encoding
set encoding=utf8

" just in case this isnt set
set nocompatible

" set , as leader
let mapleader=","

" show commands being typed at the bottom
set showcmd

" disable cursor changes
set guicursor=

" indentation - overwritten by editorconfig
filetype plugin indent on
" show existing tab with 4 spaces width
set tabstop=4
" when indenting with '>', use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab

" kill lag when switching modes
set ttimeoutlen=0

" set backspace to delete
set backspace=indent,eol,start

" set some defaults for coc to work better
set updatetime=300
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)
" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

set foldmethod=indent   " sets default fold method to indent
set foldlevelstart=20

" don't let Vim hide characters or make loud dings
set conceallevel=1
set noerrorbells

" smart line numbers
set number
set relativenumber

" left side gutter always visible
set signcolumn=yes

" makes a small difference on color contrast
set termguicolors
highlight Normal ctermbg=black ctermfg=white
let g:gruvbox_contrast_dark='medium'

" use system clipboard on mac
" set clipboard=unnamed
" use F1 copy to global clipboard, then cmd+v to paste
nmap <F1> :.w !pbcopy<CR><CR>
vmap <F1> :w !pbcopy<CR><CR>

" work with buffers more easily - hidden, Tab & S-tab shortcuts
set hidden
nnoremap <Tab> :bnext<CR>
nnoremap <S-Tab> :bprevious<CR>

" working with splits better
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
set splitbelow
set splitright

" keep cursor centered (for large files)
:nnoremap j jzz
:nnoremap k kzz
:nnoremap <Down> jzz
:nnoremap <Up> kzz
:nnoremap G Gzz
:nnoremap # #zz

" update refresh time for faster git gutter updates
set updatetime=100

" use search highlighting
set hlsearch

" vim-plug plugins
call plug#begin('~/.vim/plugged')

" TMUX stuff
Plug 'christoomey/vim-tmux-navigator'
Plug 'benmills/vimux'

" install gruvbox
Plug 'morhetz/gruvbox'

" fzf fuzzy finder plugin
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'

" lightline plugin + bufferline for it
Plug 'itchyny/lightline.vim'
Plug 'shinchu/lightline-gruvbox.vim'
Plug 'mengelbrecht/lightline-bufferline'

" filesystem commands into vim plugin
Plug 'tpope/vim-eunuch'

"narrow region
Plug 'chrisbra/NrrwRgn'
" :NR - open selection in a new window
" :NW - open current visual window in a new window
" :NRP - mark a selection so you can open multiple parts of a file
" :NRM - after using NRP, run this so you can open those parts!

" add brackets around stuff plugin
Plug 'tpope/vim-surround'

" language specific
"Plug 'fatih/vim-go'
"Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'digitaltoad/vim-pug'
Plug 'posva/vim-vue'
"Plug 'kchmck/vim-coffee-script'
Plug 'neoclide/coc.nvim', {'tag': '*', 'do': './install.sh'}

" file ext specific editor config
Plug 'editorconfig/editorconfig-vim'

" nerdtree + nerdtree git plugin
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'

" git gutter plugin
Plug 'airblade/vim-gitgutter'

" git plugin
Plug 'tpope/vim-fugitive'

" commenting plugin
Plug 'scrooloose/nerdcommenter'

" dash plugin
Plug 'rizzatti/dash.vim'

" repeat
Plug 'tpope/vim-repeat'

" markdown preview
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }

call plug#end()

" use gruvbox theme
let g:gruvbox_italic=1
colorscheme gruvbox

" to show the airline theme
set laststatus=2
" dont duplicate UPDATE/EDIT/ETC entries at the bottom
set noshowmode

" setup lightline + integrate bufferline
let g:lightline = {}
"let g:lightline.colorscheme = 'seoul256'
let g:lightline.colorscheme = 'gruvbox'
let g:lightline.active = {
      \   'left': [ [ 'mode', 'paste' ], [ 'cocstatus', 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ }
let g:lightline.component_function = { 'gitbranch': 'fugitive#head', 'cocstatus': 'coc#status', 'filename': 'LightlineFilename' }
let g:lightline.tabline          = {'left': [['buffers']]}
let g:lightline.component_expand = {'buffers': 'lightline#bufferline#buffers'}
let g:lightline.component_type   = {'buffers': 'tabsel'}

" show bufferline
set showtabline=2

" nerdtree settings
" Ctrl + o to toggle it anytime
map <C-o> :NERDTreeToggle<CR>
" only open when loading a dir
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
" exit if the last buffer is nerdtree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" ctrl+p to fuzzy search files (gitignored)
nnoremap <c-p> :GFiles<cr>

" format json using python
com! FormatJSON %!python3 -m json.tool

" setup easy align
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" VIMUX
" Prompt for a command to run
map <Leader>vp :VimuxPromptCommand<CR>
" Run last command executed by VimuxRunCommand
map <Leader>vl :VimuxRunLastCommand<CR>
" Inspect runner pane
map <Leader>vi :VimuxInspectRunner<CR>
