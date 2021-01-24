package main

import (
	"context"
	"fmt"
	"log"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"

	"github.com/jcramb/cedict"
)

type Router struct {
	dict *cedict.Dict
}

func (r *Router) handler(writer http.ResponseWriter, reader *http.Request) {
	hanzi := reader.URL.Query().Get("q")
	if len(hanzi) == 0 {
		writer.WriteHeader(http.StatusBadRequest)
		return
	}
	fmt.Fprintf(writer, "%s", cedict.PinyinTones(r.dict.HanziToPinyin(hanzi)))
}

func NewServer(port string) *http.Server {
	d := cedict.New()
	router := &Router{dict: d}
	mux := http.NewServeMux()
	mux.HandleFunc("/", router.handler)
	srv := &http.Server{
		Addr:    ":" + port,
		Handler: mux,
	}
	return srv
}

func main() {
	port := os.Getenv("PORT")
	if len(port) == 0 {
		port = "8080"
	}
	srv := NewServer(port)
	go func() {
		if err := srv.ListenAndServe(); err != http.ErrServerClosed {
			log.Fatalln("Server closed with error:", err)
		}
	}()

	quit := make(chan os.Signal, 1)
	signal.Notify(quit, syscall.SIGTERM, os.Interrupt)
	sig := <- quit 
	log.Printf("SIGNAL %d received, then shutting down...\n", sig)

	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()
	if err := srv.Shutdown(ctx); err != nil {
		// Error from closing listeners, or context timeout:
		log.Println("Failed to gracefully shutdown:", err)
	}
	log.Println("Server shutdown")
}
