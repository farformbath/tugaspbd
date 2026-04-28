CREATE TABLE IF NOT EXISTS kendaraan (
    id_kendaraan    INT             NOT NULL AUTO_INCREMENT,
    nomor_polisi    VARCHAR(15)     NOT NULL,
    merk            VARCHAR(50)     NOT NULL,
    model           VARCHAR(50)     NOT NULL,
    PRIMARY KEY (id_kendaraan)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS sewa (
    id_sewa         INT             NOT NULL AUTO_INCREMENT,
    id_customer     INT             NOT NULL,
    id_kendaraan    INT             NOT NULL,
    tanggal_mulai   DATE            NOT NULL,
    tanggal_selesai DATE            NOT NULL,
    PRIMARY KEY (id_sewa)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Data minimal agar INSERT sample tidak error FK
INSERT IGNORE INTO kendaraan (id_kendaraan, nomor_polisi, merk, model) VALUES
(1, 'H 1234 AB', 'Toyota',  'Avanza'),
(2, 'H 5678 CD', 'Honda',   'Brio'),
(3, 'H 9012 EF', 'Mitsubishi', 'Xpander'),
(4, 'H 3456 GH', 'Suzuki',  'Ertiga'),
(5, 'H 7890 IJ', 'Daihatsu','Xenia');

INSERT IGNORE INTO sewa (id_sewa, id_customer, id_kendaraan, tanggal_mulai, tanggal_selesai) VALUES
(1, 1, 1, '2025-04-01', '2025-04-03'),
(2, 2, 2, '2025-04-05', '2025-04-07'),
(3, 3, 3, '2025-04-10', '2025-04-15'),
(4, 4, 4, '2025-04-12', '2025-04-14'),
(5, 5, 5, '2025-04-18', '2025-04-20'),
(6, 1, 2, '2025-04-22', '2025-04-24'),
(7, 2, 3, '2025-04-25', '2025-04-28');


-- ============================================================
-- TABEL 1: servis_kendaraan
-- ============================================================

DROP TABLE IF EXISTS servis_kendaraan;

CREATE TABLE servis_kendaraan (
    id_servis       INT             NOT NULL AUTO_INCREMENT  COMMENT 'PK – identitas unik tiap record servis',
    id_kendaraan    INT             NOT NULL                 COMMENT 'FK → kendaraan.id_kendaraan',
    tanggal_servis  DATE            NOT NULL                 COMMENT 'Tanggal pelaksanaan servis',
    km_saat_servis  INT UNSIGNED    NOT NULL                 COMMENT 'Odometer kendaraan saat servis (km)',
    jenis_servis    VARCHAR(50)     NOT NULL                 COMMENT 'Contoh: Rutin, Ganti Oli, Tune-up, Perbaikan Ban',
    biaya_servis    DECIMAL(12,2)   NOT NULL DEFAULT 0       COMMENT 'Total biaya servis (Rp)',
    nama_bengkel    VARCHAR(100)    NOT NULL                 COMMENT 'Nama bengkel/tempat servis',
    keterangan      TEXT                                     COMMENT 'Catatan tambahan / detail pekerjaan',

    PRIMARY KEY (id_servis),

    -- FK
    CONSTRAINT fk_servis_kendaraan
        FOREIGN KEY (id_kendaraan)
        REFERENCES kendaraan (id_kendaraan)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    -- INDEX
    INDEX idx_servis_kendaraan  (id_kendaraan),
    INDEX idx_servis_tanggal    (tanggal_servis),
    INDEX idx_servis_jenis      (jenis_servis)

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  COMMENT='Riwayat servis / perawatan setiap kendaraan';


-- ------------------------------------------------------------
-- INSERT DATA SAMPLE – servis_kendaraan (15 baris)
-- ------------------------------------------------------------
INSERT INTO servis_kendaraan
    (id_kendaraan, tanggal_servis, km_saat_servis, jenis_servis, biaya_servis, nama_bengkel, keterangan)
VALUES
-- Kendaraan 1 – Toyota Avanza
(1, '2025-01-10',  15000, 'Ganti Oli',    150000,  'Bengkel Maju Jaya',     'Ganti oli mesin SAE 10W-40'),
(1, '2025-02-20',  18500, 'Rutin',        350000,  'Bengkel Maju Jaya',     'Servis rutin 20.000 km: busi, filter udara'),
(1, '2025-03-30',  21000, 'Perbaikan Ban',200000,  'Tambal Ban Sejahtera',  'Ganti ban belakang kanan karena bocor besar'),

-- Kendaraan 2 – Honda Brio
(2, '2025-01-15',   8000, 'Ganti Oli',    130000,  'Honda AHASS Semarang',  'Ganti oli + filter oli'),
(2, '2025-03-05',  12000, 'Tune-up',      400000,  'Honda AHASS Semarang',  'Tune-up lengkap, bersihkan injektor'),
(2, '2025-04-01',  14500, 'Ganti Oli',    130000,  'Honda AHASS Semarang',  'Ganti oli rutin'),

-- Kendaraan 3 – Mitsubishi Xpander
(3, '2025-01-20',  30000, 'Rutin',        500000,  'Mitsubishi Authorized', 'Servis 30.000 km: kampas rem, filter'),
(3, '2025-03-15',  34000, 'Perbaikan AC', 750000,  'Bengkel AC Dingin Jaya','Isi freon + bersihkan evaporator'),

-- Kendaraan 4 – Suzuki Ertiga
(4, '2025-02-10',  22000, 'Ganti Oli',    145000,  'Suzuki Service Center', 'Ganti oli dan saringan oli'),
(4, '2025-03-20',  25000, 'Rutin',        420000,  'Suzuki Service Center', 'Servis 25.000 km rutin'),
(4, '2025-04-10',  27500, 'Perbaikan',    300000,  'Bengkel Karya Teknik',  'Ganti wiper depan + belakang, lampu sein'),

-- Kendaraan 5 – Daihatsu Xenia
(5, '2025-01-25',  40000, 'Ganti Oli',    140000,  'Daihatsu Service Pusat','Ganti oli mesin'),
(5, '2025-02-28',  43000, 'Tune-up',      380000,  'Daihatsu Service Pusat','Tune-up + busi baru'),
(5, '2025-04-05',  46000, 'Perbaikan Rem',550000,  'Bengkel Rem Handal',    'Ganti kampas rem depan & belakang'),
(5, '2025-04-20',  47500, 'Ganti Oli',    140000,  'Daihatsu Service Pusat','Ganti oli rutin');


-- ============================================================
-- TABEL 2: pemeriksaan_pengembalian
-- ============================================================

DROP TABLE IF EXISTS pemeriksaan_pengembalian;

CREATE TABLE pemeriksaan_pengembalian (
    id_pemeriksaan          INT             NOT NULL AUTO_INCREMENT  COMMENT 'PK – identitas unik tiap pemeriksaan',
    id_sewa                 INT             NOT NULL                 COMMENT 'FK → sewa.id_sewa',
    tanggal_pemeriksaan     DATE            NOT NULL                 COMMENT 'Tanggal kendaraan dikembalikan & diperiksa',
    kondisi_kendaraan       ENUM('Baik','Cukup','Rusak Ringan','Rusak Berat')
                                            NOT NULL DEFAULT 'Baik'  COMMENT 'Kondisi umum kendaraan saat kembali',
    ada_kerusakan           TINYINT(1)      NOT NULL DEFAULT 0       COMMENT 'Boolean: 1 = ada kerusakan, 0 = tidak',
    deskripsi_kerusakan     TEXT                                     COMMENT 'Detail kerusakan (diisi jika ada_kerusakan = 1)',
    estimasi_biaya_perbaikan DECIMAL(12,2)  NOT NULL DEFAULT 0       COMMENT 'Estimasi biaya perbaikan (Rp); 0 jika tidak rusak',
    ditanggung_asuransi     TINYINT(1)      NOT NULL DEFAULT 0       COMMENT 'Boolean: 1 = ditanggung asuransi, 0 = tidak',

    PRIMARY KEY (id_pemeriksaan),

    -- FK
    CONSTRAINT fk_periksa_sewa
        FOREIGN KEY (id_sewa)
        REFERENCES sewa (id_sewa)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    -- INDEX
    INDEX idx_periksa_sewa       (id_sewa),
    INDEX idx_periksa_tanggal    (tanggal_pemeriksaan),
    INDEX idx_periksa_kerusakan  (ada_kerusakan)

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  COMMENT='Hasil pemeriksaan kondisi kendaraan saat dikembalikan penyewa';


-- ------------------------------------------------------------
-- INSERT DATA SAMPLE – pemeriksaan_pengembalian (7 baris, 1 per sewa)
-- ------------------------------------------------------------
INSERT INTO pemeriksaan_pengembalian
    (id_sewa, tanggal_pemeriksaan, kondisi_kendaraan, ada_kerusakan,
     deskripsi_kerusakan, estimasi_biaya_perbaikan, ditanggung_asuransi)
VALUES
-- Sewa 1: Avanza – kembali baik
(1, '2025-04-03', 'Baik',         0, NULL,                                          0,       0),

-- Sewa 2: Brio – lecet kecil di bemper
(2, '2025-04-07', 'Rusak Ringan', 1, 'Lecet bemper depan kiri akibat gesekan parkir', 350000, 0),

-- Sewa 3: Xpander – kondisi cukup, tidak ada kerusakan signifikan
(3, '2025-04-15', 'Cukup',        0, 'Interior sedikit kotor, sudah dibersihkan',      0,      0),

-- Sewa 4: Ertiga – kaca spion patah, ditanggung asuransi
(4, '2025-04-14', 'Rusak Ringan', 1, 'Spion kanan patah karena tersenggol kendaraan lain', 200000, 1),

-- Sewa 5: Xenia – kerusakan berat, bodi penyok & lampu pecah
(5, '2025-04-20', 'Rusak Berat',  1, 'Bodi kiri penyok, lampu depan kiri pecah akibat kecelakaan minor', 2500000, 1),

-- Sewa 6: Brio – kondisi baik
(6, '2025-04-24', 'Baik',         0, NULL,                                          0,       0),

-- Sewa 7: Xpander – ban kempes, diganti di tempat
(7, '2025-04-28', 'Cukup',        1, 'Ban belakang kanan kempes, sudah ditambal sementara oleh penyewa', 150000, 0);
