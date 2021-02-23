# pinyin translator.

An extremely simple server that converts Chinese characters to pinyin using [CC-CEDICT](https://cc-cedict.org/editor/editor.php) dictionary.
Using this dictionary enables us to translate context-dependent word such as 银行 where 行 has multiple possible pronunciation.

Behind the scene, this server simply uses [github.com/jcramb/cedict](https://github.com/jcramb/cedict) package for downloading dictionary and translate Chinese characters.

## Getting started

1. Start translation server

```bash
$ docker run --rm -p 8080:8080 ghcr.io/hitochan777/pinyin-translator
```

2. Send http request

```bash
$ curl localhost:8080?q=银行
Yín háng
```

## License

MIT
