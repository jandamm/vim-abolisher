augroup abolish_auto_write
	au!
	autocmd BufWritePost *.abolish call s:ExpandAbolish()
augroup END

command! -buffer Abolisher call s:ExpandAbolish()

let s:abolisher_cmd = expand('<sfile>:p:h') . '/../bin/abolisher'

function! s:ExpandAbolish() abort
	let file = expand('%:p:r') . '.vim'
	let output = system(s:abolisher_cmd . ' ' . expand('%:p') . ' > ' . file)
	if len(output) == 0
		echo 'Expanded ' . expand('%') . ' into ' . file . '.'
	else
		echo 'Something went wrong while expanding ' . expand('%') . ':'
		echo output
	endif
endfunction
