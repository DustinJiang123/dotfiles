" ============================================================================
"  Dustin's Vim Configuration
"  Inspired by modern best practices for terminal Vim
" ============================================================================

if filereadable(expand('~/.vim/autoload/plug.vim'))
  call plug#begin('~/.vim/plugged')

  " Colorscheme
  Plug 'morhetz/gruvbox'

  " Status line
  Plug 'itchyny/lightline.vim'

  " File explorer
  Plug 'preservim/nerdtree'

  " Git integration
  Plug 'tpope/vim-fugitive'
  Plug 'airblade/vim-gitgutter'

  " Text objects & editing
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-commentary'

  " Navigation
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'

  " Language / syntax (Vim 9 built-in syntax is excellent, no extra needed)

  " Indent guides
  Plug 'Yggdroot/indentLine'

  call plug#end()
endif


" ---- General Settings --------------------------------------------------
set nocompatible                " Vim defaults, not vi
filetype plugin indent on
syntax enable

set encoding=utf-8
set fileformats=unix,dos,mac

" ---- Display & UI ------------------------------------------------------
set number                      " Line numbers
set relativenumber              " Relative line numbers (hybrid mode)
set cursorline                  " Highlight current line
set showcmd                     " Show command in last line
set showmode                    " Show current mode
set laststatus=2                " Always show status line
set noruler                     " Ruler handled by lightline
set conceallevel=2               " Needed for indentLine to show
set wildmenu                    " Command-line completion
set wildmode=longest:full,full
set shortmess+=c                " Don't pass messages to ins-completion-menu
set scrolloff=8                 " Keep 8 lines context when scrolling
set sidescrolloff=8
set visualbell                  " Flash instead of beep
set t_vb=                       " Disable visual bell flash

" ---- Colors & Theme ----------------------------------------------------
set termguicolors               " True color support (WSL2 + modern terminals)
set background=dark
try
  let g:gruvbox_contrast_dark = 'medium'
  let g:gruvbox_sign_column = 'bg0'
  colorscheme gruvbox
catch
  " Fallback: use default colors if gruvbox not installed yet
  colorscheme desert
endtry

" Lightline config
if exists('g:loaded_lightline')
  let g:lightline = {
        \ 'colorscheme': 'gruvbox',
        \ 'active': {
        \   'left': [ [ 'mode', 'paste' ],
        \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ],
        \   'right': [ [ 'lineinfo' ],
        \              [ 'percent' ],
        \              [ 'filetype', 'fileencoding', 'fileformat' ] ]
        \ },
        \ 'component_function': {
        \   'gitbranch': 'LightlineFugitiveHead',
        \   'filetype': 'LightlineFiletype',
        \   'fileformat': 'LightlineFileformat',
        \ }
        \ }
endif

function! LightlineFugitiveHead()
  if exists('*FugitiveHead')
    return FugitiveHead()
  endif
  return ''
endfunction

function! LightlineFiletype()
  return winwidth(0) > 70 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
endfunction

function! LightlineFileformat()
  return winwidth(0) > 70 ? (&fileformat !=# '' ? &fileformat : '') : ''
endfunction

" ---- Editor Behavior ---------------------------------------------------
set autoindent                  " Copy indent from current line
set smartindent                 " Smart autoindenting
set tabstop=4                   " Tab width
set shiftwidth=4                " Indent width
set softtabstop=4               " Backspace behavior
set expandtab                   " Spaces over tabs
set shiftround                  " Round indent to shiftwidth

" Backspace
set backspace=indent,eol,start

" Line wrapping
set wrap                        " Visual wrap
set linebreak                   " Break at word boundary
set breakindent                 " Indent wrapped lines
set showbreak=↪

" Search
set hlsearch                    " Highlight search results
set incsearch                   " Search while typing
set ignorecase                  " Case-insensitive search
set smartcase                   " Case-sensitive if uppercase used

" Folding
set foldmethod=indent
set foldlevelstart=99           " Start with folds open

" History & undo
set history=1000
set undofile                    " Persistent undo
set undodir=~/.vim/undo//
set undolevels=1000

" Backup & swap (put in one dir, keep less clutter)
set backup
set backupdir=~/.vim/backup//
set directory=~/.vim/swap//
set noswapfile                  " Use persistent undo instead

" Completion
set completeopt=menuone,noinsert,noselect
set pumheight=10                " Limit popup menu height

" ---- Key Mappings ------------------------------------------------------
" Use space as leader key
let mapleader = ' '

" Easier escape
inoremap jj <Esc>
inoremap jk <Esc>

" Clear search highlight
nnoremap <Leader><Space> :nohlsearch<CR>

" Save & quit
nnoremap <Leader>w :w<CR>
nnoremap <Leader>q :q<CR>
nnoremap <Leader>Q :q!<CR>
nnoremap <Leader>x :x<CR>

" Window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Buffer navigation
nnoremap <Leader>bn :bnext<CR>
nnoremap <Leader>bp :bprevious<CR>
nnoremap <Leader>bd :bdelete<CR>

" NERDTree
nnoremap <Leader>e :NERDTreeToggle<CR>

" FZF
nnoremap <C-p> :Files<CR>
nnoremap <Leader>h :History:<CR>
nnoremap <Leader>ag :Ag<CR>

" Keep selection after indent
vnoremap < <gv
vnoremap > >gv

" Move lines with Alt-j/k
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" Better paste (don't overwrite register)
xnoremap p pgvy

" Y yank to end of line (consistent with C, D)
nnoremap Y y$

" ---- Filetype Settings ------------------------------------------------
" Use actual tabs for Makefiles
autocmd FileType make setlocal noexpandtab

" 2-space indent for web dev
autocmd FileType html,css,javascript,json,yaml setlocal tabstop=2 shiftwidth=2 softtabstop=2

" Markdown
autocmd FileType markdown setlocal wrap linebreak

" ---- Auto-Commands ----------------------------------------------------
augroup vimrc
  autocmd!

  " Return to last edit position
  autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif

  " Trim trailing whitespace on save
  autocmd BufWritePre * :%s/\s\+$//e

  " Create directories on save if needed
  autocmd BufWritePre * call s:mkdir_p(expand('<afile>:p:h'))
augroup END

function! s:mkdir_p(dir)
  if !isdirectory(a:dir)
    call mkdir(a:dir, 'p')
  endif
endfunction

" ---- Plugin-Specific Settings -----------------------------------------
" NERDTree
if exists('g:loaded_nerdtree')
  let NERDTreeShowHidden = 1
  let NERDTreeMinimalUI = 1
  let NERDTreeDirArrowExpandable = '▸'
  let NERDTreeDirArrowCollapsible = '▾'
endif

" GitGutter
if exists('g:gitgutter_sign_added')
  let g:gitgutter_sign_added = '▎'
  let g:gitgutter_sign_modified = '▎'
  let g:gitgutter_sign_removed = '▎'
  let g:gitgutter_map_keys = 0
endif

" indentLine
if exists('g:indentLine_char')
  let g:indentLine_char = '│'
  let g:indentLine_fileTypeExclude = ['help', 'terminal']
  let g:indentLine_bufNameExclude = ['_.*']
endif

" FZF
let g:fzf_preview_window = ['right:40%', 'ctrl-/']
let g:fzf_commits_log_options = '--graph --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

" ---- Custom Commands / Functions --------------------------------------
" Quick edit vimrc
nnoremap <Leader>ev :e $MYVIMRC<CR>
nnoremap <Leader>sv :source $MYVIMRC<CR>

" ---- Abbreviations ----------------------------------------------------
iabbrev @@ dustin@

" ---- Terminal Check ---------------------------------------------------
" If running in a ssh session or tmux, adjust
if $TERM =~# '^screen'
  set t_8f=\[38;2;%lu;%lu;%lum
  set t_8b=\[48;2;%lu;%lu;%lum
endif

" vim: set foldmethod=marker foldmarker={{{,}}}:
