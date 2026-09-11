# PANDUAN MANUSIA LAPANGAN (UNTUK TEKNISI DI MEJA KERJA)

Panduan bahasa manusia tanpa istilah rumit untuk memandu Anda colok kabel, cek lampu LED, dan memastikan OLT + MikroTik menyala sempurna.

---

## 1. Kamus Singkat Istilah Lapangan

* **Apa itu HTB?**
  HTB adalah kotak besi kecil penembus fiber optik jadul (sering merk *Netlink HTB-3100*). Kelemahannya: kabel harus 1 per 1, butuh colokan listrik di tiang, dan gampang rusak.
  **Tujuan Anda ke klien adalah MENGGANTIKAN HTB TERSEBUT dengan OLT VSOL 1 PON yang jauh lebih modern.**
* **Apa itu OLT VSOL 1 PON?**
  Pusat pemancar internet optik yang bisa melayani hingga **128 rumah pelanggan** hanya lewat 1 lubang kabel optik (PON 1) menggunakan splitter pasif (tanpa listrik di tiang).
* **Apa itu ONT / ONU?**
  Modem Wi-Fi yang ditaruh di dalam rumah pelanggan (merk ZTE F609, Huawei HG8245, Skyworth, dll).

---

## 2. Urutan Colokan Kabel Fisik (Langkah demi Langkah)

### TAHAP 1: Setting OLT di Meja dengan Laptop (3 Menit)
1. Colok kabel power listrik OLT ke stop kontak. Nyalakan tombol saklar power di belakang.
2. Ambil 1 kabel LAN UTP biasa:
   * Ujung 1: Colok ke port **LAN Laptop Anda**.
   * Ujung 2: Colok ke port **GE 0/1** (atau port **MGMT**) di OLT.
3. Di laptop Anda (Windows):
   * Buka *Network Connections* $\rightarrow$ Ethernet $\rightarrow$ Properties $\rightarrow$ IPv4.
   * Isi manual: IP `192.168.8.2`, Subnet Mask `255.255.255.0`. Klik OK.
4. Buka browser (Chrome/Edge), ketik: `http://192.168.8.100`.
   * Login: User `admin`, Password `admin` (atau `admin123`).
5. Buka menu **Configuration Management** $\rightarrow$ Pilih file `olt/vsol-1600gs/vsol-1600gs-clean.conf` $\rightarrow$ Klik **Upload**.
6. Klik **Save Configuration** $\rightarrow$ Klik **Reboot**.
7. Tunggu lampu OLT kedip-kedip sampai normal kembali (± 1 menit).
8. Cabut kabel LAN dari laptop. (Tahap OLT Selesai!).

---

### TAHAP 2: Sambungkan OLT ke MikroTik (2 Menit)
1. Ambil kabel LAN UTP:
   * Ujung 1: Colok ke port **GE 0/1 OLT**.
   * Ujung 2: Colok ke port **ether3 MikroTik** (atau port kosong lain yang dipilih).
2. Hubungkan laptop Anda ke MikroTik (bisa lewat port ether lain atau via Wi-Fi MikroTik).
3. Buka Winbox di laptop $\rightarrow$ Login ke MikroTik klien.
4. Buka New Terminal di Winbox $\rightarrow$ Jalankan script inspeksi `01-inspect-client-router.rsc` $\rightarrow$ Paste hasilnya ke AI Agent laptop Anda.
5. AI Agent akan memberikan script akhir $\rightarrow$ Paste script tersebut di Winbox.
6. Tes dari laptop Anda: Buka browser ke `http://192.168.30.6:8003`.
   * **Jika web admin OLT terbuka, berarti jalur kabel LAN MikroTik ke OLT sudah 100% SUKSES!**

---

### TAHAP 3: Pasang SFP Optik & Colok Kabel Fiber (2 Menit)
1. Ambil modul **SFP GPON C+ atau C++** (colokan besi kecil yang ada tutup plastiknya).
2. Tancapkan modul SFP tersebut ke lubang **PON 1** OLT sampai bunyi *KLIK*.
3. Buka tutup pelindung karet birunya.
4. Tancapkan kabel optik (konektor biru SC/UPC) dari jalur ODP/kabel luar ke dalam lubang SFP PON 1 OLT tersebut.

---

### TAHAP 4: Uji Coba di Modem Pelanggan (2 Menit)
1. Di modem ONT rumah pelanggan (misal ZTE F609):
   * Colok kabel optik dropcore ke lubang biru di bawah/belakang modem.
2. **Lihat Lampu LED di Modem**:
   * **Lampu LOS**: Harus **MATI** (artinya kabel optik tersambung, tidak putus).
   * **Lampu PON**: Harus **HIJAU DIAM / TIDAK KEDIP** (artinya OLT dan modem sudah saling terhubung).
3. Buka web admin modem di browser HP/Laptop (`192.168.1.1`):
   * Masuk menu **Network** $\rightarrow$ **WAN Connection**.
   * Buat koneksi baru:
     * Mode: **Route**
     * Service: **INTERNET**
     * VLAN: **Centang (ON)**, isi VLAN ID: **`20`**
     * Type: **PPPoE**
     * Username: **`test`**
     * Password: **`123`**
     * Port Binding: Centang LAN1, LAN2, LAN3, LAN4, dan SSID1.
     * Klik **Apply / Save**.
4. Cek lampu **Internet** di modem ONT $\rightarrow$ Lampu Internet akan menyala hijau, HP langsung bisa browsing dan internetan!

---

## 3. Skenario Darurat Lapangan: "Bagaimana jika klien BELUM punya MikroTik?"

Kadang ada pengusaha RT/RW Net pemula yang cuma punya **Modem Indihome** langsung dicolok ke HTB.
* **Ingat Rumus ini**: OLT **TIDAK BISA** langsung dicolok ke Modem Indihome, karena OLT butuh router MikroTik untuk membagi bandwidth dan akun PPPoE.
* **Solusinya**:
  1. Pasang 1 MikroTik di antara Modem Indihome dan OLT:
     * Kabel LAN dari Modem Indihome $\rightarrow$ Colok ke **ether1 MikroTik** (Port WAN).
     * Kabel LAN dari **ether3 MikroTik** $\rightarrow$ Colok ke **GE 0/1 OLT**.
  2. Setting MikroTik ether1 minta IP DHCP Client dari Indihome.
  3. Lalu lanjutkan TAHAP 2 dan TAHAP 3 di atas.
