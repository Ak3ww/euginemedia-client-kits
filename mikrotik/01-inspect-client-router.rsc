# ==============================================================================
# SCRIPT INSPEKSI MIKROTIK KLIEN LENGKAP (100% NON-DESTRUCTIVE / HANYA BACA)
# Jalankan seluruh perintah ini di New Terminal Winbox klien.
# Copy seluruh output teks dari terminal, lalu paste ke AI Agent di laptop Anda.
# ==============================================================================

:put "=================================================="
:put "=== 1. DEFAULT GATEWAY & SUMBER INTERNET (WAN) ==="
:put "=================================================="
/ip route print where dst-address=0.0.0.0/0

:put "\n=================================================="
:put "=== 2. IP ADDRESSES EKSISTING DI ROUTER ==="
:put "=================================================="
/ip address print

:put "\n=================================================="
:put "=== 3. DAFTAR INTERFACE & STATUS RUNNING/KOSONG ==="
:put "=================================================="
/interface print where type="ether" or type="bridge" or type="vlan"

:put "\n=================================================="
:put "=== 4. IP POOL EKSISTING ==="
:put "=================================================="
/ip pool print

:put "\n=================================================="
:put "=== 5. FIREWALL NAT MASQUERADE EKSISTING ==="
:put "=================================================="
/ip firewall nat print

:put "\n=================================================="
:put "=== 6. FIREWALL FILTER EKSISTING (DROP/ACCEPT) ==="
:put "=================================================="
/ip firewall filter print

:put "\n=================================================="
:put "=== 7. PROFIL PPP & QUEUES EKSISTING ==="
:put "=================================================="
/ppp profile print
/queue type print where kind="cake" or kind="sfq"

:put "\n[SELESAI] Copy seluruh output di atas dan berikan ke AI Agent."
