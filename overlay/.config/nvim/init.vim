source ~/.vimrc

""""""""10""""""""20"" vim-tmux-navigator configuration ""60""""""""70""""""""80

function TerminalMapTmuxNavigator ()
	tnoremap<silent> <C-h> <C-\><C-N>:TmuxNavigateLeft<cr>
	tnoremap<silent> <C-j> <C-\><C-N>:TmuxNavigateDown<cr>
	tnoremap<silent> <C-k> <C-\><C-N>:TmuxNavigateUp<cr>
	tnoremap<silent> <C-l> <C-\><C-N>:TmuxNavigateRight<cr>
endfunction

" other plugins insist on overriding vim-tmux-navigator's bindings
autocmd BufEnter,BufWritePost * call TerminalMapTmuxNavigator()
