package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"strings"
)

func romanToDecimal(roman string) int {
	angkaRomawi := map[string]int{
		"I": 1,
		"V": 5,
		"X": 10,
		"L": 50,
		"C": 100,
		"D": 500,
		"M": 1000,
	}

	total := 0
	prevValue := 0
	for i := len(roman) - 1; i >= 0; i-- {
		value := angkaRomawi[string(roman[i])]
		if value < prevValue {
			total -= value
		} else {
			total += value
		}
		prevValue = value
	}
	return total
}

func main() {
	fileInput := "angka_romawi.txt"
	content, err := ioutil.ReadFile(fileInput)
	if err != nil {
		log.Fatal("Error membaca file input:", err)
	}

	lines := strings.Split(string(content), "\n")

	fileOutput := "nilai_numerik.txt"
	output := []string{}

	for _, line := range lines {
		if line == "" {
			continue
		}
		nilaiDesimal := romanToDecimal(line)
		barisanTulisan := fmt.Sprintf("%-10s: %d\n", strings.TrimSpace(line), nilaiDesimal)
		output = append(output, barisanTulisan)
	}

	err = ioutil.WriteFile(fileOutput, []byte(strings.Join(output, "")), 0644)
	if err != nil {
		log.Fatal("Error menulis ke file output:", err)
	}

	fmt.Println("Konversi selesai. Hasil ditulis ke", fileOutput)
}
