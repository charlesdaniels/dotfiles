" Install plugins
call plug#begin('~/.local/share/nvim/plugged')

Plug 'scrooloose/nerdtree'
Plug 'gi1242/vim-tex-syntax'
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
Plug 'vim-scripts/DoxygenToolkit.vim'
Plug 'mtth/scratch.vim'
Plug 'ledger/vim-ledger'
Plug 'lazywei/vim-matlab'
Plug 'morhetz/gruvbox'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'KSP-KOS/EditorTools', {'rtp': 'VIM/vim-kerboscript'}

call plug#end()

""""""""10""""""""20"""""""" platform independent """"""""60""""""""70""""""""80

filetype plugin indent on      " guess indent based on file type
syntax on                      " enable syntax highlighting
set cursorline                 " highlight the active line
hi clear CursorLine
hi CursorLine gui=underline cterm=underline cterm=underline
set number                     " use line numbering
set laststatus=2               " always render the statusline
set ignorecase                 " use case insensitive searching by default
set smartcase                  " except for when capital letters are used
set nocompatible               " fix odd behavior on some older systems
set ruler                      " display column and line number in statusline
set backspace=indent,eol,start " fix dumbass default backspace behavior
set nowrap                     " disable line wrapping
set formatoptions+=cro         " enable content continuation on enter
set bg=dark                    " assume a dark background
colorscheme default            " explicitly use the default colorscheme
set shortmess+=I               " disable welcome message on blank file
set virtualedit=block          " allow visual block past EOL
set ttyfast

" enable a nice interactive menu for tab-completing buffers and such
set wildmenu
set wildmode=longest:full,full

let mapleader=","         " use , as the leader

" enable colorcolumns if available
if exists("+colorcolumn")
	set colorcolumn=80,160,240,320,400,480,660,740,820
	hi ColorColumn ctermbg=red guibg=red
endif

" enable relative line numbering if available
if exists("+relativenumber")
	set relativenumber " enable relative numbering too
endif

" enable mouse support if available
if has("mouse")
	set mouse=a
	if !has('nvim')
		" for tmux compatibility
		set ttymouse=xterm2
	endif
endif

" Yank to system clipboard with ,yc
noremap <Leader>yc "+yy

" Visualize Makefiles
noremap <Leader>vm :!visualize-makefile %:p <CR> <CR>

""""""""10""""""""20""""""""30""" key mapping ""50""""""""60""""""""70""""""""80

nnoremap <F1> <nop> " don't open help with F1


""""""""10""""""""20""""""""3 platform detection 0""""""""60""""""""70""""""""80

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

""""""""10""""""""20""""""""3 shell configuration """"""""60""""""""70""""""""80

set shell=/bin/sh

if g:platform == "NT"
	set shell=C:\Windows\system32\cmd.exe
endif

""""""""10""""""""20""""""""30" UTF-8 handling "50""""""""60""""""""70""""""""80

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

""""""""10""""""""20""""""""30 GUI configuration 0""""""""60""""""""70""""""""80

if has('gui_running')
	" set the GUI font
	let g:normalGUIFont="Gohufont 10"
	let g:largeGUIFont="Monospace 14"
	set bg=dark
	colorscheme gruvbox
	let &guifont=g:normalGUIFont

	" make the GUI be not stupid
	set guioptions=Ace
else
	let t_Co=256 " force 256 color
	set bg=dark
	colorscheme gruvbox
	set lazyredraw
endif

""""""""10""""""""20""""""" listchars configuration """"""60""""""""70""""""""80

" show non-printing characters

set list
set listchars=
set listchars+=trail:¬
set listchars+=precedes:«
set listchars+=extends:»
set listchars+=tab:→⋅

""""""""10""""""""20""""""""30 presentation mode 0""""""""60""""""""70""""""""80

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

""""""""10""""""""20"""""""" indentation settings """"""""60""""""""70""""""""80

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

""""""""10""""""""20""""""" filetype configuration """""""60""""""""70""""""""80

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
autocmd FileType rst call FourSpacesSoftTabs()
autocmd FileType python call FourSpacesSoftTabs()
autocmd FileType tex call EightSpacesHardTabs()
autocmd FileType yaml call FourSpacesSoftTabs()
autocmd FileType sh call EightSpacesHardTabs()
autocmd FileType perl call EightSpacesHardTabs()
autocmd FileType verilog call EightSpacesHardTabs()
autocmd FileType json call FourSpacesSoftTabs()
autocmd FileType matlab call FourSpacesSoftTabs()

""""""""10""""""""20"""" text wrapping (gq) behaviour """"60""""""""70""""""""80

" configure indenting to work gqap correctly - not working quite right at the
" moment
set showbreak=\ \\_
if exists('+breakindent')  " breakindent was not merged until 2014
	set breakindent
else
	" a more primative and hacky solution - does not work as well as
	" breakindent
	set formatoptions=l
	set lbr
endif
set formatoptions+=q  " allow gqq to wrap comments

" disable hard wrapping
set wrap linebreak textwidth=0

""""""""10""""""""20""""""""30" spell checking "50""""""""60""""""""70""""""""80

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

""""""""10""""""""20""""""""30""" workarounds ""50""""""""60""""""""70""""""""80

function ApplyWorkarounds()

	" sometimes vim cannot write to /tmp in embedded configurations like
	" Windows's git bundled POSIX environment.
	if g:platform == "NT"
		let $TMPDIR = $HOME."\\tmp"
	endif

	" Windows terminal environments do not play nice with underlining, so
	" we want to disable that on Windows, but only if the GUI is not
	" running.
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

""""""""10""""""""20""""""" NERDTree configuration """""""60""""""""70""""""""80

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


""""""""10""""""""20"""" vim-pydocstring configuration """60""""""""70""""""""80

" C-g should generate docs in supported languages
autocmd FileType python nmap <silent> <C-g> <Plug>(pydocstring)

""""""""10""""""""20"""""""" tagbar configuration """"""""60""""""""70""""""""80

nmap <F8> :TagbarToggle<CR>  " map tagbar to F8
let g:tagbar_type_ps1 = {
			\ 'ctagstype' : 'powershell',
			\ 'kinds'     : [
			\ 'f:function',
			\ 'i:filter',
			\ 'a:alias'
			\ ]
			\ }

""""""""10""""""""20""""" NERDCommenter configuration """"60""""""""70""""""""80

let g:NERDSpaceDelims = 1  " spaces after comment char
let g:NERDDefaultAlign = 'left'  " align comments to left edge of file
let g:NERDCommentEmptyLines = 1  " allow empty lines to be commented

""""""""10""""""""20"""""""" riv.vim configuration """""""60""""""""70""""""""80

let g:riv_global_leader = "<C-U>"
let g:riv_fold_level = 1
let g:riv_fold_blank = 1
let g:riv_file_link_style = 2 " Sphinx cross reference syntax

let project1 = {
		\ 'Name': 'wiki',
		\ 'path': '~/src/git/wiki-next/source',
		\ 'scratch_path': 'Diary'}
let g:riv_projects = [project1]

" vimwiki-like bindings, for convenience
nmap <Leader>ww <C-U>ww zR
nmap <Leader>sc <C-U>sc zR

" build wiki using ,wb
nmap <Leader>wb :! ~/src/git/wiki-next/build_wiki.sh  <enter>

""""""""10""""""""20"""""" jcommenter configuration """"""60""""""""70""""""""80

autocmd FileType java nmap <silent> <C-g> :call JCommentWriter()<CR>
autocmd FileType java let b:jcommenter_class_author=system('git config user.name')
autocmd FileType java let b:jcommenter_file_author=system('git config user.email')

""""""""10""""""""20""""" TrailerTrash configuration """""60""""""""70""""""""80

" note that I just want :TrailerTrim, so I disable hilighting like so
autocmd BufEnter * TrailerHide
autocmd InsertLeave * TrailerHide
nnoremap <Leader>tt :TrailerTrim<CR>

" prevent vim-table-mode from overriding <LeadeR>tt
autocmd BufEnter * :silent! nnoremap <Leader>tt :TrailerTrim<CR>

""""""""10""""""""20""""""""3 ctrlP configuration """"""""60""""""""70""""""""80

" show dotfiles
let g:ctrlp_show_hidden = 1
let g:ctrlp_dotfiles = 1

""""""""10""""""""20"""" investigate.vim configuration """60""""""""70""""""""80

let g:investigate_use_dash=1  " use dash on OSX

""""""""10""""""""20"""""""" csv.vim configuration """""""60""""""""70""""""""80

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

""""""""10""""""""20"""" vim-table-mode configuration """"60""""""""70""""""""80

" Markdown
autocmd FileType markdown let g:table_mode_corner='|'
autocmd FileType markdown let g:table_mode_header_fillchar='-'

" reST
autocmd FileType rst let g:table_mode_corner='+'
autocmd FileType rst let g:table_mode_header_fillchar='-'

""""""""10""""""""20"" vim-tmux-navigator configuration ""60""""""""70""""""""80

function MapTmuxNavigator ()
	noremap<silent> <C-h> :TmuxNavigateLeft<cr>
	noremap<silent> <C-j> :TmuxNavigateDown<cr>
	noremap<silent> <C-k> :TmuxNavigateUp<cr>
	noremap<silent> <C-l> :TmuxNavigateRight<cr>
endfunction

" other plugins insist on overriding vim-tmux-navigator's bindings
autocmd BufEnter,BufWritePost * call MapTmuxNavigator()

call MapTmuxNavigator()

""""""""10""""""""20""" vim-markdown-toc configuration """60""""""""70""""""""80
" auto update TOC on save
let g:vmt_auto_update_on_save = 1

""""""""10""""""""20""""""""30" DoxygenToolkit "50""""""""60""""""""70""""""""80

autocmd FileType c nmap <silent> <C-g> :Dox <CR>

""""""""10""""""""20""""""""30" colortool      "50""""""""60""""""""70""""""""80

" TODO: should do something like this (http://vim.wikia.com/wiki/Indent_text_object)
" to create a visual maping so that vic/vac selects the RGB or HEX color under
" the cursor.

vnoremap <silent> <leader>vc :'<,'>:w !colortool -c "$(cat /dev/stdin)" -d <CR> <CR>


""""""""10""""""""20""""""""30" indentLine     "50""""""""60""""""""70""""""""80

let g:indentLine_char = '⋮'
if has('gui_running')
	let g:indentLine_setConceal = 0
	let g:indentLine_enabled = 0
endif


""""""""10""""""""20""""""""30" indentGuide    "50""""""""60""""""""70""""""""80

if has('gui_running')
	let g:indent_guides_enable_on_vim_startup = 1
endif
