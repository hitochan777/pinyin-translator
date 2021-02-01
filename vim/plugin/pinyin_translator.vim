
scriptencoding utf-8

command! -range -nargs=? PinyinTranslate call pinyin_translator#translate(<q-args>)
