# Panduan Konfigurasi OLT VSOL V1600GS (1 PON GPON)

File: `vsol-1600gs-clean.conf`

File konfigurasi ini adalah salinan identik dari standar produksi EugineMedia, namun **sudah dibersihkan dari seluruh pendaftaran Serial Number ONT lama**.

---

## 1. Parameter Utama Setelah Restore:

* **IP Manajemen Awal (VLAN 1)**: `192.168.8.200`
* **IP Manajemen OLT (VLAN 30)**: `192.168.30.6` (Gateway: `192.168.30.1`)
* **Web Admin Port**: **`8001`** (Wajib cantumkan port saat akses browser!)
  * Akses lokal laptop: `http://192.168.8.200:8001`
  * Akses via jaringan MikroTik: `http://192.168.30.6:8001`
* **SNMP Monitoring**: Port UDP standard `161` (diteruskan dari MikroTik DST-NAT port `1611`). Community: `public` (read-only), `private` (read-write).
* **Login Admin**: Username `admin`, Password `@eugine0909@` (atau password default EugineMedia).

---

## 2. Fitur Otomatis yang Sudah Aktif:

1. **Auto-Learn ONU**:
   Modem ONT pelanggan (ZTE, Huawei, Skyworth, Fiberhome) yang dicolok ke port optik PON 1 akan otomatis ter-registrasi dan ter-binding ke profile line `line_FTTH` (VLAN 20).
2. **Port Uplink Hybrid (GE 0/1, GE 0/2, SFP+ 0/3)**:
   Kabel LAN ke MikroTik bisa dicolok ke port GE mana saja. Port sudah membawa VLAN 20 (tagged), VLAN 30 (tagged), VLAN 4000 (tagged), dan VLAN 1 (untagged).
3. **Loopback Detection & Storm Control**:
   Melindungi OLT dari loop kabel di sisi pelanggan.
