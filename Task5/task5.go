package main

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
	"strconv"
	"sync"
	"time"

	_ "github.com/lib/pq"
)

type Mahasiswa struct {
	Nama       string             `json:"nama"`
	MataKuliah []MataKuliahDetail `json:"mata_kuliah"`
}

type MataKuliahDetail struct {
	Nama      string  `json:"nama"`
	Dosen     string  `json:"dosen"`
	JumlahSKS int     `json:"jumlah_sks"`
	NilaiUTS  float64 `json:"nilai_uts"`
	NilaiUAS  float64 `json:"nilai_uas"`
}

var (
	stopConcChan = make(chan struct{})
	wg           sync.WaitGroup
)

func main() {

	db, err := sql.Open("postgres", "postgres://postgres:123456@localhost:5432/db_akademik?sslmode=disable")
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	http.HandleFunc("/datamahasiswa", func(w http.ResponseWriter, r *http.Request) {
		noInduk := r.URL.Query().Get("no_induk")

		noIndukInt, err := strconv.Atoi(noInduk)
		if err != nil {
			http.Error(w, "Invalid no_induk", http.StatusBadRequest)
			return
		}

		rows, err := db.Query(`
			SELECT s.nama, mk.mk_nama, d.nama, mk.jumlah_sks, nu.nilai_uts, nau.nilai_uas
			FROM siswa s
			JOIN nilai_UTS nu ON s.siswa_id = nu.siswa_id
			JOIN nilai_UAS nau ON s.siswa_id = nau.siswa_id AND nu.mk_id = nau.mk_id
			JOIN mata_kuliah mk ON nu.mk_id = mk.mk_id
			JOIN dosen d ON mk.dosen_id = d.dosen_id
			WHERE s.no_induk = $1`, noIndukInt)
		if err != nil {
			log.Println(err)
			http.Error(w, "Internal Server Error", http.StatusInternalServerError)
			return
		}
		defer rows.Close()

		var mahasiswa Mahasiswa
		mataKuliahMap := make(map[string]MataKuliahDetail)
		for rows.Next() {
			var nama, mataKuliah, dosen string
			var jumlahSKS int
			var nilaiUTS, nilaiUAS float64
			err := rows.Scan(&nama, &mataKuliah, &dosen, &jumlahSKS, &nilaiUTS, &nilaiUAS)
			if err != nil {
				log.Println(err)
				http.Error(w, "Internal Server Error", http.StatusInternalServerError)
				return
			}
			if mahasiswa.Nama == "" {
				mahasiswa.Nama = nama
			}
			if _, ok := mataKuliahMap[mataKuliah]; !ok {
				mataKuliahMap[mataKuliah] = MataKuliahDetail{
					Nama:      mataKuliah,
					Dosen:     dosen,
					JumlahSKS: jumlahSKS,
					NilaiUTS:  nilaiUTS,
					NilaiUAS:  nilaiUAS,
				}
			}
		}
		for _, value := range mataKuliahMap {
			mahasiswa.MataKuliah = append(mahasiswa.MataKuliah, value)
		}

		responseData, err := json.Marshal(mahasiswa)
		if err != nil {
			log.Println(err)
			http.Error(w, "Internal Server Error", http.StatusInternalServerError)
			return
		}

		w.Header().Set("Content-Type", "application/json")

		fmt.Fprintf(w, string(responseData))
	})

	http.HandleFunc("/startconcurrency", func(w http.ResponseWriter, r *http.Request) {
		wg.Add(1)
		ch := make(chan string)
		go cetakAngka(ch)
		go cetakHuruf(ch)
		go func() {
			defer wg.Done()
			for {
				select {
				case msg := <-ch:
					fmt.Println(msg)
				case <-stopConcChan:
					return
				}
			}
		}()

		fmt.Fprintf(w, "Concurrency process started.")
	})

	http.HandleFunc("/stopconcurrency", func(w http.ResponseWriter, r *http.Request) {
		close(stopConcChan)
		wg.Wait()
		fmt.Fprintf(w, "Concurrency process stopped.")
	})

	http.HandleFunc("/exitprogram", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "Exiting program...")
		go func() {
			time.Sleep(1 * time.Second)
			os.Exit(0)
		}()
	})

	log.Println("Server started at http://localhost:8080")
	log.Fatal(http.ListenAndServe(":8080", nil))
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
