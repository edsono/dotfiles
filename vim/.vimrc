if &compatible
  set nocompatible
endif

scriptencoding utf-8

"-------------
" Core behavior
"-------------
filetype plugin indent on
syntax enable

set encoding=utf-8
set hidden
set history=1000
set ruler
set showcmd
set wildmenu
set wildmode=longest:full,full
set backspace=indent,eol,start

"-------------
" UI / navigation
"-------------
set number
set scrolloff=4
set sidescrolloff=8
set splitbelow
set splitright
set mouse=a
set updatetime=250
set signcolumn=yes

if exists('+termguicolors')
  set termguicolors
endif

if exists('+completeopt')
  set completeopt=menuone,noselect
endif

"-------------
" Search
"-------------
set hlsearch
set incsearch
set ignorecase
set smartcase

"-------------
" Persistence
"-------------
if has('persistent_undo')
  set undofile
endif

if has('unnamedplus')
  set clipboard+=unnamedplus
endif

"-------------
" Extracted from nvim config
"-------------
let mapleader = "\\"
let maplocalleader = " "
set spelllang=pt_br,pt,en_us,en
nnoremap <silent> <space><CR> :nohlsearch<CR>

"-------------
" Local overrides (not managed by stow)
"-------------
if filereadable(expand('~/.vimrc-local'))
  execute 'source' fnameescape(expand('~/.vimrc-local'))
endif
