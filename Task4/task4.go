package main

import (
	"fmt"
	"time"
)

func main() {
	ch := make(chan string)
	go cetakAngka(ch)
	go cetakHuruf(ch)
	for i := 0; i < 20; i++ {
		fmt.Println(<-ch)
	}

	fmt.Println("Goroutine utama keluar...")
}

func cetakAngka(ch chan<- string) {
	for i := 1; i <= 10; i++ {
		ch <- fmt.Sprintf("Angka: %d", i)
		time.Sleep(200 * time.Millisecond)
	}
}

func cetakHuruf(ch chan<- string) {
	for char := 'A'; char <= 'J'; char++ {
		ch <- fmt.Sprintf("Huruf: %c", char)
		time.Sleep(300 * time.Millisecond)
	}
}
