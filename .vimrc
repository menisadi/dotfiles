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
Plug 'machakann/vim-highlightedyank'
Plug 'wakatime/vim-wakatime'
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'menisadi/kanagawa.vim' 

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
set cursorline
set ignorecase
set smartcase
set showmode
set showmatch
" hi CursorLine cterm=None ctermbg=239 
" hi CursorColumn cterm=None ctermbg=239
" set cursorcolumn
" colorscheme wildcharm
colorscheme kanagawa
set bg=dark
hi clear SpellBad
hi SpellBad cterm=underline
"
" Enable folding
set foldmethod=indent
set foldlevel=99
set clipboard=unnamed

nnoremap ]b :bN<CR>
nnoremap [b :bp<CR>

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

"Change cursor shape properly between modes
let g:ltr_cursor_si = "\e[6 q"   " steady bar for LTR insert
let g:rtl_cursor_si = "\e[4 q"   " steady underline for RTL insert
let g:cursor_ei     = "\e[2 q"   " steady block for Normal/Elsewhere

" Default normal and insert modes
let &t_EI = g:cursor_ei
let &t_SI = g:ltr_cursor_si

function! ToggleHebrewMode() abort
  if get(b:, 'hebrew_mode_enabled', 0)
    " --- Turn Hebrew mode OFF (LTR) ---
    setlocal keymap=
    setlocal iminsert=0 imsearch=0 norightleft
    let b:hebrew_mode_enabled = 0
    let &t_SI = g:ltr_cursor_si
    echohl ModeMsg | echo 'Hebrew mode: OFF' | echohl None
  else
    " --- Turn Hebrew mode ON (RTL) ---
    setlocal keymap=hebrew
    setlocal iminsert=1 imsearch=1 rightleft
    let b:hebrew_mode_enabled = 1
    let &t_SI = g:rtl_cursor_si
    echohl ModeMsg | echo 'Hebrew mode: ON' | echohl None
  endif
endfunction

command! HebrewToggle call ToggleHebrewMode()
nnoremap <leader>h :HebrewToggle<CR>

set ttimeout
set ttimeoutlen=1
set ttyfast
