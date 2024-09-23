set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-surround'
Plugin 'vim-airline/vim-airline'
Plugin 'dense-analysis/ale'
Plugin 'sheerun/vim-polyglot'
Plugin 'junegunn/fzf.vim'
Plugin 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plugin 'preservim/nerdcommenter'
Plugin 'kien/rainbow_parentheses.vim'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'jpalardy/vim-slime'
Plugin 'dstein64/vim-startuptime'
Plugin 'machakann/vim-highlightedyank'
Plugin 'wakatime/vim-wakatime'
Plugin 'Vimjas/vim-python-pep8-indent'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

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
colorscheme retrobox
set bg=dark
hi clear SpellBad
hi SpellBad cterm=underline
" Enable folding
set foldmethod=indent
set foldlevel=99
set clipboard=unnamed

let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"
set ttimeout
set ttimeoutlen=1
set ttyfast

au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

"This unsets the "last search pattern" register by hitting return
nnoremap <CR> :noh<CR><CR>

" let g:ycm_always_populate_location_list = 1
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_guide_size = 1
let g:highlightedyank_highlight_duration = 100
highlight HighlightedyankRegion cterm=reverse gui=reverse
let g:slime_target = "kitty"
let g:slime_cell_delimiter = "# %%"
nmap <leader>z :echo "yay"<CR>
nmap <leader>s <Plug>SlimeSendCell
command -nargs=0 Today :r !date "+\%F"
command -nargs=0 Todayheader :execute "normal i## " . strftime("%Y-%m-%d") . "\r"
ab :sadface: 😔 
ab :happyface: 😊
ab :thinkface: 🤔
