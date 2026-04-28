USE rental_kendaraan;

--  DDL

CREATE TABLE cabang (
    id_cabang       INT             NOT NULL AUTO_INCREMENT,
    nama_cabang     VARCHAR(100)    NOT NULL,
    alamat          VARCHAR(255)    NOT NULL,
    kota            VARCHAR(100)    NOT NULL,
    nomor_telepon   VARCHAR(20)     NOT NULL,
    email           VARCHAR(100)    NOT NULL,
    status_cabang   ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif',
    CONSTRAINT pk_cabang          PRIMARY KEY (id_cabang),
    CONSTRAINT uq_cabang_email    UNIQUE (email),
    CONSTRAINT uq_cabang_telepon  UNIQUE (nomor_telepon)
) ENGINE=InnoDB;

CREATE TABLE kategori (
    id_kategori     INT             NOT NULL AUTO_INCREMENT,
    nama_kategori   VARCHAR(100)    NOT NULL,
    tarif_per_hari  DECIMAL(12,2)   NOT NULL,
    tarif_weekend   DECIMAL(12,2)   NOT NULL,
    deskripsi       TEXT,
    CONSTRAINT pk_kategori          PRIMARY KEY (id_kategori),
    CONSTRAINT chk_tarif_harian     CHECK (tarif_per_hari > 0),
    CONSTRAINT chk_tarif_weekend    CHECK (tarif_weekend  > 0)
) ENGINE=InnoDB;

--  INDEX

CREATE INDEX idx_cabang_kota         ON cabang   (kota);
CREATE INDEX idx_cabang_status       ON cabang   (status_cabang);
CREATE INDEX idx_kategori_tarif      ON kategori (tarif_per_hari);

--  DML — INSERT DATA

INSERT INTO cabang (nama_cabang, alamat, kota, nomor_telepon, email, status_cabang) VALUES
('Cabang Semarang Pusat',   'Jl. Pemuda No. 1',         'Semarang',   '024-1234001', 'semarang.pusat@rental.id',   'aktif'),
('Cabang Semarang Selatan', 'Jl. Setiabudi No. 88',     'Semarang',   '024-1234002', 'semarang.selatan@rental.id', 'aktif'),
('Cabang Yogyakarta',       'Jl. Malioboro No. 10',     'Yogyakarta', '0274-234001', 'yogyakarta@rental.id',       'aktif'),
('Cabang Solo',             'Jl. Slamet Riyadi No. 55', 'Solo',       '0271-234001', 'solo@rental.id',             'aktif'),
('Cabang Surabaya',         'Jl. Darmo No. 200',        'Surabaya',   '031-2340010', 'surabaya@rental.id',         'aktif'),
('Cabang Semarang Utara',   'Jl. Kaligawe No. 12',      'Semarang',   '024-1234003', 'semarang.utara@rental.id',   'nonaktif');

INSERT INTO kategori (nama_kategori, tarif_per_hari, tarif_weekend, deskripsi) VALUES
('Motor Matic',    75000.00,    90000.00, 'Sepeda motor matic kapasitas ≤150cc'),
('Motor Sport',   100000.00,   120000.00, 'Sepeda motor sport kapasitas >150cc'),
('City Car',      250000.00,   300000.00, 'Mobil kecil untuk dalam kota, 4-5 penumpang'),
('MPV',           400000.00,   480000.00, 'Kendaraan keluarga, 6-8 penumpang'),
('SUV',           550000.00,   660000.00, 'Kendaraan serba guna, 5-7 penumpang'),
('Luxury',        900000.00,  1100000.00, 'Kendaraan premium / executive');
