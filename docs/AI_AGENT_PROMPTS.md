# Template Prompt untuk AI Agent di Laptop Lapangan

Ketika Anda membuka repositori ini di laptop lapangan menggunakan Antigravity, Cursor, atau Claude Code, Anda bisa langsung meng-copy template prompt di bawah ini untuk memerintah AI Agent:

---

### Prompt 1: Analisa Router Klien & Generate Script Aman

```text
Halo Agent, saya sedang berada di lokasi klien untuk memasang OLT VSOL V1600GS 1 PON dan setting MikroTik. 

Berikut adalah hasil inspeksi dari MikroTik klien:
[PASTE HASIL DARI 01-inspect-client-router.rsc DI SINI]

Tolong analisa:
1. Port mana yang merupakan sumber internet (WAN) mereka?
2. Port mana yang kosong dan aman untuk dicolok ke OLT?
3. Apakah ada subnet IP yang bentrok dengan subnet FTTH kita (192.168.20.0/22, 192.168.30.0/24, 10.40.10.0/24)?
4. Tolong buatkan script MikroTik yang sudah disesuaikan dan siap saya paste ke Winbox tanpa mengganggu jaringan lama klien!
```

---

### Prompt 2: Verifikasi Jika Web OLT Tidak Bisa Dibuka

```text
Halo Agent, saya sudah colok kabel dari OLT GE 0/1 ke MikroTik, tapi saat saya buka http://192.168.30.6:8001 di browser, halamannya tidak muncul.

Berikut konfigurasi IP address dan interface MikroTik saat ini:
[PASTE OUTPUT /ip address print DAN /interface bridge port print]

Tolong carikan masalahnya kenapa belum bisa tembus ke OLT.
```

---

### Prompt 3: Verifikasi Jika Modem ONT Tidak Dapat IP PPPoE

```text
Halo Agent, lampu PON di modem ONT pelanggan sudah hijau diam, tapi status PPPoE di modem masih connecting / belum dapet IP.

Berikut status /interface pppoe-server print dan /log print di MikroTik:
[PASTE OUTPUT LOG]

Tolong pandu apa yang salah di sisi modem atau MikroTik.
```
