/*
 Navicat Premium Data Transfer

 Source Server         : PGSQL
 Source Server Type    : PostgreSQL
 Source Server Version : 90325
 Source Host           : localhost:5432
 Source Catalog        : db_akademik
 Source Schema         : public

 Target Server Type    : PostgreSQL
 Target Server Version : 90325
 File Encoding         : 65001

 Date: 30/03/2024 14:18:57
*/


-- ----------------------------
-- Sequence structure for dosen_dosen_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."dosen_dosen_id_seq";
CREATE SEQUENCE "public"."dosen_dosen_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for mata_kuliah_mk_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."mata_kuliah_mk_id_seq";
CREATE SEQUENCE "public"."mata_kuliah_mk_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for nilai_uas_nilai_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."nilai_uas_nilai_id_seq";
CREATE SEQUENCE "public"."nilai_uas_nilai_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for nilai_uts_nilai_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."nilai_uts_nilai_id_seq";
CREATE SEQUENCE "public"."nilai_uts_nilai_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for siswa_siswa_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."siswa_siswa_id_seq";
CREATE SEQUENCE "public"."siswa_siswa_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Table structure for dosen
-- ----------------------------
DROP TABLE IF EXISTS "public"."dosen";
CREATE TABLE "public"."dosen" (
  "dosen_id" int4 NOT NULL DEFAULT nextval('dosen_dosen_id_seq'::regclass),
  "nama" varchar(100) COLLATE "pg_catalog"."default",
  "kota" varchar(100) COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Records of dosen
-- ----------------------------
INSERT INTO "public"."dosen" VALUES (1, 'Dr. Ahmad', 'Jakarta');
INSERT INTO "public"."dosen" VALUES (2, 'Dr. Budi', 'Bandung');
INSERT INTO "public"."dosen" VALUES (3, 'Dr. Cici', 'Surabaya');

-- ----------------------------
-- Table structure for mata_kuliah
-- ----------------------------
DROP TABLE IF EXISTS "public"."mata_kuliah";
CREATE TABLE "public"."mata_kuliah" (
  "mk_id" int4 NOT NULL DEFAULT nextval('mata_kuliah_mk_id_seq'::regclass),
  "mk_nama" varchar(100) COLLATE "pg_catalog"."default",
  "dosen_id" int4,
  "jumlah_sks" int4
)
;

-- ----------------------------
-- Records of mata_kuliah
-- ----------------------------
INSERT INTO "public"."mata_kuliah" VALUES (1, 'Matematika', 1, 3);
INSERT INTO "public"."mata_kuliah" VALUES (2, 'Fisika', 2, 4);
INSERT INTO "public"."mata_kuliah" VALUES (3, 'Bahasa Inggris', 3, 2);

-- ----------------------------
-- Table structure for nilai_uas
-- ----------------------------
DROP TABLE IF EXISTS "public"."nilai_uas";
CREATE TABLE "public"."nilai_uas" (
  "nilai_id" int4 NOT NULL DEFAULT nextval('nilai_uas_nilai_id_seq'::regclass),
  "siswa_id" int4,
  "mk_id" int4,
  "nilai_uas" float8
)
;

-- ----------------------------
-- Records of nilai_uas
-- ----------------------------
INSERT INTO "public"."nilai_uas" VALUES (1, 1, 1, 85);
INSERT INTO "public"."nilai_uas" VALUES (2, 2, 2, 78.5);
INSERT INTO "public"."nilai_uas" VALUES (3, 3, 3, 90);
INSERT INTO "public"."nilai_uas" VALUES (4, 1, 2, 75);
INSERT INTO "public"."nilai_uas" VALUES (5, 2, 3, 85);
INSERT INTO "public"."nilai_uas" VALUES (6, 3, 1, 82);

-- ----------------------------
-- Table structure for nilai_uts
-- ----------------------------
DROP TABLE IF EXISTS "public"."nilai_uts";
CREATE TABLE "public"."nilai_uts" (
  "nilai_id" int4 NOT NULL DEFAULT nextval('nilai_uts_nilai_id_seq'::regclass),
  "siswa_id" int4,
  "mk_id" int4,
  "nilai_uts" float8
)
;

-- ----------------------------
-- Records of nilai_uts
-- ----------------------------
INSERT INTO "public"."nilai_uts" VALUES (1, 1, 1, 80.5);
INSERT INTO "public"."nilai_uts" VALUES (2, 2, 2, 75);
INSERT INTO "public"."nilai_uts" VALUES (3, 3, 3, 85.25);
INSERT INTO "public"."nilai_uts" VALUES (4, 1, 2, 70);
INSERT INTO "public"."nilai_uts" VALUES (5, 2, 3, 82.5);
INSERT INTO "public"."nilai_uts" VALUES (6, 3, 1, 78);

-- ----------------------------
-- Table structure for siswa
-- ----------------------------
DROP TABLE IF EXISTS "public"."siswa";
CREATE TABLE "public"."siswa" (
  "siswa_id" int4 NOT NULL DEFAULT nextval('siswa_siswa_id_seq'::regclass),
  "nama" varchar(100) COLLATE "pg_catalog"."default",
  "no_induk" int4,
  "kota" varchar(100) COLLATE "pg_catalog"."default",
  "tahun_masuk" int4
)
;

-- ----------------------------
-- Records of siswa
-- ----------------------------
INSERT INTO "public"."siswa" VALUES (1, 'Ahmad Dewa Fitrah', 1001, 'Jakarta', 2020);
INSERT INTO "public"."siswa" VALUES (2, 'Rava Julian Airlangga', 1002, 'Bandung', 2019);
INSERT INTO "public"."siswa" VALUES (3, 'Safila Cahaya Restia', 1003, 'Surabaya', 2021);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."dosen_dosen_id_seq"
OWNED BY "public"."dosen"."dosen_id";
SELECT setval('"public"."dosen_dosen_id_seq"', 3, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."mata_kuliah_mk_id_seq"
OWNED BY "public"."mata_kuliah"."mk_id";
SELECT setval('"public"."mata_kuliah_mk_id_seq"', 3, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."nilai_uas_nilai_id_seq"
OWNED BY "public"."nilai_uas"."nilai_id";
SELECT setval('"public"."nilai_uas_nilai_id_seq"', 6, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."nilai_uts_nilai_id_seq"
OWNED BY "public"."nilai_uts"."nilai_id";
SELECT setval('"public"."nilai_uts_nilai_id_seq"', 6, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."siswa_siswa_id_seq"
OWNED BY "public"."siswa"."siswa_id";
SELECT setval('"public"."siswa_siswa_id_seq"', 3, true);

-- ----------------------------
-- Primary Key structure for table dosen
-- ----------------------------
ALTER TABLE "public"."dosen" ADD CONSTRAINT "dosen_pkey" PRIMARY KEY ("dosen_id");

-- ----------------------------
-- Primary Key structure for table mata_kuliah
-- ----------------------------
ALTER TABLE "public"."mata_kuliah" ADD CONSTRAINT "mata_kuliah_pkey" PRIMARY KEY ("mk_id");

-- ----------------------------
-- Primary Key structure for table nilai_uas
-- ----------------------------
ALTER TABLE "public"."nilai_uas" ADD CONSTRAINT "nilai_uas_pkey" PRIMARY KEY ("nilai_id");

-- ----------------------------
-- Primary Key structure for table nilai_uts
-- ----------------------------
ALTER TABLE "public"."nilai_uts" ADD CONSTRAINT "nilai_uts_pkey" PRIMARY KEY ("nilai_id");

-- ----------------------------
-- Primary Key structure for table siswa
-- ----------------------------
ALTER TABLE "public"."siswa" ADD CONSTRAINT "siswa_pkey" PRIMARY KEY ("siswa_id");

-- ----------------------------
-- Foreign Keys structure for table nilai_uas
-- ----------------------------
ALTER TABLE "public"."nilai_uas" ADD CONSTRAINT "nilai_uas_mk_id_fkey" FOREIGN KEY ("mk_id") REFERENCES "public"."mata_kuliah" ("mk_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."nilai_uas" ADD CONSTRAINT "nilai_uas_siswa_id_fkey" FOREIGN KEY ("siswa_id") REFERENCES "public"."siswa" ("siswa_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table nilai_uts
-- ----------------------------
ALTER TABLE "public"."nilai_uts" ADD CONSTRAINT "nilai_uts_mk_id_fkey" FOREIGN KEY ("mk_id") REFERENCES "public"."mata_kuliah" ("mk_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."nilai_uts" ADD CONSTRAINT "nilai_uts_siswa_id_fkey" FOREIGN KEY ("siswa_id") REFERENCES "public"."siswa" ("siswa_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
