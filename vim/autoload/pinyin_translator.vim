scriptencoding utf-8

let s:endpoint = get(g:, "pinyin_translator_endpoint", "https://pinyin-translator.azurewebsites.net")
let s:is_online_mode = get(g:, "pinyin_translator_online", 0)
let s:dict_path = get(g:, "pinyin_translator_dict_dir", "~/.cache/pinyin_translator") . "/dict.txt"
let s:dict_url = "https://www.mdbg.net/chinese/export/cedict/cedict_1_0_ts_utf-8_mdbg.txt.gz"

function! s:get_selected_text() abort
  let lnum1 = getpos("'<")[1]
  let lnum2 = getpos("'>")[1]

  let lines = getline(lnum1, lnum2)
  let selectedText = join(lines, "\n")
  return selectedText
endfunction

function! s:get_temp_path() abort
  let temp_path = tempname()
  call mkdir(fnamemodify(temp_path, ":h"), "p")
  return temp_path
endfunction

function! s:download_cedict() abort
  echo "Downloading dictionary..."
  let temp_path = s:get_temp_path()
  let command = "curl --silent -O " . temp_path . " " . s:dict_url
  let result = system(command)
  echo "Downloaded"
endfunction

function! s:make_online_translate_command(text) abort
  let command = "curl --silent " . "'" . s:endpoint . "?q=" . a:text . "'"
  return command
endfunction

function! s:load_dict() abort
  if !exists(s:dict_path)
    call s:download_cedict()
  endif
  " TODO implement
  let dict = {}
  return dict
endfunction

function! s:translate_offline(text) abort
  if !get(s:, "dict")
    call s:load_dict()
  endif
  " TODO translate by longest sequence matching
endfunction

function! pinyin_translator#translate(text) abort
  let text = a:text
  if empty(text)
    let text = s:get_selected_text()
  endif

  let result = ""

  if s:is_online_mode == 1
    let command = s:make_online_translate_command(text)
    let result = system(command)
  else
    let result = s:translate_offline(text)
  end
  echo result
endfunction
