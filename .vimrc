set nocompatible
filetype off

call plug#begin()

Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'dense-analysis/ale'
Plug 'sheerun/vim-polyglot'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'preservim/nerdcommenter'
Plug 'kien/rainbow_parentheses.vim'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'jpalardy/vim-slime'
Plug 'dstein64/vim-startuptime'
Plug 'machakann/vim-highlightedyank'
Plug 'wakatime/vim-wakatime'
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'joshdick/onedark.vim'
Plug 'menisadi/kanagawa.vim'
Plug 'joshdick/onedark.vim'

call plug#end()
filetype plugin indent on

let mapleader = " "
set number
set hidden
autocmd BufNewFile,BufRead *.sql set filetype=sql
syntax on
let python_highlight_all=1
set incsearch
set hlsearch
set encoding=utf-8
set spell spelllang=en_us
hi CursorLine cterm=None ctermbg=239 
hi CursorColumn cterm=None ctermbg=239
set cursorline
set cursorcolumn
set ignorecase
set smartcase
set showmode
set showmatch
" colorscheme wildcharm
colorscheme kanagawa
set bg=dark
hi clear SpellBad
hi SpellBad cterm=underline
" Enable folding
set foldmethod=indent
set foldlevel=99
set clipboard=unnamed

nnoremap ]b :bN<CR>
nnoremap [b :bp<CR>

"Change cursor shape properly between modes
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"
set ttimeout
set ttimeoutlen=1
set ttyfast

au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

"This unsets the 'last search pattern' register by hitting return
nnoremap <CR> :noh<CR><CR>

let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors = 0
highlight IndentGuidesEven ctermbg=236
highlight IndentGuidesOdd ctermbg=235


let g:highlightedyank_highlight_duration = 100
highlight HighlightedyankRegion cterm=reverse gui=reverse

let g:slime_target = "kitty"
let g:slime_cell_delimiter = "# %%"
nmap <leader>s <Plug>SlimeSendCell
