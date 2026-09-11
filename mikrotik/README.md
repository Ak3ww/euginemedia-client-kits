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

---

## 3. Standarisasi Port Remote & SNMP OLT:

Secara default, MikroTik mengarahkan port DST-NAT berikut:
* **OLT 1 (VSOL V1600GS)**:
  * Web GUI: Port TCP `8001` $\rightarrow$ `http://192.168.30.6:8001`
  * SNMP: Port UDP `1611` $\rightarrow$ `192.168.30.6:161` (Community: `public`)
* **Jika ada OLT ke-2 (Multi-OLT)**:
  * Gunakan IP `192.168.30.7`, Web Port TCP `8002`, SNMP Port UDP `1612`.
* **Jika ada OLT ke-3**:
  * Gunakan IP `192.168.30.8`, Web Port TCP `8003`, SNMP Port UDP `1613`.
