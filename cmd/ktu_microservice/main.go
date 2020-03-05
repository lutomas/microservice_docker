package main

import (
	"encoding/xml"
	"fmt"
	"net/http"

	json "github.com/dustin/gojson"
)

type Published struct {
	By   string
	Year int
}
type Book struct {
	ID        int
	Author    string
	Title     string
	Published Published
}

func main() {
	http.HandleFunc("/books/1", BooksHandler)
	http.HandleFunc("/", DefaultHandler)
	//http.HandleFunc("/", HelloServer)
	fmt.Println("SERVER STARTING: http://localhost:8080")
	http.ListenAndServe(":8080", nil)
}

func HelloServer(w http.ResponseWriter, r *http.Request) {
	fmt.Fprint(w, "Hello web!")
}

func DefaultHandler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprint(w, "It works!")
}

func BooksHandler(w http.ResponseWriter, r *http.Request) {
	book := Book{
		ID:     123,
		Author: "Homeras",
		Title:  "Iliada",
		Published: Published{
			By:   "Vaga",
			Year: 2020,
		},
	}

	var b []byte

	acceptHeader := r.Header.Get("Accept")
	fmt.Println("---- REQ: ", acceptHeader)

	if acceptHeader == "application/xml" {
		w.Header().Set("Content-Ty"+
			"pe", acceptHeader)
		b, _ = xml.MarshalIndent(book, "", "  ")
	} else if acceptHeader == "application/json" {
		w.Header().Set("Content-Type", acceptHeader)
		b, _ = json.MarshalIndent(book, "", "  ")
	} else {
		w.WriteHeader(http.StatusUnsupportedMediaType)
	}

	fmt.Fprint(w, string(b))
}
