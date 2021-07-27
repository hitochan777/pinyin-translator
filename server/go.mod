module github.com/hitochan777/pinyin-translator/server

go 1.15

require (
	github.com/jcramb/cedict v1.0.1-0.20210401151953-11305676af34 // indirect
	golang.org/x/text v0.3.6 // indirect
)

replace github.com/jcramb/cedict => github.com/hitochan777-misc/cedict v1.0.1-0.20210717101349-231395985baa
