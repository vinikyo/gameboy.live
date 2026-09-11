package main

import (
	"flag"
	"github.com/HFO4/gbc-in-cloud/static"
)

func main() {
	var port int
	var romPath string

	flag.IntVar(&port, "p", 1989, "Set port")
	flag.StringVar(&romPath, "r", "", "Set ROM path")
	flag.Parse()

	server := static.StaticServer{
		Port:     port,
		GamePath: romPath,
	}

	server.Run()
}
