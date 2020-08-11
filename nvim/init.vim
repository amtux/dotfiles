" utf-8 encoding
set encoding=utf8

" just in case this isnt set
set nocompatible

" set <space> as leader
let mapleader=" "

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

" highlight line when in insert mode
autocmd InsertEnter,InsertLeave * set cul!

"set updatetime=300
"inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" better folding
set foldmethod=indent
set foldlevelstart=20

" don't let vim hide characters or make loud dings
set conceallevel=1
set noerrorbells

" smart line numbers
set number
set relativenumber

" left side gutter always visible
set signcolumn=yes

" uncomment the following mapping if youre using macos
" use F1 copy to global clipboard, then cmd+v to paste
" nmap <F1> :.w !pbcopy<CR><CR>
" vmap <F1> :w !pbcopy<CR><CR>

" copy paste for linux
" copy to clipboard
vnoremap  <leader>y  "+y
nnoremap  <leader>Y  "+yg_
nnoremap  <leader>y  "+y
nnoremap  <leader>yy  "+yy

" paste from clipboard
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P

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

" install theme
Plug 'joshdick/onedark.vim'

" fzf fuzzy finder plugin
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'

" lightline plugin + bufferline for it
Plug 'itchyny/lightline.vim'
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
Plug 'fatih/vim-go'

Plug 'neovim/nvim-lsp'

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

" repeat
Plug 'tpope/vim-repeat'

call plug#end()

colorscheme onedark

" to show the airline theme
set laststatus=2
" dont duplicate UPDATE/EDIT/ETC entries at the bottom
set noshowmode

" setup lightline + integrate bufferline
let g:lightline = {}
"let g:lightline.colorscheme = 'seoul256'
let g:lightline.colorscheme = 'onedark'
let g:lightline.active = {
    \   'left': [ [ 'mode', 'paste' ], [ 'gitbranch', 'readonly', 'filename', 'modified' ] ],
    \   'right': [ [ 'lineinfo' ], [ 'percent' ], [ 'fileencoding', 'filetype' ] ]
    \ }
let g:lightline.component_function = { 'gitbranch': 'fugitive#head', 'filename': 'LightlineFilename' }
let g:lightline.tabline          = {'left': [['buffers']]}
let g:lightline.component_expand = {'buffers': 'lightline#bufferline#buffers'}
let g:lightline.component_type   = {'buffers': 'tabsel'}
let g:lightline.separator = { 'left': "\ue0b0", 'right': "\ue0b2" }
let g:lightline.subseparator = { 'left': "\ue0b1", 'right': "\ue0b3" }

" show bufferline
set showtabline=2

" nerdtree settings
" Ctrl + o to toggle it anytime
"map <C-o> :NERDTreeToggle<CR>
" only open when loading a dir
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
" exit if the last buffer is nerdtree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" ctrl+p to fuzzy search files (gitignored)
nnoremap <c-p> :GFiles<cr>

" format json using python
com! FormatJSON %!python3 -m json.tool
