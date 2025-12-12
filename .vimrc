let mapleader=" "
let maplocalleader="\\"

set formatoptions=jcroqlnt
set number
set relativenumber
set scrolloff=4
set tabstop=4
set expandtab
set softtabstop=4
set shiftwidth=4


set shiftround
set sidescrolloff=8
set timeoutlen=10000
set notimeout
set undolevels=10000
" Disable line wrap
set nowrap

set backspace=indent,eol,start
set formatoptions=tcqj
set listchars=tab:>\ ,trail:-,nbsp:+
set shortmess=filnxtToOF


" Key maps

" https://www.lazyvim.org/configuration/keymaps

" My Keymaps
imap jk <ESC>

" General Keymaps

" Go to Left Window
nmap <C-h> <C-w>h
" Go to Lower Window
nmap <C-j> <C-w>j
" Go to Upper Window
nmap <C-k> <C-w>k
" Go to Right Window
nmap <C-l> <C-w>l
" Switch to Other Buffer
nnoremap <leader>bb <C-^>
" Switch to Other Buffer (alternative)
nnoremap <leader>` <C-^>
" Delete Buffer
" Escape and Clear hlsearch
nmap <esc> :nohlsearch<CR>
nmap <leader>ur :nohlsearch<CR>
" Keywordprg
nmap <leader>K :help<space><C-r><C-w><CR>
" Add Comment Below
nmap gco o<c-o>gcc
" Add Comment Above
nmap gcO O<c-o>gcc

