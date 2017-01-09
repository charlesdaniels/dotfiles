""""""""" Master Keybind List """""""""""""""
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

syntax on  " enable syntax highlighting
filetype plugin indent on  " guess indent based on file type
set cursorline  " highlight the active line
set number  " use line numbering
set laststatus=2
if version >= 703
	" setting colorcolumn in VIM 7.2.22 on OSX 10.5.8 PPC breaks
	set colorcolumn=80,160,240,320,400,480,660,740,800
endif
set nocompatible  "fix odd behaviour on some older systems 
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
	if v:version >= 704
		" if we are using a supported vim version, show whitespace
		try
			set listchars+=space:␣
		catch 
			" do nothing
		endtry
	endif
elseif (g:uname != "FreeBSD")
	set listchars=tab:>-
	set listchars+=trail:_
endif

" buffer cycling
nnoremap <C-l> :bnext!<CR>
nnoremap <C-k> :bprevious!<CR>


set backspace=indent,eol,start " fix dumbass default backspace behaviour 

set nowrap " disable line wrapping
