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

if v:version <= 702
	language en
endif

syntax on  " enable syntax highlighting
filetype plugin indent on  " guess indent based on file type
set cursorline  " highlight the active line
set number  " use line numbering
set laststatus=2
set colorcolumn=80,160,240,320,400,480,660,740,800
set nocompatible  "fix odd behaviour on some older systems 
set ruler  " display column and line number in statusline
set mouse=a  " enable mouse support

" show non-printing characters
set list
if has("multi_byte")
	" if we have multi byte support, enable pretty characters
	set listchars=tab:▸\ 
	set listchars+=trail:¬
	set listchars+=precedes:«
	set listchars+=extends:»
	set listchars+=eol:↲
	if v:version >= 704
		" if we are using a supported vim version, show whitespace
		set listchars+=space:␣
	endif
else
	set listchars=tab:>-
	set listchars+=trail:_
endif

" buffer cycling
nnoremap <C-l> :bnext!<CR>
nnoremap <C-k> :bprevious!<CR>


set backspace=indent,eol,start " fix dumbass default backspace behaviour 

set nowrap " disable line wrapping
