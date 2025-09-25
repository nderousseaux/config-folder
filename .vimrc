syntax on
set mouse=a    " Enable mouse support in all modes


""""""""""""" Indentation """""""""""""
set tabstop=4 " Number of spaces that a <Tab> counts for
set shiftwidth=4 " Number of spaces to use for each step of (auto)indent
set expandtab   " Use spaces instead of tabs

"""""""""""""" Copying """""""""""""
" Enable system clipboard integration
set clipboard=unnamed,unnamedplus
vnoremap <C-c> "+y
" Ensure Mac system clipboard works
if has('macunix')
    set clipboard=unnamed
endif