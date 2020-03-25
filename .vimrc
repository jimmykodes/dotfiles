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

call vundle#end()
filetype plugin indent on

