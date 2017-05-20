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
  set relativenumber " enable relative numbering too
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

" use , as the leader
let mapleader=","

let msyscon=$MSYSCON
let term=$TERM

if (has("multi_byte")) && (msyscon == 'mintty.exe')
  " disable unsupported listchars in mintty on Windows
  set listchars=
  set listchars+=trail:¬
  set listchars+=precedes:«
  set listchars+=extends:»
elseif (has("multi_byte")) && (term == 'cygwin')
  " we are probably running in powershell
  set listchars=

" multi byte support causes some weirdness on FreeBSD 
elseif (has("multi_byte")) && (g:uname != "FreeBSD") 
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

" configure indenting to work gqap correctly - not working quite right at the
" moment 
set showbreak=\ \\_
if exists('+breakindent')  " breakindent was not merged until 2014
  set breakindent
else
  " a more primative and hacky solution - does not work as well as breakindent
  set formatoptions=l
  set lbr
endif
set formatoptions+=q  " allow gqq to wrap comments

" disable hard wrapping
set wrap linebreak textwidth=0

" enable spell checking
set spell spelllang=en_us
set complete+=kspell " allow words as completions 
" render misspelled words with underlines, rather than highlights
highlight clear SpellBad
highlight clear SpellCap
highlight clear SpellRare
highlight clear SpellLocal
highlight SpellBad cterm=underline 
highlight SpellLocal cterm=underline

" enable content continuation on enter
set formatoptions+=cro

" colorscheme handling
set background=light
if has('gui_running')
  " if the GUI is running, we don't need to do anything special

  "set background=dark
  "colorscheme solarized
elseif (&term == 'screen-256color')
  " we are running inside of tmux, so we also need to fix the background
  "set background=dark
  "let g:solarized_termcolors=256
  "set t_ut=   " fixes background refresh problem in tmux
  "colorscheme solarized
elseif (&t_Co == 256)
  " if we are using a terminal which supports 256 colors, use degrated 256 
  " color mode for solarized 

  "set background=dark
  "let g:solarized_termcolors=256
  "colorscheme solarized
elseif (&t_Co == 88)
  " likewise for 88 colors
  
  "set background=dark
  "let g:solarized_termcolors=88
  "colorscheme solarized
else
  " give up and assume this is a 16-color terminal
  " do nothing
endif

" correct handling of tabs and spaces in python files
autocmd FileType python setlocal tabstop=4
autocmd FileType python setlocal shiftwidth=4
autocmd FileType python setlocal softtabstop=4
autocmd FileType python setlocal expandtab

" fix broken behaviour for CHANGELOG files
autocmd BufEnter CHANGELOG setlocal filetype=text

" because net.cdaniels.toolchest uses .lib as an extension for shell
" libraries, we shall force them to be treated as .sh
autocmd BufEnter *.lib setlocal filetype=sh


