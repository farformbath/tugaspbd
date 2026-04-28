-- ============================================================
-- SISTEM RENTAL KENDARAAN
-- Kelompok 8 | Perancangan Basis Data
-- ============================================================
-- Anggota:
--   Dian Pranawan Ningtyas     / 2404140007
--   Kezia Gabriella Saroinsong / 4612422009
--   Nada Nafisah               / 2404140024
--   Alya Fuji Insani           / 2404140042
--   Irfan Fatkhurrizal         / 2404140090
-- ============================================================

SET SQL_MODE = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
SET time_zone = '+07:00';
SET FOREIGN_KEY_CHECKS = 0;

DROP DATABASE IF EXISTS rental_kendaraan;
CREATE DATABASE rental_kendaraan
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE rental_kendaraan;


-- ============================================================
--  DDL — DEFINISI TABEL
-- ============================================================

-- ------------------------------------------------------------
-- 1. CABANG
-- ------------------------------------------------------------
CREATE TABLE cabang (
    id_cabang       INT          NOT NULL AUTO_INCREMENT,
    nama_cabang     VARCHAR(100) NOT NULL,
    alamat          VARCHAR(255) NOT NULL,
    kota            VARCHAR(100) NOT NULL,
    nomor_telepon   VARCHAR(20)  NOT NULL,
    email           VARCHAR(100) NOT NULL,
    status_cabang   ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif',
    CONSTRAINT pk_cabang         PRIMARY KEY (id_cabang),
    CONSTRAINT uq_cabang_email   UNIQUE (email),
    CONSTRAINT uq_cabang_telepon UNIQUE (nomor_telepon)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ------------------------------------------------------------
-- 2. KATEGORI
-- ------------------------------------------------------------
CREATE TABLE kategori (
    id_kategori    INT          NOT NULL AUTO_INCREMENT,
    nama_kategori  VARCHAR(100) NOT NULL,
    tarif_per_hari DECIMAL(12,2) NOT NULL,
    tarif_weekend  DECIMAL(12,2) NOT NULL,
    deskripsi      TEXT,
    CONSTRAINT pk_kategori       PRIMARY KEY (id_kategori),
    CONSTRAINT chk_tarif_harian  CHECK (tarif_per_hari > 0),
    CONSTRAINT chk_tarif_weekend CHECK (tarif_weekend  > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ------------------------------------------------------------
-- 3. CUSTOMER
-- ------------------------------------------------------------
CREATE TABLE customer (
    id_customer     INT          NOT NULL AUTO_INCREMENT,
    nama_lengkap    VARCHAR(100) NOT NULL,
    nomor_ktp       VARCHAR(20)  NOT NULL,
    nomor_sim       VARCHAR(20)  NOT NULL,
    alamat          TEXT         NOT NULL,
    nomor_telepon   VARCHAR(15)  NOT NULL,
    email           VARCHAR(50)  NOT NULL,
    tanggal_daftar  DATE         NOT NULL,
    status_customer VARCHAR(20)  NOT NULL DEFAULT 'Aktif',
    CONSTRAINT pk_customer      PRIMARY KEY (id_customer),
    CONSTRAINT uq_customer_ktp  UNIQUE (nomor_ktp),
    CONSTRAINT uq_customer_sim  UNIQUE (nomor_sim)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ------------------------------------------------------------
-- 4. DRIVER
-- ------------------------------------------------------------
CREATE TABLE driver (
    id_driver     INT          NOT NULL AUTO_INCREMENT,
    nama_driver   VARCHAR(100) NOT NULL,
    nomor_sim     VARCHAR(20)  NOT NULL,
    jenis_sim     VARCHAR(10)  NOT NULL,
    nomor_telepon VARCHAR(15)  NOT NULL,
    status_driver VARCHAR(20)  NOT NULL DEFAULT 'Tersedia',
    id_cabang     INT          NOT NULL,
    CONSTRAINT pk_driver        PRIMARY KEY (id_driver),
    CONSTRAINT uq_driver_sim    UNIQUE (nomor_sim),
    CONSTRAINT fk_driver_cabang FOREIGN KEY (id_cabang)
        REFERENCES cabang (id_cabang)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ------------------------------------------------------------
-- 5. KENDARAAN
-- ------------------------------------------------------------
CREATE TABLE kendaraan (
    id_kendaraan        INT           NOT NULL AUTO_INCREMENT,
    nomor_polisi        VARCHAR(15)   NOT NULL,
    merk                VARCHAR(50)   NOT NULL,
    model               VARCHAR(50)   NOT NULL,
    tahun               YEAR          NOT NULL,
    warna               VARCHAR(30),
    jenis               ENUM('mobil','motor')                        NOT NULL,
    kapasitas_penumpang INT           NOT NULL,
    transmisi           ENUM('manual','matic')                       NOT NULL,
    status              ENUM('tersedia','disewa','maintenance')      NOT NULL DEFAULT 'tersedia',
    km_terakhir         INT           NOT NULL DEFAULT 0,
    id_kategori         INT,
    id_cabang_homebase  INT,
    created_at          TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,
    updated_at          TIMESTAMP     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT pk_kendaraan          PRIMARY KEY (id_kendaraan),
    CONSTRAINT uq_nomor_polisi       UNIQUE (nomor_polisi),
    CONSTRAINT chk_kapasitas         CHECK (kapasitas_penumpang > 0),
    CONSTRAINT chk_km                CHECK (km_terakhir >= 0),
    CONSTRAINT chk_tahun             CHECK (tahun BETWEEN 2000 AND 2030),
    CONSTRAINT fk_kendaraan_kategori FOREIGN KEY (id_kategori)
        REFERENCES kategori (id_kategori)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT fk_kendaraan_cabang   FOREIGN KEY (id_cabang_homebase)
        REFERENCES cabang (id_cabang)
        ON UPDATE CASCADE ON DELETE SET NULL,
    INDEX idx_status   (status),
    INDEX idx_kategori (id_kategori),
    INDEX idx_cabang   (id_cabang_homebase)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ------------------------------------------------------------
-- 6. SEWA
-- ------------------------------------------------------------
CREATE TABLE sewa (
    id_sewa         INT  NOT NULL AUTO_INCREMENT,
    id_customer     INT  NOT NULL,
    id_kendaraan    INT  NOT NULL,
    tanggal_mulai   DATE NOT NULL,
    tanggal_selesai DATE NOT NULL,
    CONSTRAINT pk_sewa           PRIMARY KEY (id_sewa),
    CONSTRAINT chk_tgl_selesai   CHECK (tanggal_selesai >= tanggal_mulai),
    CONSTRAINT fk_sewa_customer  FOREIGN KEY (id_customer)
        REFERENCES customer (id_customer)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_sewa_kendaraan FOREIGN KEY (id_kendaraan)
        REFERENCES kendaraan (id_kendaraan)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ------------------------------------------------------------
-- 7. SERVIS KENDARAAN
-- ------------------------------------------------------------
CREATE TABLE servis_kendaraan (
    id_servis      INT           NOT NULL AUTO_INCREMENT COMMENT 'PK – identitas unik tiap record servis',
    id_kendaraan   INT           NOT NULL                COMMENT 'FK → kendaraan.id_kendaraan',
    tanggal_servis DATE          NOT NULL                COMMENT 'Tanggal pelaksanaan servis',
    km_saat_servis INT UNSIGNED  NOT NULL                COMMENT 'Odometer kendaraan saat servis (km)',
    jenis_servis   VARCHAR(50)   NOT NULL                COMMENT 'Contoh: Rutin, Ganti Oli, Tune-up, Perbaikan Ban',
    biaya_servis   DECIMAL(12,2) NOT NULL DEFAULT 0      COMMENT 'Total biaya servis (Rp)',
    nama_bengkel   VARCHAR(100)  NOT NULL                COMMENT 'Nama bengkel/tempat servis',
    keterangan     TEXT                                  COMMENT 'Catatan tambahan / detail pekerjaan',
    CONSTRAINT pk_servis         PRIMARY KEY (id_servis),
    CONSTRAINT fk_servis_kend    FOREIGN KEY (id_kendaraan)
        REFERENCES kendaraan (id_kendaraan)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  COMMENT='Riwayat servis / perawatan setiap kendaraan';

-- ------------------------------------------------------------
-- 8. PEMERIKSAAN PENGEMBALIAN
-- ------------------------------------------------------------
CREATE TABLE pemeriksaan_pengembalian (
    id_pemeriksaan           INT           NOT NULL AUTO_INCREMENT COMMENT 'PK – identitas unik tiap pemeriksaan',
    id_sewa                  INT           NOT NULL                COMMENT 'FK → sewa.id_sewa',
    tanggal_pemeriksaan      DATE          NOT NULL                COMMENT 'Tanggal kendaraan dikembalikan & diperiksa',
    kondisi_kendaraan        ENUM('Baik','Cukup','Rusak Ringan','Rusak Berat')
                                           NOT NULL DEFAULT 'Baik' COMMENT 'Kondisi umum kendaraan saat kembali',
    ada_kerusakan            TINYINT(1)    NOT NULL DEFAULT 0      COMMENT 'Boolean: 1 = ada kerusakan, 0 = tidak',
    deskripsi_kerusakan      TEXT                                  COMMENT 'Detail kerusakan (diisi jika ada_kerusakan = 1)',
    estimasi_biaya_perbaikan DECIMAL(12,2) NOT NULL DEFAULT 0      COMMENT 'Estimasi biaya perbaikan (Rp); 0 jika tidak rusak',
    ditanggung_asuransi      TINYINT(1)    NOT NULL DEFAULT 0      COMMENT 'Boolean: 1 = ditanggung asuransi, 0 = tidak',
    CONSTRAINT pk_pemeriksaan  PRIMARY KEY (id_pemeriksaan),
    CONSTRAINT uq_sewa_periksa UNIQUE (id_sewa),                   -- 1 pemeriksaan per transaksi sewa
    CONSTRAINT fk_periksa_sewa FOREIGN KEY (id_sewa)
        REFERENCES sewa (id_sewa)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  COMMENT='Hasil pemeriksaan kondisi kendaraan saat dikembalikan penyewa';


-- ------------------------------------------------------------
-- 9. SEWA KENDARAAN
-- ------------------------------------------------------------
CREATE TABLE sewa_kendaraan (
    id_sewa         INT           NOT NULL AUTO_INCREMENT,
    nama_pelanggan  VARCHAR(100)  NOT NULL,
    no_hp           VARCHAR(15),
    id_kendaraan    INT           NOT NULL,
    tanggal_sewa    DATE          NOT NULL,
    tanggal_kembali DATE          NOT NULL,
    harga_per_hari  DECIMAL(10,2) NOT NULL,
    lama_hari       INT           NOT NULL,
    total_harga     DECIMAL(12,2) NOT NULL,
    CONSTRAINT pk_sewa_kendaraan  PRIMARY KEY (id_sewa),
    CONSTRAINT chk_tgl_kembali    CHECK (tanggal_kembali >= tanggal_sewa),
    CONSTRAINT chk_lama_hari      CHECK (lama_hari > 0),
    CONSTRAINT fk_sewakend_kend   FOREIGN KEY (id_kendaraan)
        REFERENCES kendaraan (id_kendaraan)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- ============================================================
--  DDL — TRIGGER
-- ============================================================

DELIMITER $$

-- Trigger 1: Kendaraan berstatus maintenance tidak boleh diubah jadi disewa
CREATE TRIGGER trg_kendaraan_no_rent_if_maintenance
BEFORE UPDATE ON kendaraan
FOR EACH ROW
BEGIN
    IF OLD.status = 'maintenance' AND NEW.status = 'disewa' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Kendaraan sedang maintenance, tidak boleh disewa';
    END IF;
END$$

-- Trigger 2: KM kendaraan tidak boleh turun
CREATE TRIGGER trg_km_tidak_boleh_turun
BEFORE UPDATE ON kendaraan
FOR EACH ROW
BEGIN
    IF NEW.km_terakhir < OLD.km_terakhir THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'KM tidak boleh lebih kecil dari sebelumnya';
    END IF;
END$$

DELIMITER ;


-- ============================================================
--  DDL — INDEX
-- ============================================================

-- Cabang
CREATE INDEX idx_cabang_kota    ON cabang (kota);
CREATE INDEX idx_cabang_status  ON cabang (status_cabang);

-- Kategori
CREATE INDEX idx_kategori_tarif ON kategori (tarif_per_hari);

-- Customer
CREATE INDEX idx_customer_nama   ON customer (nama_lengkap);
CREATE INDEX idx_customer_status ON customer (status_customer);

-- Driver
CREATE INDEX idx_driver_status   ON driver (status_driver);
CREATE INDEX idx_driver_cabang   ON driver (id_cabang, status_driver);

-- Kendaraan
CREATE INDEX idx_kendaraan_merk  ON kendaraan (merk);

-- Sewa
CREATE INDEX idx_sewa_customer   ON sewa (id_customer);
CREATE INDEX idx_sewa_kendaraan  ON sewa (id_kendaraan);
CREATE INDEX idx_sewa_tanggal    ON sewa (tanggal_mulai, tanggal_selesai);

-- Servis Kendaraan
CREATE INDEX idx_servis_kendaraan ON servis_kendaraan (id_kendaraan);
CREATE INDEX idx_servis_tanggal   ON servis_kendaraan (tanggal_servis);
CREATE INDEX idx_servis_jenis     ON servis_kendaraan (jenis_servis);

-- Pemeriksaan Pengembalian
CREATE INDEX idx_periksa_tanggal   ON pemeriksaan_pengembalian (tanggal_pemeriksaan);
CREATE INDEX idx_periksa_kerusakan ON pemeriksaan_pengembalian (ada_kerusakan);


-- ============================================================
--  DML — INSERT DATA
-- ============================================================

-- ------------------------------------------------------------
-- 1. CABANG
-- ------------------------------------------------------------
INSERT INTO cabang (nama_cabang, alamat, kota, nomor_telepon, email, status_cabang) VALUES
('Cabang Semarang Pusat',   'Jl. Pemuda No. 1',         'Semarang',   '024-1234001', 'semarang.pusat@rental.id',   'aktif'),
('Cabang Semarang Selatan', 'Jl. Setiabudi No. 88',     'Semarang',   '024-1234002', 'semarang.selatan@rental.id', 'aktif'),
('Cabang Yogyakarta',       'Jl. Malioboro No. 10',     'Yogyakarta', '0274-234001', 'yogyakarta@rental.id',       'aktif'),
('Cabang Solo',             'Jl. Slamet Riyadi No. 55', 'Solo',       '0271-234001', 'solo@rental.id',             'aktif'),
('Cabang Surabaya',         'Jl. Darmo No. 200',        'Surabaya',   '031-2340010', 'surabaya@rental.id',         'aktif'),
('Cabang Semarang Utara',   'Jl. Kaligawe No. 12',      'Semarang',   '024-1234003', 'semarang.utara@rental.id',   'nonaktif');

-- ------------------------------------------------------------
-- 2. KATEGORI
-- ------------------------------------------------------------
INSERT INTO kategori (nama_kategori, tarif_per_hari, tarif_weekend, deskripsi) VALUES
('Motor Matic',  75000.00,    90000.00, 'Sepeda motor matic kapasitas ≤150cc'),
('Motor Sport', 100000.00,   120000.00, 'Sepeda motor sport kapasitas >150cc'),
('City Car',    250000.00,   300000.00, 'Mobil kecil untuk dalam kota, 4-5 penumpang'),
('MPV',         400000.00,   480000.00, 'Kendaraan keluarga, 6-8 penumpang'),
('SUV',         550000.00,   660000.00, 'Kendaraan serba guna, 5-7 penumpang'),
('Luxury',      900000.00,  1100000.00, 'Kendaraan premium / executive');

-- ------------------------------------------------------------
-- 3. CUSTOMER
-- ------------------------------------------------------------
INSERT INTO customer (id_customer, nama_lengkap, nomor_ktp, nomor_sim, alamat, nomor_telepon, email, tanggal_daftar, status_customer) VALUES
(1, 'Budi Santoso', '3301012345670001', 'SIM-9901', 'Jl. Gajah Mada No. 10, Semarang', '087656765476', 'budisantoso@gmail.com', '2026-04-08', 'Aktif'),
(2, 'Tasya Putri',  '3301019876540002', 'SIM-9902', 'Jl. Ahmad Yani No. 5, Semarang',  '08432456754',  'tasyaputri@gmail.com',  '2026-04-14', 'Aktif'),
(3, 'Roni Saputra', '3301013456780003', 'SIM-9903', 'Jl. Diponegoro No. 3, Semarang',  '08123456789',  'ronisaputra@gmail.com', '2026-04-15', 'Aktif'),
(4, 'Dewi Lestari', '3301014567890004', 'SIM-9904', 'Jl. Pemuda No. 7, Semarang',      '08234567890',  'dewilestari@gmail.com', '2026-04-16', 'Aktif'),
(5, 'Eko Prasetyo', '3301015678900005', 'SIM-9905', 'Jl. Cendrawasih No. 5, Semarang', '08345678901',  'ekoprasetyo@gmail.com', '2026-04-17', 'Aktif');

-- ------------------------------------------------------------
-- 4. DRIVER
-- ------------------------------------------------------------
INSERT INTO driver (id_driver, nama_driver, nomor_sim, jenis_sim, nomor_telepon, status_driver, id_cabang) VALUES
(1, 'Andi Saputra',  'DRV-001', 'A',  '08156789012', 'Tersedia',        1),
(2, 'Satria',        'DRV-002', 'B1', '08167890123', 'Tersedia',        1),
(3, 'Rizky Pratama', 'DRV-003', 'A',  '08178901234', 'Sedang Bertugas', 2);

-- ------------------------------------------------------------
-- 5. KENDARAAN
-- ------------------------------------------------------------
INSERT INTO kendaraan (id_kendaraan, nomor_polisi, merk, model, tahun, warna, jenis, kapasitas_penumpang, transmisi, status, km_terakhir, id_kategori, id_cabang_homebase) VALUES
(1, 'H 1234 AB', 'Toyota',     'Avanza',  2022, 'Hitam',  'mobil', 7, 'manual',   'tersedia', 15000, 4, 2),
(2, 'H 5678 CD', 'Honda',      'Brio',    2023, 'Putih',  'mobil', 5, 'matic',    'tersedia',  8000, 3, 1),
(3, 'H 9012 EF', 'Mitsubishi', 'Xpander', 2022, 'Silver', 'mobil', 7, 'matic',    'tersedia', 30000, 4, 2),
(4, 'H 3456 GH', 'Suzuki',     'Ertiga',  2021, 'Abu-abu','mobil', 7, 'matic',    'tersedia', 22000, 4, 3),
(5, 'H 7890 IJ', 'Daihatsu',   'Xenia',   2020, 'Merah',  'mobil', 7, 'manual',   'tersedia', 40000, 4, 4),
(6, 'H1111AA',   'Honda',      'Beat',    2023, 'Hitam',  'motor', 2, 'matic',    'tersedia',  3000, 1, 1),
(7, 'H2222BB',   'Yamaha',     'Vixion',  2022, 'Merah',  'motor', 2, 'manual',   'tersedia',  8000, 2, 2),
(8, 'H3333CC',   'Honda',      'Brio',    2023, 'Putih',  'mobil', 5, 'matic',    'tersedia',  5000, 3, 1),
(9, 'H4444DD',   'Toyota',     'Avanza',  2022, 'Hitam',  'mobil', 7, 'manual',   'disewa',   15000, 4, 2),
(10,'H5555EE',   'Toyota',     'Innova',  2020, 'Silver', 'mobil', 7, 'manual',   'maintenance',45000,4, 3);

-- ------------------------------------------------------------
-- 6. SEWA
-- ------------------------------------------------------------
INSERT INTO sewa (id_sewa, id_customer, id_kendaraan, tanggal_mulai, tanggal_selesai) VALUES
(1, 1, 1, '2025-04-01', '2025-04-03'),
(2, 2, 2, '2025-04-05', '2025-04-07'),
(3, 3, 3, '2025-04-10', '2025-04-15'),
(4, 4, 4, '2025-04-12', '2025-04-14'),
(5, 5, 5, '2025-04-18', '2025-04-20'),
(6, 1, 2, '2025-04-22', '2025-04-24'),
(7, 2, 3, '2025-04-25', '2025-04-28');

-- ------------------------------------------------------------
-- 7. SERVIS KENDARAAN
-- ------------------------------------------------------------
INSERT INTO servis_kendaraan (id_kendaraan, tanggal_servis, km_saat_servis, jenis_servis, biaya_servis, nama_bengkel, keterangan) VALUES
-- Kendaraan 1 – Toyota Avanza
(1, '2025-01-10', 15000, 'Ganti Oli',     150000, 'Bengkel Maju Jaya',      'Ganti oli mesin SAE 10W-40'),
(1, '2025-02-20', 18500, 'Rutin',         350000, 'Bengkel Maju Jaya',      'Servis rutin 20.000 km: busi, filter udara'),
(1, '2025-03-30', 21000, 'Perbaikan Ban', 200000, 'Tambal Ban Sejahtera',   'Ganti ban belakang kanan karena bocor besar'),
-- Kendaraan 2 – Honda Brio
(2, '2025-01-15',  8000, 'Ganti Oli',     130000, 'Honda AHASS Semarang',   'Ganti oli + filter oli'),
(2, '2025-03-05', 12000, 'Tune-up',       400000, 'Honda AHASS Semarang',   'Tune-up lengkap, bersihkan injektor'),
(2, '2025-04-01', 14500, 'Ganti Oli',     130000, 'Honda AHASS Semarang',   'Ganti oli rutin'),
-- Kendaraan 3 – Mitsubishi Xpander
(3, '2025-01-20', 30000, 'Rutin',         500000, 'Mitsubishi Authorized',  'Servis 30.000 km: kampas rem, filter'),
(3, '2025-03-15', 34000, 'Perbaikan AC',  750000, 'Bengkel AC Dingin Jaya', 'Isi freon + bersihkan evaporator'),
-- Kendaraan 4 – Suzuki Ertiga
(4, '2025-02-10', 22000, 'Ganti Oli',     145000, 'Suzuki Service Center',  'Ganti oli dan saringan oli'),
(4, '2025-03-20', 25000, 'Rutin',         420000, 'Suzuki Service Center',  'Servis 25.000 km rutin'),
(4, '2025-04-10', 27500, 'Perbaikan',     300000, 'Bengkel Karya Teknik',   'Ganti wiper depan + belakang, lampu sein'),
-- Kendaraan 5 – Daihatsu Xenia
(5, '2025-01-25', 40000, 'Ganti Oli',     140000, 'Daihatsu Service Pusat', 'Ganti oli mesin'),
(5, '2025-02-28', 43000, 'Tune-up',       380000, 'Daihatsu Service Pusat', 'Tune-up + busi baru'),
(5, '2025-04-05', 46000, 'Perbaikan Rem', 550000, 'Bengkel Rem Handal',     'Ganti kampas rem depan & belakang'),
(5, '2025-04-20', 47500, 'Ganti Oli',     140000, 'Daihatsu Service Pusat', 'Ganti oli rutin');

-- ------------------------------------------------------------
-- 8. PEMERIKSAAN PENGEMBALIAN
-- ------------------------------------------------------------
INSERT INTO pemeriksaan_pengembalian (id_sewa, tanggal_pemeriksaan, kondisi_kendaraan, ada_kerusakan, deskripsi_kerusakan, estimasi_biaya_perbaikan, ditanggung_asuransi) VALUES
(1, '2025-04-03', 'Baik',         0, NULL,                                                                              0,       0),
(2, '2025-04-07', 'Rusak Ringan', 1, 'Lecet bemper depan kiri akibat gesekan parkir',                            350000,       0),
(3, '2025-04-15', 'Cukup',        0, 'Interior sedikit kotor, sudah dibersihkan',                                      0,       0),
(4, '2025-04-14', 'Rusak Ringan', 1, 'Spion kanan patah karena tersenggol kendaraan lain',                       200000,       1),
(5, '2025-04-20', 'Rusak Berat',  1, 'Bodi kiri penyok, lampu depan kiri pecah akibat kecelakaan minor',       2500000,       1),
(6, '2025-04-24', 'Baik',         0, NULL,                                                                              0,       0),
(7, '2025-04-28', 'Cukup',        1, 'Ban belakang kanan kempes, sudah ditambal sementara oleh penyewa',         150000,       0);


-- Sewa Kendaraan
CREATE INDEX idx_sewakend_kendaraan ON sewa_kendaraan (id_kendaraan);
CREATE INDEX idx_sewakend_tanggal   ON sewa_kendaraan (tanggal_sewa, tanggal_kembali);

SET FOREIGN_KEY_CHECKS = 1;

-- ------------------------------------------------------------
-- 9. SEWA KENDARAAN
-- ------------------------------------------------------------
INSERT INTO sewa_kendaraan (nama_pelanggan, no_hp, id_kendaraan, tanggal_sewa, tanggal_kembali, harga_per_hari, lama_hari, total_harga) VALUES
('Andi',  '081234567890', 1, '2026-04-01', '2026-04-03', 200000, 2, 400000),
('Budi',  '082345678901', 2, '2026-04-02', '2026-04-05', 250000, 3, 750000),
('Citra', '083456789012', 3, '2026-04-03', '2026-04-04', 300000, 1, 300000);


-- ============================================================
--  END OF FILE
-- ============================================================
