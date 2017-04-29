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
  set formatoptions=l
  set lbr
endif

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

" documentation helper keymapping (C-g should generate something useful when 
" possible)

autocmd FileType python nmap <silent> <C-g> <Plug>(pydocstring)

