package main

import (
	"fmt"
	"log"
	"os"
	"path"

	"github.com/jcramb/cedict"
)

func createCacheDirIfNotExists() (string, error) {
	homedir, err := os.UserHomeDir()
	if err != nil {
		return "", fmt.Errorf("Unexpected error occurred while finding home directory")
	}
	cacheDir := path.Join(homedir, ".cache", "pinying_translator")
	if _, err := os.Stat(cacheDir); os.IsNotExist(err) {
		if err := os.Mkdir(cacheDir, 0700); err != nil {
			return "", err
		}
	}
	return cacheDir, nil
}

func loadDict() (*cedict.Dict, error) {
	cacheDir, err := createCacheDirIfNotExists()
	if err != nil {
		return nil, err
	}
	cacheFile := path.Join(cacheDir, "dict.gz")
	var dict *cedict.Dict
	if _, err := os.Stat(cacheFile); os.IsNotExist(err) {
		dict = cedict.New()
		dict.Save(cacheFile)
	} else {
		dict, err = cedict.Load(cacheFile)
		if err != nil {
			// file is broken
			dict = cedict.New()
		}
	}
	return dict, nil
}

func main() {
	dict, err := loadDict()
	if err != nil {
		log.Fatalln("Unexpected error while loading dictionary")
		return
	}
	var input string
	fmt.Scanln(&input)
	fmt.Printf("%s", cedict.PinyinTones(dict.HanziToPinyin(input)))
}
