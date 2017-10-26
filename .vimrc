" Install plugins
call plug#begin('~/.local/share/nvim/plugged')

Plug 'scrooloose/nerdtree'
Plug 'gi1242/vim-tex-syntax'
Plug 'jvirtanen/vim-octave'
Plug 'christoomey/vim-tmux-navigator'
Plug 'heavenshell/vim-pydocstring'
Plug 'PProvost/vim-ps1'
Plug 'majutsushi/tagbar'
Plug 'scrooloose/nerdcommenter'
Plug 'godlygeek/tabular'
Plug 'Rykka/riv.vim'
Plug 'sukima/xmledit'
Plug 'twmht/jcommenter.vim'
Plug 'csexton/trailertrash.vim'
Plug 'xolox/vim-misc'
Plug 'xolox/vim-easytags'
Plug 'kien/ctrlp.vim'
Plug 'keith/investigate.vim'
Plug 'roxma/vim-paste-easy'
Plug 'chrisbra/csv.vim'
Plug 'mzlogin/vim-markdown-toc'
Plug 'dhruvasagar/vim-table-mode'

call plug#end()

""""""""""""""" Platform Independent """""""""""""""""

filetype plugin indent on      " guess indent based on file type
syntax on                      " enable syntax highlighting
set cursorline                 " highlight the active line
hi clear CursorLine
hi CursorLine gui=underline cterm=underline cterm=underline
set number                     " use line numbering
set laststatus=2               " always render the statusline
set ignorecase                 " use case insensitive searching by default
set nocompatible               " fix odd behavior on some older systems
set ruler                      " display column and line number in statusline
set backspace=indent,eol,start " fix dumbass default backspace behavior
set nowrap                     " disable line wrapping
set formatoptions+=cro         " enable content continuation on enter
set bg=light                   " assume a light background
set shortmess+=I               " disable welcome message on blank file
set virtualedit=block          " allow visual block past EOL

" enable a nice interactive menu for tab-completing buffers and such
set wildmenu
set wildmode=longest:full,full

let mapleader=","         " use , as the leader

" enable colorcolumns if available
if exists("+colorcolumn")
	set colorcolumn=80,160,240,320,400,480,660,740,820
endif

" enable relative line numbering if available
if exists("+relativenumber")
	set relativenumber " enable relative numbering too
endif

" enable mouse support if available
if has("mouse")
	set mouse=a
endif

""""""""""""""" Key Mapping """"""""""""""""""

nnoremap <F1> <nop> " don't open help with F1

""""""""""""""" Detect Platform """"""""""""""

let g:uname = substitute(system("uname"), '\n\+$', '', '')

" platform will be POSIX, NT, or UNKNOWN
" variant refers to the flavor, such as POSIX/Linux, or POSIX/BSD

let g:platform = "UNKNOWN"
let g:variant = "UNKNOWN"

if (has("win32") || has("win64"))
	let g:platform = "NT"
	let g:variant = "NT"
endif

if g:uname =~ "FreeBSD"
	let g:platform = "POSIX"
	let g:variant = "BSD"
endif

if g:uname =~ "Linux"
	let g:platform = "POSIX"
	let g:platform = "LINUX"
endif

if g:uname =~ "MINGW"
	let g:platform = "POSIX"
	let g:variant = "MINGW"
endif

if g:uname =~ "Darwin"
	let g:platform = "POSIX"
	let g:variant = "MACOS"
endif

"""""""""""""""" Configure Shell """"""""""""""""'

set shell=/bin/sh

if g:platform == "NT"
	set shell=C:\Windows\system32\cmd.exe
endif

"""""""""""""""" UTF-8 Detection & Setup """"""""""""""""

let g:multibytesupport = "NO"
if has("multi_byte") || has ("multi_byte_ime/dyn")
	let g:multibytesupport = "YES"
endif

" this is a shot in the dark, and may break on very old systems
if has('gui_running')
	let g:multibytesupport = "YES"
endif

if g:multibytesupport == "YES"
	" we can only enable utf-8 if we have multi byte support compiled in
	scriptencoding utf-8
	set encoding=utf-8
	set fileencoding=utf-8
	set fileencodings=ucs-bom,utf8,prc
	set langmenu=en_US.UTF-8
endif

"""""""""""""""""" GUI Configuration """"""""""""""""""

if has('gui_running')
	" set the GUI font
	let g:normalGUIFont="Andale_Mono:h8"
	let g:largeGUIFont="Andale_Mono:h14"
	let &guifont=g:normalGUIFont

	" make the GUI be not stupid
	set guioptions=Ace
endif

""""""""""""""""" listchars Configuration """""""""""""""""

" show non-printing characters

set list
set listchars=
set listchars+=trail:¬
set listchars+=precedes:«
set listchars+=extends:»
set listchars+=tab:>-

"""""""""""""""" Presentation Mode """"""""""""""""

function EnterPresentationMode()
	if has('gui_running')
		let &guifont=g:largeGUIFont
	endif
	set nolist
	hi clear SpellBad
	hi clear SpellLocal
endfunction

function ExitPresentationMode()
	if has('gui_running')
		let &guifont=g:normalGUIFont
	endif
	set list
	highlight SpellBad cterm=underline gui=underline
	highlight SpellLocal cterm=underline gui=underline
	call ApplyWorkarounds()
endfunction


"""""""""""""""" Spaces & Tabs """"""""""""""""""""

function TwoSpacesSoftTabs()
	set tabstop=2
	set shiftwidth=2
	set softtabstop=2
	set expandtab
endfunction

function EightSpacesHardTabs()
	set tabstop=8
	set shiftwidth=8
	set softtabstop=8
	set noexpandtab
endfunction

function FourSpacesSoftTabs()
	set tabstop=4
	set shiftwidth=4
	set softtabstop=4
	set expandtab
endfunction

function FourSpacesHardTabs()
	set tabstop=4
	set shiftwidth=4
	set softtabstop=4
	set noexpandtab
endfunction

" use "normal" tabs n spaces by default
call EightSpacesHardTabs()

"""""""""""""" FileType Specific Configuration """"""""""""

" forcibly use the c filetype for all header files
autocmd BufNewFile,BufRead *.h,*.c set filetype=c

" verilog-related
autocmd BufNewFile,BufRead *.v set filetype=verilog
autocmd BufNewFile,BufRead *.tv set filetype=text

" use tex filetype for *.tex
autocmd BufNewFile,BufRead *.tex,*.sty set filetype=tex

" Handle YAML files correctly
autocmd BufNewFile,BufRead *.yml,*.yaml,Sakefile set filetype=yaml

" fix broken behaviour for CHANGELOG files
autocmd BufEnter CHANGELOG setlocal filetype=text

" because net.cdaniels.toolchest uses .lib as an extension for shell
" libraries, we shall force them to be treated as .sh
autocmd BufEnter *.lib setlocal filetype=sh

" set up tab & space behaviour sensibly
autocmd FileType c call EightSpacesHardTabs()
autocmd FileType java call FourSpacesSoftTabs()
autocmd FileType python call FourSpacesSoftTabs()
autocmd FileType tex call EightSpacesHardTabs()
autocmd FileType yaml call FourSpacesSoftTabs()
autocmd FileType sh call EightSpacesHardTabs()
autocmd FileType perl call EightSpacesHardTabs()
autocmd FileType verilog call EightSpacesHardTabs()

"""""""""""""" Text re-wrapping (gq) """"""""""""""""""""

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

""""""""""""""""" Spell-Checking """"""""""""""""""

if has("spell")
	" enable spell checking
	set spell spelllang=en_us
	set complete+=kspell " allow words as completions
	" render misspelled words with underlines, rather than highlights
	highlight clear SpellBad
	highlight clear SpellCap
	highlight clear SpellRare
	highlight clear SpellLocal
	highlight SpellBad cterm=underline gui=underline
	highlight SpellLocal cterm=underline gui=underline
endif

"""""""""""""""" Platform-Specific Workarounds """""""""""""""""

function ApplyWorkarounds()

	" sometimes vim cannot write to /tmp in embedded configurations like
	" Windows's git bundled POSIX environment.
	if g:platform == "NT"
		let $TMPDIR = $HOME."\\tmp"
	endif

	" Windows terminal environments do not play nice with underlining, so we
	" want to disable that on Windows, but only if the GUI is not running.
	if g:platform == "NT" && !has('gui_running')
		hi clear CursorLine
		" sadly, this also affects misspellings
		hi clear SpellBad
		hi clear SpellCap
		hi clear SpellRare
		hi clear SpellLocal
	endif
endfunction

call ApplyWorkarounds()

""""""""""" NERDTree """"""""""""""

" also map to C-Tab in GUI mode, since some platforms behave strangely with
" C-e
if has("gui_running")
	map <C-Tab> :NERDTreeToggle<Cr>
endif

" Open NERDTree in the directory of the current file¬
" (or /home if no file is open)
" From here: https://superuser.com/a/868124

nmap <silent> <C-e> :silent! call NERDTreeToggleInCurDir()<cr>
function! NERDTreeToggleInCurDir()
	" If NERDTree is open in the current buffer
	if (exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1)
		exe ":NERDTreeClose"
	else
		exe ":NERDTreeFind"
		" refresh the view
		call g:NERDTree.ForCurrentTab().getRoot().refresh() |
		call g:NERDTree.ForCurrentTab().render() |
		wincmd w
	endif
endfunction


"""""""""" vim-octave """""""""""

" this is required for octave.vim to work correctly, not entirely sure why

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

" we will force .m file to be treated as octave, which to my knowledge is the
" default extension for MATLAB/octave files. The default behavior is to treat
" *.m as some kind of objective-c header type thing.
autocmd BufEnter *.m setlocal filetype=octave

""""""""""" vim-pydocstring """""""""""""""

" C-g should generate docs in supported languages
autocmd FileType python nmap <silent> <C-g> <Plug>(pydocstring)

""""""""""""""""" tagbar """""""""""""""

nmap <F8> :TagbarToggle<CR>  " map tagbar to F8
let g:tagbar_type_ps1 = {
			\ 'ctagstype' : 'powershell',
			\ 'kinds'     : [
			\ 'f:function',
			\ 'i:filter',
			\ 'a:alias'
			\ ]
			\ }

""""""""""" NERDCommenter """""""""""""

let g:NERDSpaceDelims = 1  " spaces after comment char
let g:NERDDefaultAlign = 'left'  " align comments to left edge of file
let g:NERDCommentEmptyLines = 1  " allow empty lines to be commented

""""""""""""""" riv.vim """"""""""""""'

let g:riv_global_leader = "<C-U>"
let g:riv_fold_level = 1
let g:riv_fold_blank = 1


"""""""""""" jcommenter """""""""""""

autocmd FileType java nmap <silent> <C-g> :call JCommentWriter()<CR>
autocmd FileType java let b:jcommenter_class_author=system('git config user.name')
autocmd FileType java let b:jcommenter_file_author=system('git config user.email')

""""""""" TrailerTrash """"""""

" note that I just want :TrailerTrim, so I disable hilighting like so
autocmd BufEnter * TrailerHide
autocmd InsertLeave * TrailerHide
nnoremap <Leader>tt :TrailerTrim<CR>

" prevent vim-table-mode from overriding <LeadeR>tt
autocmd BufEnter * :silent! nnoremap <Leader>tt :TrailerTrim<CR>

"""""""""" ctrlP """""""""""

" show dotfiles
let g:ctrlp_show_hidden = 1
let g:ctrlp_dotfiles = 1

"""""""""" Investigate.vim """""""""

let g:investigate_use_dash=1  " use dash on OSX

""""""""""""""" csv.vim """""""""""""""

" left-align all columns
autocmd FileType csv let b:csv_arrange_align='l*'

" always display CSV files as tables
aug CSV_Editing
	au!
	au BufRead,BufWritePost *.csv :%ArrangeColumn!
	au BufWritePre *.csv :%UnArrangeColumn
aug end

" don't render whitespace in CSV files
autocmd FileType csv set nolist

""""""""" vim-table-mode """""""""""""

" Markdown
autocmd FileType markdown let g:table_mode_corner='|'
autocmd FileType markdown let g:table_mode_header_fillchar='-'

" reST
autocmd FileType rst let g:table_mode_corner='+'
autocmd FileType rst let g:table_mode_header_fillchar='-'


""""""""""""" vim-tmux-navigator """"""""""""

function MapTmuxNavigator ()
	noremap<silent> <C-h> :TmuxNavigateLeft<cr>
	noremap<silent> <C-j> :TmuxNavigateDown<cr>
	noremap<silent> <C-k> :TmuxNavigateUp<cr>
	noremap<silent> <C-l> :TmuxNavigateRight<cr>
endfunction

" other plugins insist on overriding vim-tmux-navigator's bindings
autocmd BufEnter,BufWritePost * call MapTmuxNavigator()

call MapTmuxNavigator()

