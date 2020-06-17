set nocompatible
filetype off

imap jj <Esc>
nnoremap B ^
nnoremap E $

syntax on
nnoremap j gj
nnoremap k gk
colorscheme delek 

set rtp+=~/.vim/bundle/Vundle.vim
set tabstop=4
set softtabstop=4
set expandtab

set number
set showcmd
set wildmenu
set lazyredraw
set showmatch


call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'airblade/vim-gitgutter'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'preservim/nerdtree'
Plugin 'tpope/vim-surround'
Plugin 'terryma/vim-multiple-cursors'

call vundle#end()
filetype plugin indent on

com! FormatJSON %!python -m json.tool
map <C-t> :NERDTreeToggle<CR>
