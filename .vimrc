"""""""" Master Keybind List """""""""""""""
" Alt + l - next buffer
" Alt + k - previous buffer
"""""""""""""""""""""""""""""""""""""""""""""


" use utf-8
if has ("multi_byte")
	" we can only enable utf-8 if we have multi byte support compiled in
	scriptencoding utf-8
	set encoding=utf-8
	set fileencoding=utf-8
	set fileencodings=ucs-bom,utf8,prc
	set langmenu=en_US.UTF-8
endif

set shell=/bin/sh
let g:uname = substitute(system("uname"), '\n\+$', '', '')

filetype plugin indent on  " guess indent based on file type
syntax on  " enable syntax highlighting
set cursorline  " highlight the active line
set number  " use line numbering
set laststatus=2
if version >= 703
	" setting colorcolumn in VIM 7.2.22 on OSX 10.5.8 PPC breaks
	set colorcolumn=80,160,240,320,400,480,660,740,800
endif
set nocompatible  "fix odd behavior on some older systems 
set ruler  " display column and line number in statusline

" show non-printing characters
" NOTE: it seems that for whatever reason, using anything involving set list
" or set listchars breaks horribly under FreeBSD 11. For that reason, FreeBSD
" wont trigger these commands. 
if g:uname != "FreeBSD"
	set list
endif

if (has("multi_byte")) && (g:uname != "FreeBSD")  " multi byte dosent work on 
						  " freeBSD quite right
	" if we have multi byte support, enable pretty characters
	set listchars=tab:▸\ 
	set listchars+=trail:¬
	set listchars+=precedes:«
	set listchars+=extends:»
	set listchars+=eol:↲
elseif (g:uname != "FreeBSD")
	set listchars=tab:>-
	set listchars+=trail:_
endif

" buffer cycling
nnoremap <C-l> :bnext!<CR>
nnoremap <C-k> :bprevious!<CR>


set backspace=indent,eol,start " fix dumbass default backspace behavior 

set nowrap " disable line wrapping

" enable a nice interactive menu for tab-completing buffers and such
set wildmenu
set wildmode=longest:full,full

" enable mouse support
set mouse=a

" spaces instead of tabs
set tabstop=2
set shiftwidth=2
set expandtab
set softtabstop=2

" hook into pathogen
execute pathogen#infect()

" NERDTree
noremap <C-e> :NERDTreeToggle<CR>

" configure indenting to work gqap correctly - not working quite right at the
" moment 
set showbreak=\ \\_
if exists('+breakindent')  " breakindent was not merged until 2014
  set breakindent
else
  " a more primative and hacky solution - does not work as well as breakindent
  set formatioptions=l
  set lbr
endif

" disable hard wrapping
set wrap linebreak textwidth=0

" enable spell checking
set spell spelllang=en_us
set complete+=kspell " allow words as completions 
" render misspelled words with underlines, rather than highlights
highlight clear SpellBad
highlight SpellBad cterm=underline 

" enable content continuation on enter
set formatoptions+=cro

" This is required to make octave.vim work correctly
if has("autocmd") && exists("+omnifunc") 
  autocmd Filetype octave 
    \ if &omnifunc == "" | 
    \ setlocal omnifunc=syntaxcomplete#Complete | 
    \ endif 
endif 

" set octave syntax highlighting for .m
if has("autocmd")
  autocmd BufNewFile,BufRead *.m set syntax=octave
  autocmd BufNewFile,BufRead *.m set filetype=octave
endif

