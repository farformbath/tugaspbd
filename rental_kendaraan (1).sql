-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 28 Apr 2026 pada 07.58
-- Versi server: 10.4.32-MariaDB
-- Versi PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

-- Database: `rental_kendaraan`
-- Struktur dari tabel `customer`
CREATE TABLE `customer` (
  `id_customer` int(11) NOT NULL,
  `nama_lengkap` varchar(100) DEFAULT NULL,
  `nomor_ktp` varchar(20) DEFAULT NULL,
  `nomor_sim` varchar(20) DEFAULT NULL,
  `alamat` text DEFAULT NULL,
  `nomor_telepon` varchar(15) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `tanggal_daftar` date DEFAULT NULL,
  `status_customer` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data untuk tabel `customer`
INSERT INTO `customer` (`id_customer`, `nama_lengkap`, `nomor_ktp`, `nomor_sim`, `alamat`, `nomor_telepon`, `email`, `tanggal_daftar`, `status_customer`) VALUES
(1, 'Budi Santoso', '3301012345670001', 'SIM-9901', 'Jl. Gajah Mada No. 10, Semarang', '087656765476', 'budisantoso@gmail.com', '2026-04-08', 'Aktif'),
(2, 'Tasya Putri', '3301019876540002', 'SIM-9902', 'Jl. Ahmad Yani No. 5, Semarang', '08432456754', 'tasyaputri@gmail.com', '2026-04-14', 'Aktif');

-- Struktur dari tabel `driver`
CREATE TABLE `driver` (
  `id_driver` int(11) NOT NULL,
  `nama_driver` varchar(100) DEFAULT NULL,
  `nomor_sim` varchar(20) DEFAULT NULL,
  `jenis_sim` varchar(10) DEFAULT NULL,
  `nomor_telepon` varchar(15) DEFAULT NULL,
  `status_driver` varchar(20) DEFAULT NULL,
  `id_cabang` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data untuk tabel `driver`
INSERT INTO `driver` (`id_driver`, `nama_driver`, `nomor_sim`, `jenis_sim`, `nomor_telepon`, `status_driver`, `id_cabang`) VALUES
(1, 'Andi Saputra', 'DRV-001', 'A', '08156789012', 'Tersedia', 1),
(2, 'Satria', 'DRV-002', 'B1', '08167890123', 'Tersedia', 1),
(3, 'Rizky Pratama', 'DRV-003', 'A', '08178901234', 'Sedang Bertugas', 2);

-- Indeks untuk tabel `customer`
ALTER TABLE `customer`
  ADD PRIMARY KEY (`id_customer`),
  ADD UNIQUE KEY `nomor_ktp` (`nomor_ktp`),
  ADD UNIQUE KEY `nomor_sim` (`nomor_sim`),
  ADD KEY `nama_lengkap` (`nama_lengkap`);

-- Indeks untuk tabel `driver`
ALTER TABLE `driver`
  ADD PRIMARY KEY (`id_driver`),
  ADD KEY `status_driver` (`status_driver`);

-- AUTO_INCREMENT untuk tabel `customer`
ALTER TABLE `customer`
  MODIFY `id_customer` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

-- AUTO_INCREMENT untuk tabel `driver`
ALTER TABLE `driver`
  MODIFY `id_driver` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
