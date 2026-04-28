-- DDL: Table sewa_kendaraan
CREATE TABLE sewa_kendaraan (
    id_sewa INT AUTO_INCREMENT PRIMARY KEY,
    nama_pelanggan VARCHAR(100) NOT NULL,
    no_hp VARCHAR(15),
    id_kendaraan INT NOT NULL,
    tanggal_sewa DATE NOT NULL,
    tanggal_kembali DATE NOT NULL,
    harga_per_hari DECIMAL(10,2) NOT NULL,
    lama_hari INT NOT NULL,
    total_harga DECIMAL(12,2) NOT NULL,

    CONSTRAINT fk_kendaraan
        FOREIGN KEY (id_kendaraan) REFERENCES kendaraan(id_kendaraan)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- DML: Sample data
INSERT INTO sewa_kendaraan 
(nama_pelanggan, no_hp, id_kendaraan, tanggal_sewa, tanggal_kembali, harga_per_hari, lama_hari, total_harga)
VALUES
('Andi', '081234567890', 1, '2026-04-01', '2026-04-03', 200000, 2, 400000),
('Budi', '082345678901', 2, '2026-04-02', '2026-04-05', 250000, 3, 750000),
('Citra', '083456789012', 3, '2026-04-03', '2026-04-04', 300000, 1, 300000);
