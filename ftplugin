augroup abolish_auto_write
	au!
	autocmd BufWritePost *.abolish call s:ExpandAbolish()
augroup END

function! s:ExpandAbolish() abort
	let file = expand('%:r') . '.vim'
	silent! execute '!abolisher % > ' . file
	echo 'Expanded ' . expand('%') . ' into ' . file . '.'
endfunction
