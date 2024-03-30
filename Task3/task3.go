package main

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"strconv"

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
			WHERE s.no_induk = $1 LIMIT 1`, noIndukInt)
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

	log.Println("Server started at http://localhost:8080")
	log.Fatal(http.ListenAndServe(":8080", nil))
}
