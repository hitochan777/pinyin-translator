scriptencoding utf-8

let s:endpoint = get(g:, "translate_endpoint", "https://pinyin-translator.azurewebsites.net")

" function s:GetCharAtByteIdx(str, index)
" 	" AFAIK maximum length of utf8-char is 4 byte
" 	let sp = a:str[a:index:(a:index+3)]
" 	let chr = strcharpart(sp, 0, 1)
" 	return [ chr, (a:index + strlen(chr)) ]
" endfunction

" this function does not work with multibyte characters
" quite pointless given that we want to translate Chinese characters to
" pinyin!
function! s:get_selected_text() abort
	let [lnum1, col1] = getpos("'<")[1:2]
	let [lnum2, col2] = getpos("'>")[1:2]

	" Get all the lines represented by this range
	let lines = getline(lnum1, lnum2)

	" The last line might need to be cut if the visual selection didn't end on the last column
	let lines[-1] = lines[-1][:col2 - 1]
	" let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
	" " The first line might need to be trimmed if the visual selection didn't start on the first column
	let lines[0] = lines[0][col1 - 1:]
	let selectedText = join(lines, "\n")
	return selectedText
endfunction

function! s:make_command(text) abort
	let command = "curl --silent " . "'" . s:endpoint . "?q=" . a:text . "'"
	return command
endfunction

function! pinyin_translator#translate(text) abort
	let text = a:text
  if empty(text)
		let text = s:get_selected_text()
	endif

	let command = s:make_command(text)
	let result = system(command)
	echo result
endfunction
