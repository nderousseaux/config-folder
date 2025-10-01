syntax on
set mouse=a    " Enable mouse support in all modes


"""""""""""""""" Shortuts """""""""""""
nnoremap <C-s> :w<CR> " Save file with Ctrl + s
nnoremap <C-q> :q<CR> " Quit with Ctrl + q
nnoremap <C-a> ggVG " Select all with Ctrl + a
nnoremap <C-z> u " Undo with Ctrl + z
nnoremap <C-y> <C-r> " Redo with Ctrl + y
nnoremap <Tab> >> " Indent with Tab
nnoremap <S-Tab> <<
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv

"""""""""""""""" Theme """"""""""""""""
set colorcolumn=80
highlight ColorColumn ctermbg=black guibg=#222222
set textwidth=80

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

"""""""""""""" Code """""""""""""""""
" Auto-pairs plugin
call plug#begin('~/.vim/plugged')
Plug 'jiangmiao/auto-pairs'
call plug#end()