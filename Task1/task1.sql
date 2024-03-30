-- TASK 1
CREATE TABLE siswa (
    siswa_id SERIAL PRIMARY KEY,
    nama VARCHAR(100),
    no_induk INT,
    kota VARCHAR(100),
    tahun_masuk INT
);

CREATE TABLE mata_kuliah (
    mk_id SERIAL PRIMARY KEY,
    mk_nama VARCHAR(100),
    dosen_id INT,
    jumlah_sks INT
);

CREATE TABLE dosen (
    dosen_id SERIAL PRIMARY KEY,
    nama VARCHAR(100),
    kota VARCHAR(100)
);


