package main

import (
	"fmt"
	"log"
	"net/http"
	"time"

	"flag"

	"github.com/rjeczalik/notify"
)

func main() {
	address := flag.String("addr", ":8080", "the address to listen on")
	flag.Parse()

	http.Handle("/", http.FileServer(http.Dir("./")))
	http.HandleFunc("/_events", notifyOfFilesystemEvents)

	log.Fatal(http.ListenAndServe(*address, nil))
}

func notifyOfFilesystemEvents(rsp http.ResponseWriter, req *http.Request) {
	events := make(chan notify.EventInfo, 10)

	err := notify.Watch("./...", events, notify.All)
	if err != nil {
		log.Printf("unable to watch file system: %s", err)
		rsp.WriteHeader(http.StatusInternalServerError)
		return
	}
	defer notify.Stop(events)

	rsp.Header().Set("Content-Type", "text/event-stream")

	// TODO: keep alive event?
	// TODO: more meaningful payload?

	for {
		curEvents := readSome(events, 10*time.Millisecond)
		for _, event := range curEvents {
			_, err := fmt.Fprintf(rsp, "data: %s\n", event)
			if err != nil {
				log.Printf("client connection closed: %T, %s", err, err)
				return
			}
		}
		fmt.Fprintln(rsp)

		// if it's not a Flusher, we can't really send events
		// in a sane manner...
		rsp.(http.Flusher).Flush()
	}
}

// readSome reads the first T from the channel, as well as
// any subsequent Ts that arrive within the given duration.
//
// This helps to coalesce a flurry of events to prevent too
// much noise.
//
// For example, writing a file in neovim triggers 4+
// events, combining rename, remove, create and write.
func readSome[T any](c <-chan T, pause time.Duration) []T {
	var result []T
	result = append(result, <-c)

	deadline := time.After(pause)
	for {
		select {
		case t, ok := <-c:
			if !ok {
				return result
			}
			result = append(result, t)
		case <-deadline:
			return result
		}
	}
}
