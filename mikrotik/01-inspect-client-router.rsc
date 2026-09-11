# ==============================================================================
# SCRIPT INSPEKSI MIKROTIK KLIEN (100% AMAN - HANYA BACA / NON-DESTRUCTIVE)
# Jalankan script ini di New Terminal Winbox klien SEBELUM melakukan konfigurasi.
# Output dari script ini di-copy dan diberikan ke AI Agent untuk dianalisa.
# ==============================================================================

:put "=================================================="
:put "=== 1. DEFAULT GATEWAY & INTERNET ROUTE (WAN) ==="
:put "=================================================="
/ip route print where dst-address=0.0.0.0/0

:put "\n=================================================="
:put "=== 2. IP ADDRESSES EKSISTING DI ROUTER ==="
:put "=================================================="
/ip address print

:put "\n=================================================="
:put "=== 3. DAFTAR INTERFACE & STATUS RUNNING ==="
:put "=================================================="
/interface print where type="ether" or type="bridge"

:put "\n=================================================="
:put "=== 4. FIREWALL NAT MASQUERADE EKSISTING ==="
:put "=================================================="
/ip firewall nat print where action="masquerade"

:put "\n=================================================="
:put "=== 5. DAFTAR VLAN EKSISTING (JIKA ADA) ==="
:put "=================================================="
/interface vlan print

:put "\n[SELESAI] Copy seluruh output di atas dan berikan ke AI Agent."
