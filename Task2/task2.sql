-- TASK 1
CREATE TABLE siswa (
    siswa_id INT PRIMARY KEY,
    nama VARCHAR(100),
    no_induk INT(10),
    kota VARCHAR(100),
    tahun_masuk INT
);

CREATE TABLE mata_kuliah (
    mk_id INT PRIMARY KEY,
    mk_nama VARCHAR(100),
    dosen_id INT,
    jumlah_sks INT
);

CREATE TABLE dosen (
    dosen_id INT PRIMARY KEY,
    nama VARCHAR(100),
    kota VARCHAR(100)
);

-- TASK 2
CREATE TABLE nilai_UTS (
    nilai_id INT PRIMARY KEY,
    siswa_id INT,
    mk_id INT,
    nilai_uts FLOAT,
    FOREIGN KEY (siswa_id) REFERENCES siswa(siswa_id),
    FOREIGN KEY (mk_id) REFERENCES mata_kuliah(mk_id)
);

CREATE TABLE nilai_UAS (
    nilai_id INT PRIMARY KEY,
    siswa_id INT,
    mk_id INT,
    nilai_uas FLOAT,
    FOREIGN KEY (siswa_id) REFERENCES siswa(siswa_id),
    FOREIGN KEY (mk_id) REFERENCES mata_kuliah(mk_id)
);