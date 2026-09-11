# Panduan Script MikroTik FTTH

Folder ini berisi script RouterOS v7 untuk mengaktifkan layanan PPPoE FTTH yang sinkron dengan OLT VSOL V1600GS.

---

## 1. File di Folder Ini:

* **`01-inspect-client-router.rsc`**:
  Script non-destructive (hanya baca). Jalankan ini pertama kali di New Terminal Winbox klien untuk mengetahui port WAN, IP eksisting, dan port kosong.
* **`02-mikrotik-ftth-complete.rsc`**:
  Script implementasi FTTH lengkap. Berisi Bridge FTTH, VLAN 20/30/4000, Cake Queues, PPP Profile 10M-100M, PPPoE Server, Game Mangle, NAT Universal, dan Auto-Clean subuh.

---

## 2. Parameter yang Perlu Disesuaikan per Klien:

1. **Port Uplink ke OLT**:
   Secara default, baris penambahan port ke bridge dinonaktifkan dengan tanda komentar.
   Tentukan kabel LAN ke OLT dicolok di port berapa, lalu jalankan di terminal:
   ```text
   /interface bridge port add bridge=bridge-FTTH interface=ether3
   ```
   *(Ganti `ether3` sesuai port fisik yang digunakan)*.

2. **Subnet IP Pelanggan**:
   Default: `192.168.20.0/22` (Kapasitas ±1.000 user).
   Jika klien sudah menggunakan subnet `192.168.20.x`, AI Agent akan merekomendasikan subnet lain (misal `10.20.0.0/22`).
