set nocompatible
filetype off

imap jj <Esc>
syntax on
colorscheme delek 

set rtp+=~/.vim/bundle/Vundle.vim
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

set number
set showcmd
set wildmenu
set lazyredraw
set showmatch

" Vundle Plugins
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'airblade/vim-gitgutter'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'preservim/nerdtree'
Plugin 'preservim/nerdcommenter'
Plugin 'tpope/vim-surround'
Plugin 'fatih/vim-go'
Plugin 'junegunn/fzf'

call vundle#end()

filetype plugin indent on

"NERD Settings
map <leader>t :NERDTreeToggle<CR>
let NERDTreeQuitOnOpen=1
let g:NERDCreateDefaultMappings=1

"fzf
set rtp+=/usr/local/opt/fzf
