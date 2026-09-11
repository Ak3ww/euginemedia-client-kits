# EugineMedia Client Kits — ISP FTTH Field Deployment Toolkit

Repositori toolkit standar teknisi lapangan EugineMedia untuk instalasi cepat paket FTTH (1 PON OLT VSOL V1600GS + MikroTik RouterOS v7).

Dirancang khusus agar **100% Ramah AI Agent** (Antigravity, Cursor, Claude Code) sehingga AI di laptop lapangan bisa langsung menjadi co-pilot otomatis saat setting di lokasi klien.

---

## 1. Struktur Repositori

```text
euginemedia-client-kits/
├── .agents/
│   └── AGENTS.md                  # Panduan operasional untuk AI Agent di laptop lapangan
├── docs/
│   ├── PANDUAN_SETUP_LENGKAP.md   # Panduan master langkah demi langkah instalasi (10-15 menit)
│   ├── PANDUAN_MANUSIA_LAPANGAN.md # Panduan fisik, kabel, splitter optik, dan troubleshooting
│   └── AI_AGENT_PROMPTS.md        # Template prompt siap copy untuk bertanya ke AI Agent
├── olt/
│   └── vsol-1600gs/
│       ├── vsol-1600gs-clean.conf # Backup OLT bersih (tanpa ghost ONU, auto-learn aktif)
│       └── README.md              # Info IP default, port 8001, SNMP 1611, dan cara upload
└── mikrotik/
    ├── 01-inspect-client-router.rsc # Script baca kondisi router klien (non-destructive, aman)
    ├── 02-mikrotik-ftth-complete.rsc # Script FTTH lengkap (Cake Queue, Game Mangle, PPPoE Server)
    ├── reference/                 # Golden reference config CCR2116 EugineMedia
    └── README.md                  # Detail parameter MikroTik
```

---

## 2. Standar Topologi Jaringan (Kopel OLT & MikroTik)

| Segmen | VLAN ID | Subnet / IP Gateway | IP Perangkat Target | Keterangan |
| :--- | :--- | :--- | :--- | :--- |
| **PPPoE Pelanggan** | VLAN 20 | `192.168.20.1/22` | Pool: `192.168.20.2 - 192.168.22.254` | Trafik internet modem ONT pelanggan |
| **Management OLT** | VLAN 30 | `192.168.30.1/24` | OLT: `192.168.30.6` (Web: `8001`, SNMP: `1611`) | Remote web admin & monitoring OLT tanpa cabut kabel |
| **TR-069 ACS ONT** | VLAN 4000 | `10.40.10.1/24` | Pool: `10.40.10.2 - 10.40.11.254` | Jalur IP internal GenieACS / Remote ONT |

---

## 3. Cara Menggunakan Bersama AI Agent di Lokasi Klien

1. **Buka folder repo ini di Antigravity / Cursor** pada laptop yang Anda bawa ke lokasi.
2. Colok kabel LAN dari laptop ke MikroTik klien $\rightarrow$ Buka Winbox.
3. Jalankan script inspeksi di terminal Winbox:
   ```text
   /ip route print where dst-address=0.0.0.0/0
   /ip address print
   /interface print where running=false and type=ether
   ```
4. Copy hasilnya dan katakan ke AI Agent:
   > *"Agent, tolong baca hasil inspeksi router klien ini dan sesuaikan script mikrotik/02-mikrotik-ftth-complete.rsc untuk router ini."*
5. AI Agent akan langsung menganalisa port WAN, memilih port kosong untuk OLT, dan memberikan script yang 100% aman tanpa merusak internet lama klien.
