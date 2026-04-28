
-- =========================
-- CREATE TABLE KENDARAAN
-- =========================
CREATE TABLE kendaraan (
    id_kendaraan INT AUTO_INCREMENT PRIMARY KEY,

    nomor_polisi VARCHAR(15) NOT NULL UNIQUE,

    merk VARCHAR(50) NOT NULL,
    model VARCHAR(50) NOT NULL,

    tahun YEAR NOT NULL,
    warna VARCHAR(30),

    jenis ENUM('mobil', 'motor') NOT NULL,

    kapasitas_penumpang INT NOT NULL,
    transmisi ENUM('manual', 'matic') NOT NULL,

    status ENUM('tersedia', 'disewa', 'maintenance') 
        NOT NULL DEFAULT 'tersedia',

    km_terakhir INT NOT NULL DEFAULT 0,

    id_kategori INT,
    id_cabang_homebase INT,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP 
        ON UPDATE CURRENT_TIMESTAMP,

    -- CONSTRAINT
    CONSTRAINT chk_kapasitas CHECK (kapasitas_penumpang > 0),
    CONSTRAINT chk_km CHECK (km_terakhir >= 0),
    CONSTRAINT chk_tahun CHECK (tahun BETWEEN 2000 AND YEAR(CURDATE())),

    -- FOREIGN KEY
    CONSTRAINT fk_kendaraan_kategori
        FOREIGN KEY (id_kategori) 
        REFERENCES kategori(id_kategori)
        ON UPDATE CASCADE 
        ON DELETE SET NULL,

    CONSTRAINT fk_kendaraan_cabang
        FOREIGN KEY (id_cabang_homebase) 
        REFERENCES cabang(id_cabang)
        ON UPDATE CASCADE 
        ON DELETE SET NULL,

    -- INDEX
    INDEX idx_status (status),
    INDEX idx_kategori (id_kategori),
    INDEX idx_cabang (id_cabang_homebase)
);

-- =========================
-- INSERT DATA (MOBIL + MOTOR)
-- =========================
INSERT INTO kendaraan 
(nomor_polisi, merk, model, tahun, warna, jenis, kapasitas_penumpang, transmisi, status, km_terakhir, id_kategori, id_cabang_homebase)
VALUES
-- MOTOR
('H1111AA','Honda','Beat',2023,'Hitam','motor',2,'matic','tersedia',3000,1,1),
('H2222BB','Yamaha','Vixion',2022,'Merah','motor',2,'manual','tersedia',8000,2,2),

-- MOBIL
('H3333CC','Honda','Brio',2023,'Putih','mobil',5,'matic','tersedia',5000,3,1),
('H4444DD','Toyota','Avanza',2022,'Hitam','mobil',7,'manual','disewa',15000,4,2),
('H5555EE','Toyota','Innova',2020,'Silver','mobil',7,'manual','maintenance',45000,4,3);

-- =========================
-- TRIGGER 1: Maintenance tidak boleh disewa
-- =========================
DELIMITER $$

CREATE TRIGGER trg_kendaraan_no_rent_if_maintenance
BEFORE UPDATE ON kendaraan
FOR EACH ROW
BEGIN
    IF OLD.status = 'maintenance' AND NEW.status = 'disewa' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Kendaraan sedang maintenance, tidak boleh disewa';
    END IF;
END$$

DELIMITER ;

-- =========================
-- TRIGGER 2: KM tidak boleh turun
-- =========================
DELIMITER $$

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
