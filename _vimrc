" ------------------------------------------------------------------------------
" Copyright 2022 Ryan 'Majoolwip' Moore
"
" Permission is hereby granted, free of charge, to any person obtaining a copy
" of this software and associated documentation files (the "Software"), to deal
" in the Software without restriction, including without limitation the rights
" to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
" copies of the Software, and to permit persons to whom the Software is
" furnished to do so, subject to the following conditions:
"
" The above copyright notice and this permission notice shall be included in all
" copies or substantial portions of the Software.
"
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
" IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
" FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
" AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
" LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
" OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
" SOFTWARE.
" ------------------------------------------------------------------------------

" ------------------------------------------------------------------------------
" File: vimrc
" Description: This is my personal vimrc script that I use while editing source
" code. Feel free to use it yourself or as inspiration for your own.
" ------------------------------------------------------------------------------

" Don't try and be compatible with old vi
set nocompatible

" Turn on file type detection.
filetype on

" Turn on file type plugins like softtabstop for c files.
filetype plugin on

" Plugin management. See https://github.com/junegunn/vim-plug
call plug#begin('~/vimfiles/plugged')
  " Nordic Ice Theme
  Plug 'arcticicestudio/nord-vim'

  " NerdTree file explorer
  Plug 'preservim/nerdtree'

  " Better status line
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'

  " Auto set working directory to project root
  Plug 'airblade/vim-rooter'

  " A very small script to make the auto syntax completion popup menu popup
  " automatically.
  Plug 'skywind3000/vim-auto-popmenu'
call plug#end()

" General {{{ -------------------------------------------------------------------
" Fix backspace to work as intended if broken.
set backspace=indent,eol,start

" Don't generate backup files.
set nobackup

" Don't let me scroll off of the file by more than 10 lines.
set scrolloff=10

" Don't wrap the text.
set nowrap

" Show my input in the bottom right for things like leader keybinds.
set showcmd

" Don't make an annoying noise when I do something like hit esc in normal mode.
set belloff=all

" Don't auto wrap text to a textwidth when pasted.
set textwidth=0

" Don't make a popup cmd window when executing a shell script.
set noshelltemp

" Pipe using 'tee' so it gets outputed to the stdout aswell as vim.
set shellpipe=\|\ tee

" Fold using the marker method.
set foldmethod=marker

" Make horizontal splits appear below.
set splitbelow

" Make vertical splits appear to the right.
set splitright

" Highlight matching pairs of {()} when the cursor is on one.
set showmatch

" Set the cmd history to 1000
set history=1000

" Show line number on the left hand side.
set number
" }}} --------------------------------------------------------------------------

" Indentation {{{ --------------------------------------------------------------
" Set tab to be equal to 2 spaces.
set tabstop=2

" Change the tab button to insert spaces instead of tabs.
set expandtab

" When auto indenting, use two spaces.
set shiftwidth=2
" }}} --------------------------------------------------------------------------

" Searching {{{ ----------------------------------------------------------------
" Start searching as I type.
set incsearch

" Ignore the case when searching.
set ignorecase

" Actually if the search contains an uppercase, then care about case.
set smartcase

" Search recursively for files down from the current workind directory.
set path+=**
" }}} --------------------------------------------------------------------------

" Wildmenu {{{ -----------------------------------------------------------------
" Enable tab-completion menu for commands.
set wildmenu

" Show all options and auto select the longest when hitting tab agains.
set wildmode=list:longest

" Ignore these file times in the menu.
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx

" }}} --------------------------------------------------------------------------

" Appearance {{{----------------------------------------------------------------
" Enable syntax highlighting
syntax on

" Set the colorscheme to nord, which is imported via the plugin manager.
colorscheme nord

" Highlight the cursor's current line.
set cursorline

" Highlight the cursor's current column.
set cursorcolumn

" Set a highlight at column 81. I like to keep lines under this column limit.
set colorcolumn=81

" If we have a gui, get rid of the toolbars and set the font.
if has("gui_running")
	set guioptions=
	set guifont=Consolas:h12:cANSI
endif
" }}} --------------------------------------------------------------------------

" Autocmds {{{ -----------------------------------------------------------------
" Remove trailing white spaces on save
autocmd BufWritePre * :%s/\s\+$//e

" Automattically turn search highlighting on and off.
augroup vimrc-incsearch-highlight
  autocmd!
  autocmd CmdlineEnter /,\? :set hlsearch
  autocmd CmdlineLeave /,\? :set nohlsearch
augroup END

augroup filetype_vim
  autocmd!
  " When we save the _vimrc file, load it.
  autocmd BufWritePost _vimrc source <sfile>
augroup END

augroup filetype_c
  autocmd!

  " Auto gen ctags on save for c files.
  autocmd BufWritePost *.c,*.h silent exec "!ctags -R ."
  " Set the make program to use build.bat, I currently use batch scripts for my
  " build scripts.
  autocmd FileType c set makeprg=build.bat
augroup END

" Turn cursorline and cursorcolumn on and off when switching windows.
augroup cursor_off
  autocmd!
  autocmd WinLeave * set nocursorline nocursorcolumn
  autocmd WinEnter * set cursorline cursorcolumn
augroup END

" Overwrite rooter's autocmds to also call NERDTree
augroup rooter
  autocmd!
  autocmd VimEnter,BufReadPost,BufEnter * nested if !g:rooter_manual_only | Rooter | NERDTreeCWD | endif
  autocmd BufWritePost * nested if !g:rooter_manual_only | call setbufvar('%', 'rootDir', '') | Rooter | endif
augroup END

" Open _vimrc by type :Rc
command Rc vs $HOME\_vimrc

" Open my dev projects folder by typing :Dev
command Dev edit C:\dev\projects
" }}} --------------------------------------------------------------------------

" Keybindings {{{ --------------------------------------------------------------
" My custom keybinds start with '\'
let mapleader = "\\"

" Insert '-' until column 80. Useful for denoting sections.
nnoremap <leader>- 1A<Space><Esc>80A-<Esc>d80<Bar>

" Open/close nerd tree
nnoremap <leader>t :NERDTreeToggle<CR>

" Enter normal mode by pressing jj
inoremap jj <Esc>

" Insert lines below and re-enter normal mode
nnoremap o o<Esc>
" Insert lines above and re-enter normal mode
nnoremap O O<Esc>

" Make the next item when searching in the middle of the screen
nnoremap n nzz
" Make the previous item when searching in the middle of the screen
nnoremap N Nzz

" Window resizing by holding ctrl and hitting the arrow keys.
nnoremap <c-up> <c-w>+
nnoremap <c-down> <c-w>-
nnoremap <c-left> <c-w>>
nnoremap <c-right> <c-w><
" }}} --------------------------------------------------------------------------

" Snippets {{{  ----------------------------------------------------------------
" Some handy snippets I use while coding.
nnoremap <leader>copy :-1read C:\dev\snippets\copyright.txt<CR>
nmap <leader>header \copy<CR>:-1read C:\dev\snippets\header.h<CR>wwciw<c-r>=expand('%:t:r')<CR>_H<ESC>gUiwyiwjciw<c-r>0<Esc>j<Insert>
" }}}

" Rooter Config {{{  -----------------------------------------------------------
" Change the working directory when opening .c and .h files.
let g:rooter_targets = "*.c, *.h"

" The root of the project usually contains a .git or a build.bat.
let g:rooter_paterns = [".git", "build.bat"]
" }}}  -------------------------------------------------------------------------

" Netrw Config {{{ ---------------------------------------------------------
" Remove banner
let g:netrw_banner=0

" Use previous window when opening a file.
let g:netrw_browse_split=4

" Use the tree file view.
let g:netrw_liststyle=3

" Use 80% of the netrw window when opening files.
let g:netrw_winsize=80
" }}} --------------------------------------------------------------------------

" vim-auto-popmenu Config {{{ --------------------------------------------------
" Do auto popup when editing text and c files.
let g:apc_enable_ft = {'text':1, 'c':1}

" Look at current file and includes, tags, and dictionary.
set cpt=i,],k

" Don't select first option when it opens.
set completeopt=menu,menuone,noselect

" Silence nusiance error msgs with the completion window.
set shortmess+=c
" }}} --------------------------------------------------------------------------

" NERDTree Config {{{ ----------------------------------------------------------
let NERDTreeAutoDeleteBuffer=1
" }}} --------------------------------------------------------------------------
