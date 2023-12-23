set shell=/bin/zsh

call plug#begin(expand('~/.vim/plugged'))

Plug 'sheerun/vim-polyglot'
Plug 'tyrannicaltoucan/vim-deep-space'
Plug 'jaredgorski/spacecamp'
Plug 'kristijanhusak/vim-hybrid-material'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'inkarkat/vim-LineJuggler'
Plug 'inkarkat/vim-ingo-library'
Plug 'matze/vim-move'
Plug 'tomasr/molokai'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'rhysd/clever-f.vim'
Plug 'machakann/vim-sandwich'
Plug 'machakann/vim-highlightedundo'
Plug 'machakann/vim-highlightedyank'
Plug 'cohama/lexima.vim'
Plug 'ap/vim-buftabline'
Plug 'AndrewRadev/splitjoin.vim'

call plug#end()


imap <silent> jk <Esc>
noremap <silent> <S-J> :bp<CR>
noremap <silent> <S-K> :bn<CR>
noremap <silent> ,w :bd<CR>
let g:move_key_modifier = 'C'

vmap <S-h> <Plug>(LineJugglerDupRangeUp)
vmap <S-l> <Plug>(LineJugglerDupRangeDown)

" highlight the line in insert mode
autocmd InsertEnter * set cul
autocmd InsertLeave * set nocul

vmap <silent> J :t'><cr>
vmap <silent> K :t .-1<cr>
vnoremap p "_dP

" Move by line
nnoremap j gj
nnoremap k gk
" set t_Co=256
" set completeopt=preview
" set balloondelay=250
" filetype plugin indent on
 " Encoding
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8
set bomb
set binary

 " Fix backspace indent
set backspace=indent,eol,start
set splitbelow
set splitright

set foldmethod=marker

" Tabs. May be overriten by autocmd rules
set tabstop=4
set softtabstop=0
set shiftwidth=4
set expandtab

" Map leader to ,
 let mapleader=','

" Enable hidden buffers
set hidden

" Searching
set autoread
set hlsearch
set incsearch
set ignorecase
set smartcase

 " Directories for swp files
set nobackup
set nowritebackup
set noswapfile

set fileformats=unix,dos,mac

" syntax on
" set ruler

 " Status bar
set laststatus=2
set noshowmode

 " Use modeline overrides
set modeline
set modelines=10

set title
" set titleold="Terminal"
set titlestring=%F

set background=dark
" set termguicolors

" mouse
set mouse=a
" set number relativenumber
" set list

" Better display for messages
set cmdheight=1
" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=300
" don't give |ins-completion-menu| messages.
set shortmess+=c
" always show signcolumns
" set signcolumn=yes

" Disable visualbell
set noerrorbells visualbell t_vb=
set belloff+=ctrlg
set signcolumn=yes

" Copy/Paste/Cut
if has('unnamedplus')
    set clipboard=unnamed,unnamedplus
endif


colorscheme molokai 
" set list
let g:rehash256 = 1
nmap <silent> ,o :Files<CR>
nmap <silent> ,f :Rg<CR>
nmap <silent> ,a :Buf<CR>


noremap YY "+y<CR>
noremap <leader>p "+gP<CR>
noremap XX "+x<CR>

cnoreabbrev W! w!
cnoreabbrev Q! q!
cnoreabbrev Q1 q!
cnoreabbrev q1 q!
cnoreabbrev Qall! qall!
cnoreabbrev Wq wq
cnoreabbrev Wa wa
cnoreabbrev wQ wq
cnoreabbrev WQ wq
cnoreabbrev W w
cnoreabbrev Q q
cnoreabbrev Qall qall

inoremap <silent><expr> <C-j>
            \ pumvisible() ? "\<C-n>" : "\<CR>"
inoremap <expr><C-k> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <expr><C-l> pumvisible() ? "\<C-y>" : "\<C-]>"
command! Cnext try | cbelow | catch | cabove 9999 | catch | endtry
nnoremap <silent><leader>e :Cnext<CR>

nmap u     <Plug>(highlightedundo-undo)
nmap <C-r> <Plug>(highlightedundo-redo)
nmap U     <Plug>(highlightedundo-Undo)
nmap g-    <Plug>(highlightedundo-gminus)
nmap g+    <Plug>(highlightedundo-gplus)

" set wildmode=list:longest,list:full
set wildignore=*.o,*.obj,.git,*.rbc,*.pyc,__pycache__
set wildignore+=*.zip,*.7z,*.rar,*.gz,*.tar,*.gzip,*.bz2,*.tgz,*.xz
set wildignore+=*.png,*.jpg,*.gif,*.bmp,*.tga,*.pcx,*.ppm,*.img,*.iso
set wildignore+=*.mp4,*.avi,*.flv,*.mov,*.mkv,*.swf,*.swc
set wildignore+=*/node_modules/*,*/nginx_runtime/*,*/build/*,*/logs/*,*/dist/*,*/tmp/*

nmap <silent> ,o :Files<CR>
nmap <silent> ,f :Rg<CR>
nmap <silent> ,a :Buf<CR>

nmap <silent> ,, :noh<CR>

tnoremap jk <C-\><C-n>

" whichkey
set timeoutlen=500

" clever-f
let g:clever_f_across_no_line = 1
let g:clever_f_smart_case = 1

" buftabline
let g:buftabline_numbers = 2
let g:buftabline_show = 1
hi! BufTabLineCurrent ctermbg=233 ctermfg=242 guibg=#252525 guifg=#b877db
hi! link BufTabLineActive Normal
hi! link BufTabLineHidden Comment
hi! BufTabLineFill ctermbg=233 ctermfg=242 guibg=#151515 guifg=#b877db

" Maps Escape button in terminal window
autocmd BufEnter * if !empty(matchstr(@%, "term",0)) | tnoremap <buffer> <Esc> <C-\><C-n> | endif


let g:fzf_layout = { 'down': '35%' }
autocmd! FileType fzf
autocmd  FileType fzf set laststatus=0 noshowmode noruler
            \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
