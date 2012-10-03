package main

import "fmt"
import "./testb"

func main() {
    fmt.Printf("Hello world!\n")
    testb.Testa()
    Testd()
    coucou()
}

func coucou() {
    fmt.Printf("coucou\n")
}
