package main

import (
	"log"
	"os"
	"os/signal"
	"syscall"
)

var build = "development"

func main() {
	log.Println("Starting Service ", build)
	defer log.Println("Service Ended")
	shutdown := make(chan os.Signal, 1)
	signal.Notify(shutdown, syscall.SIGINT, syscall.SIGTERM)
	<-shutdown
	log.Println("Shutting Down")
}
