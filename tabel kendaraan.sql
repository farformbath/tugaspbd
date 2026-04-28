-- =========================
-- TABLE KENDARAAN
-- =========================
CREATE TABLE kendaraan (
    id_kendaraan INT AUTO_INCREMENT PRIMARY KEY,

    nomor_polisi VARCHAR(15) NOT NULL UNIQUE,

    merk VARCHAR(50) NOT NULL,
    model VARCHAR(50) NOT NULL,

    tahun YEAR NOT NULL,
    warna VARCHAR(30),

    jenis ENUM('mobil', 'motor') NOT NULL DEFAULT 'mobil',

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

    -- =========================
    -- CONSTRAINT VALIDATION
    -- =========================
    CONSTRAINT chk_kapasitas 
        CHECK (kapasitas_penumpang > 0),

    CONSTRAINT chk_km 
        CHECK (km_terakhir >= 0),

    CONSTRAINT chk_tahun 
        CHECK (tahun BETWEEN 2000 AND YEAR(CURDATE())),

    -- =========================
    -- FOREIGN KEY
    -- =========================
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

    -- =========================
    -- INDEX (INLINE)
    -- =========================
    INDEX idx_status (status),
    INDEX idx_kategori (id_kategori),
    INDEX idx_cabang (id_cabang_homebase)
);

-- =========================
-- TRIGGER 1
-- Maintenance tidak boleh disewa
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
-- TRIGGER 2
-- KM tidak boleh turun
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
