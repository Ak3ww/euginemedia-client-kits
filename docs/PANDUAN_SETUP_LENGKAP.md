# PANDUAN EKSEKUSI CEPAT: OLT VSOL V1600GS (1 PON) & MIKROTIK FTTH

Panduan praktis lapangan untuk instalasi cepat paket FTTH (1 PON = maks 128 pelanggan) menggunakan template EugineMedia. Total pengerjaan: **± 10 – 15 menit**.

---

## 1. Skema Pengkabelan Fisik (Topologi Lapangan)

```text
[ SUMBER INTERNET KLIEN ] (Indihome / Biznet / Dedicated)
            │
            ▼ (Port WAN Klien, misal ether1)
   ┌─────────────────┐
   │ MIKROTIK ROUTER │ (CCR / RB Series)
   └─────────────────┘
            │ (Port Distribusi, misal ether3)
            ▼
    [ Kabel LAN UTP ]
            ▼
   ┌─────────────────┐
   │  OLT VSOL 1 PON │ (Port Uplink: GE 0/1 atau GE 0/2)
   └─────────────────┘
            │ (Port PON 1 - Kabel Optik Dropcore / Feeder)
            ▼
        [ ODC / ODP ]
            │ (Dropcore 1 Core)
            ▼
     [ MODEM ONT KLIEN ] (ZTE F609/F670, Huawei HG8245, Skyworth)
```

---

## 2. LANGKAH 1: Setup OLT VSOL V1600GS (3 Menit)

1. Tancapkan adaptor listrik OLT VSOL.
2. Colok kabel LAN dari laptop ke port **MGMT** atau port **GE 0/1** OLT.
3. Atur IP statis di laptop Anda:
   * **IP Address**: `192.168.8.2`
   * **Subnet Mask**: `255.255.255.0`
4. Buka browser (Chrome/Edge), akses IP default OLT:
   * URL: **`http://192.168.8.100`**
   * Username: **`admin`** | Password: **`admin`** (atau `admin123`)
5. Masuk ke menu: **System Management** $\rightarrow$ **Configuration Management** (atau **System** $\rightarrow$ **Config**).
6. Klik tombol **Choose File / Browse**, pilih file:
   👉 **`olt/vsol-1600gs/vsol-1600gs-clean.conf`**
7. Klik **Upload / Import Configuration**.
8. Klik **Save Configuration** $\rightarrow$ lalu klik **Reboot OLT**.
9. Tunggu OLT selesai reboot (sekitar 1–2 menit).

> [!IMPORTANT]
> **INGAT: WEB PORT BERUBAH KE 8003!**
> Setelah reboot, IP OLT berubah menjadi `192.168.8.200` dengan port `8003`.
> Akses laptop: `http://192.168.8.200:8003` (Password login admin: `@eugine0909@` atau password EugineMedia).

---

## 3. LANGKAH 2: Inspeksi & Setup MikroTik Klien (5 Menit)

1. Buka Winbox $\rightarrow$ Connect ke MikroTik klien.
2. Buka menu **New Terminal**.
3. Jalankan script inspeksi untuk memastikan kondisi aman:
   ```text
   /ip route print where dst-address=0.0.0.0/0
   /ip address print
   /interface print where running=false and type=ether
   ```
4. Jika meminta AI Agent: paste hasil di atas ke AI Agent untuk dibuatkan script yang disesuaikan.
5. Jalankan script **`mikrotik/02-mikrotik-ftth-complete.rsc`** di New Terminal Winbox.
6. **Tentukan Port Colokan ke OLT**:
   Ketik perintah ini di New Terminal (misal dicolok di **ether3**):
   ```text
   /interface bridge port add bridge=bridge-FTTH interface=ether3
   ```
   *(Jika dicolok di ether2, ganti interface=ether2)*.
7. Hubungkan kabel LAN dari port **ether3 MikroTik** ke port **GE 0/1 OLT**.

---

## 4. LANGKAH 3: Uji Coba Remote OLT dari MikroTik (1 Menit)

Setelah kabel MikroTik dan OLT tersambung:
1. Pastikan laptop Anda tersambung ke jaringan MikroTik (dapat IP lokal MikroTik).
2. Buka browser di laptop Anda, akses IP manajemen OLT:
   👉 **`http://192.168.30.6:8003`**
3. Jika halaman login OLT VSOL langsung terbuka, **Jalur Management OLT (VLAN 30) SUDAH 100% SUKSES!**

---

## 5. LANGKAH 4: Uji Coba Modem ONT Pelanggan (3 Menit)

1. Pasang modul SFP GPON (C+ atau C++) ke slot PON OLT.
2. Colok kabel optik (pigtail/patch cord) dari OLT menuju modem ONT (misal ZTE F609).
3. Tunggu 30–60 detik hingga lampu **PON** di modem ONT menyala hijau diam (*solid*).
   *(Karena mode `onu auto-learn` sudah aktif, OLT otomatis mengenali dan meng-auth ONT baru).*
4. Masuk ke web admin modem ONT (misal `192.168.1.1`):
   * Masuk ke menu **Network** $\rightarrow$ **WAN Connection**.
   * Mode: **Route**
   * Service Type: **INTERNET**
   * Enable VLAN: **Centang (ON)**
   * **VLAN ID**: **`20`** (Wajib 20!)
   * 802.1p: `0`
   * Link Type: **PPPoE**
   * Username: **`test`**
   * Password: **`123`**
   * Binding Port: Centang LAN 1 - 4 dan SSID 1.
   * Klik **Apply / Save**.
5. Buka Winbox MikroTik $\rightarrow$ menu **PPP** $\rightarrow$ tab **Active Connections**.
   * Anda akan langsung melihat user **`test`** aktif dan mendapat IP `192.168.20.x`.
6. Tes browsing / speedtest dari Wi-Fi modem ONT. Internet langsung jalan kencang dengan limitasi profile 20 Mbps dan Cake Queues!
