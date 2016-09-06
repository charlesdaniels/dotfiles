""""""""" Master Keybind List """""""""""""""
" Alt + l - next buffer
" Alt + k - previous buffer
" Tab - toggle NERDtree
" Ctrl + n - toggle numbering mode
"""""""""""""""""""""""""""""""""""""""""""""


" load pathogen plugins
execute pathogen#infect()
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
colorscheme solarized
set colorcolumn=80,160,240,320,400,480,660,740,800


" show non-printing characters
set list
if has("multi_byte")
	" if we have multi byte support, enable pretty characters
	set listchars=tab:▸\ 
	set listchars+=trail:·
	set listchars+=space:·
	set listchars+=precedes:«
	set listchars+=extends:»
	set listchars+=eol:↲
else
	set listchars=tab:>-
	set listchars+=trail:.
endif

" airline configuration
let g:airline#extensions#tabline#enabled = 1  " enable tabline
let g:airline_theme = 'understated'  " set theme

" NERDtree config

" Open NERDTree in the directory of the current file (or /home if no file is
" open)
" see: http://superuser.com/a/868124
nmap <silent> <Tab> :call NERDTreeToggleInCurDir()<cr>
function! NERDTreeToggleInCurDir()
	" If NERDTree is open in the current buffer
	if (exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1)
		exe ":NERDTreeClose"
	else
		exe ":NERDTreeFind"
	endif
endfunction

" buffer cycling
nnoremap <C-l> :bnext!<CR>
nnoremap <C-k> :bprevious!<CR>
