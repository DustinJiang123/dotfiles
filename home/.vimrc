" ============================================================================
" Dustin's Vim Configuration
" Cross-platform: macOS + Linux + WSL
" Plugins managed by vim-plug (auto-installed by install.sh / extra-install.sh)
" ============================================================================

set nocompatible
filetype off

" ---- Plugin Manager ---------------------------------------------------
if filereadable(expand('~/.vim/autoload/plug.vim'))
  call plug#begin('~/.vim/plugged')

  " --- Themes (multiple to choose from) ---
  Plug 'morhetz/gruvbox'
  Plug 'dracula/vim', { 'as': 'dracula' }
  Plug 'joshdick/onedark.vim'

  " --- Status line ---
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'

  " --- File explorer & navigation ---
  Plug 'preservim/nerdtree'
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'

  " --- Git integration ---
  Plug 'tpope/vim-fugitive'
  Plug 'airblade/vim-gitgutter'

  " --- Editing power-ups ---
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-commentary'

  " --- Indent guides ---
  Plug 'Yggdroot/indentLine'

  " --- Language support ---
  Plug 'pearofducks/ansible-vim'
  Plug 'rstacruz/sparkup', {'rtp': 'vim/'}

  " --- Code completion (requires Node.js) ---
  if executable('node')
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
  endif

  call plug#end()
endif

filetype plugin indent on
syntax enable

" ---- General Settings -------------------------------------------------
set encoding=utf-8
set fileformats=unix,dos,mac

" ---- Display & UI ------------------------------------------------------
set number
set relativenumber
set cursorline
set showcmd
set showmode
set laststatus=2
set noruler                      " ruler handled by airline/lightline
set wildmenu
set wildmode=longest:full,full
set shortmess+=c
set scrolloff=8
set sidescrolloff=8
set visualbell
set t_vb=
set conceallevel=2

" ---- Colors & Theme ---------------------------------------------------
set termguicolors
set t_Co=256
set background=dark

" Default: onedark (with graceful fallback if plugin not yet installed)
try
  colorscheme onedark
catch
  try
    colorscheme gruvbox
  catch
    colorscheme desert
  endtry
endtry

" airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_theme = 'onedark'

" ---- Editor Behavior --------------------------------------------------
set autoindent
set smartindent
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set shiftround
set backspace=indent,eol,start

" Line wrapping
set wrap
set linebreak
set breakindent
set showbreak=↪

" Search
set hlsearch
set incsearch
set ignorecase
set smartcase

" Folding
set nofoldenable                 " don't fold by default
set foldmethod=indent
set foldlevelstart=99

" History & undo
set history=1000
set undofile
set undodir=~/.vim/undo//
set undolevels=1000

" Backup & swap
set backup
set backupdir=~/.vim/backup//
set directory=~/.vim/swap//
set noswapfile

" Completion popup
set completeopt=menuone,noinsert,noselect
set pumheight=10

" ---- Mouse & Clipboard ------------------------------------------------
set mouse=a
" macOS uses 'unnamed' for the system clipboard;
" Linux/WSL want 'unnamedplus' (and need vim built with +clipboard).
if has('mac') || has('macunix')
  set clipboard=unnamed
elseif has('unix')
  set clipboard=unnamedplus
endif

" ---- Key Mappings -----------------------------------------------------
let mapleader = ' '

" Easier escape
inoremap jj <Esc>
inoremap jk <Esc>

" Clear search highlight
nnoremap <leader><space> :nohlsearch<CR>

" Save & quit
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>Q :q!<CR>
nnoremap <leader>x :x<CR>

" Window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Buffer navigation
nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprevious<CR>
nnoremap <leader>bd :bdelete<CR>

" NERDTree
nnoremap <leader>e :NERDTreeToggle<CR>

" FZF
nnoremap <C-p> :Files<CR>
nnoremap <leader>h :History:<CR>
nnoremap <leader>ag :Ag<Space>

" Keep selection after indent
vnoremap < <gv
vnoremap > >gv

" Better paste (don't overwrite register)
xnoremap p pgvy

" Y yank to end of line (consistent with C, D)
nnoremap Y y$

" Quick edit/source vimrc
nnoremap <leader>ev :e $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

" ---- Filetype Settings ------------------------------------------------
autocmd FileType make setlocal noexpandtab
autocmd FileType html,css,javascript,json,yaml setlocal tabstop=2 shiftwidth=2 softtabstop=2
autocmd FileType markdown setlocal wrap linebreak
autocmd BufNewFile,BufRead *.yml,*.yaml set filetype=yaml.ansible

" ---- Auto-Commands ----------------------------------------------------
augroup vimrc
  autocmd!

  " Return to last edit position when reopening a file
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  " Trim trailing whitespace on save
  autocmd BufWritePre * :%s/\s\+$//e

  " Auto-create parent directories on save
  autocmd BufWritePre * call s:mkdir_p(expand('<afile>:p:h'))
augroup END

function! s:mkdir_p(dir)
  if !isdirectory(a:dir)
    call mkdir(a:dir, 'p')
  endif
endfunction

" ---- Plugin-Specific Settings -----------------------------------------
" NERDTree
let NERDTreeShowHidden = 1
let NERDTreeMinimalUI = 1
let NERDTreeDirArrowExpandable = '▸'
let NERDTreeDirArrowCollapsible = '▾'

" GitGutter
let g:gitgutter_sign_added = '▎'
let g:gitgutter_sign_modified = '▎'
let g:gitgutter_sign_removed = '▎'
let g:gitgutter_map_keys = 0

" indentLine
let g:indentLine_char = '│'
let g:indentLine_fileTypeExclude = ['help', 'terminal']
let g:indentLine_bufNameExclude = ['_.*']

" FZF
let g:fzf_layout = { 'down': '40%' }
let g:fzf_preview_window = ['right:50%', 'ctrl-/']
let g:fzf_commits_log_options = '--graph --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

" ---- coc.nvim (only when plugin is loaded) ----------------------------
if exists('g:loaded_coc')
  " Use Tab to trigger completion
  inoremap <silent><expr> <TAB>
        \ coc#pum#visible() ? coc#pum#next(1) :
        \ <SID>check_back_space() ? "\<TAB>" :
        \ coc#refresh()
  inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

  function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1] =~# '\s'
  endfunction

  " Use Enter to confirm completion
  inoremap <expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"

  " Jump to definition
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gr <Plug>(coc-references)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)

  " Highlight tweaks
  hi! link CocMenuSel PmenuSel
  hi! link CocSearch Identifier
endif

" ---- Terminal Compatibility ------------------------------------------
" 24-bit color over screen/tmux
if $TERM =~# '^screen'
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

" vim: set foldmethod=marker:
