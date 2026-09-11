# 2026-09-11 12:40:58 by RouterOS 7.16.2
# software id = 7S4Z-C0SF
#
# model = CCR2116-12G-4S+
# serial number = HJP0AZ18801
/interface bridge
add name=bridge-LAN
/interface ethernet
set [ find default-name=ether1 ] comment="TO-OLT_HSGQ-PORT GE-1" name=\
    ether1-Distribution
set [ find default-name=ether2 ] comment="TO-OLT_GGCLINK-1-PORT GE-1" name=\
    ether2-Distribution
set [ find default-name=ether3 ] comment="TO_OLT_VSOL-PORT GE-1" name=\
    ether3-Distribution
set [ find default-name=ether4 ] comment="TO-OLT_GGCLINK-2-PORT GE-1" name=\
    ether4-Distributin
set [ find default-name=ether5 ] comment="TO-OLT_VSOL V1600GT-PORT GE-3"
set [ find default-name=sfp-sfpplus1 ] auto-negotiation=no comment=\
    "TO-UpLink ( Super Media Indonesia )" name=sfp-sfpplus1-SMI speed=\
    1G-baseT-full
/interface wireguard
add listen-port=3579 mtu=1420 name=wg-mikrotik-cib
/interface vlan
add comment="VLAN 10 UNTUK HOTSPOT" interface=bridge-LAN name=vlan10-hotspot \
    vlan-id=10
add interface=bridge-LAN name=vlan20-PPPoE vlan-id=20
add interface=bridge-LAN name=vlan30-MGMT-OLT vlan-id=30
add comment="VLAN 4000 UNTUK TR069 ACS" interface=bridge-LAN name=\
    vlan4000-tr069 vlan-id=4000
/interface list
add name=wan
/ip hotspot profile
add dns-name=wifi.euginemediagroup.com hotspot-address=10.50.10.1 login-by=\
    http-chap,http-pap name=hsprof-10
/ip hotspot user profile
add name=EugineBillradius rate-limit=5M/5M shared-users=30
/ip pool
add name=dhcp_pool0 ranges=192.168.50.2-192.168.50.254
add comment="POOL PPPOE CIBINONG " name=POOL-PPPOE ranges=\
    192.168.20.2-192.168.21.254,192.168.22.2-192.168.22.254
add comment="EugineBill - IP Pool untuk user yang diisolir" name=pool-isolir \
    ranges=192.168.200.100-192.168.200.200
add comment="DHCP TR069 POOL" name=dhcp_pool_tr069 ranges=\
    10.40.10.2-10.40.11.254
add comment="EugineBill RADIUS" name=pool-radius-default ranges=\
    10.10.10.2-10.10.10.254
add name=hs-pool-10 ranges=10.50.10.10-10.50.10.250
/ip dhcp-server
add address-pool=dhcp_pool0 interface=bridge-LAN name=dhcp1
add address-pool=dhcp_pool_tr069 comment="DHCP TR069 EUGINEBILL" interface=\
    vlan4000-tr069 name=dhcp-tr069
add address-pool=hs-pool-10 interface=vlan10-hotspot lease-time=1h name=\
    dhcp-hs10
/ip hotspot
add address-pool=hs-pool-10 disabled=no interface=vlan10-hotspot name=\
    hotspot-vlan10 profile=hsprof-10
/port
set 0 name=serial0
/ppp profile
add address-list=isolir comment=\
    "EugineBill - Profile untuk user yang diisolir" local-address=\
    192.168.200.1 name=isolir rate-limit=64k/64k remote-address=pool-isolir \
    use-compression=no use-encryption=no use-mpls=no
add comment="EugineBill Profile" local-address=10.10.10.1 name=EugineBill \
    remote-address=pool-radius-default use-compression=no use-encryption=no
/queue type
add kind=sfq name=SFQ
add kind=cake name=cake-global--test
add cake-ack-filter=filter cake-diffserv=diffserv4 cake-memlimit=32.0MiB \
    cake-mpu=84 cake-nat=yes cake-overhead=38 cake-overhead-scheme=ethernet \
    cake-rtt=50ms kind=cake name=cake
/ppp profile
add local-address=192.168.20.1 name="20 Mbps" only-one=yes queue-type=cake \
    rate-limit=21M/21M remote-address=POOL-PPPOE
add local-address=192.168.20.1 name="50 Mbps" only-one=yes queue-type=cake \
    rate-limit=51M/51M remote-address=POOL-PPPOE
add local-address=192.168.20.1 name="75 Mbps" only-one=yes queue-type=cake \
    rate-limit=78M/78M remote-address=POOL-PPPOE
add local-address=192.168.20.1 name="100 Mbps" only-one=yes queue-type=cake \
    rate-limit=104M/104M remote-address=POOL-PPPOE
add local-address=192.168.20.1 name="10 Mbps" only-one=yes queue-type=cake \
    rate-limit="10M/10M 0/0 0/0 0/0 7 5M/5M" remote-address=POOL-PPPOE
add local-address=192.168.20.1 name="30 Mbps" only-one=yes queue-type=cake \
    rate-limit=31M/31M remote-address=POOL-PPPOE
add insert-queue-before=bottom local-address=192.168.20.1 name=FASUM \
    only-one=yes queue-type=cake rate-limit="10M/10M 0/0 0/0 0/0 8 128K/128K" \
    remote-address=POOL-PPPOE
/routing table
add fib name=TOPSETTING-VPN
add fib name=uv-speedtest
/interface bridge port
add bridge=bridge-LAN interface=ether4-Distributin
add bridge=bridge-LAN interface=ether2-Distribution
add bridge=bridge-LAN interface=ether3-Distribution
add bridge=bridge-LAN interface=ether5
add bridge=bridge-LAN interface=ether1-Distribution
/interface bridge settings
set use-ip-firewall-for-pppoe=yes use-ip-firewall-for-vlan=yes
/ip firewall connection tracking
set enabled=yes tcp-established-timeout=30m
/ip settings
set allow-fast-path=no
/interface detect-internet
set detect-interface-list=wan internet-interface-list=wan wan-interface-list=\
    wan
/interface l2tp-server server
set default-profile=default use-ipsec=yes
/interface list member
add interface=sfp-sfpplus1-SMI list=wan
/interface pppoe-server server
add authentication=pap disabled=no interface=vlan20-PPPoE keepalive-timeout=\
    20 max-mru=1492 max-mtu=1492 one-session-per-host=yes service-name=\
    "PPOE CLIENT VID 20"
/interface pptp-server server
set default-profile=default
/interface sstp-server server
set authentication=mschap2 certificate=vpn-server
/interface wireguard peers
add allowed-address=10.200.0.0/24 endpoint-address=43.173.14.236 \
    endpoint-port=51820 interface=wg-mikrotik-cib name=peer10 \
    persistent-keepalive=25s public-key=\
    "igk47cj+SnCDrtUyYWGORua21FI+cfqASQn84XWvYRs="
/ip address
add address=192.168.88.1/24 interface=ether13 network=192.168.88.0
add address=103.157.79.178/30 interface=sfp-sfpplus1-SMI network=\
    103.157.79.176
add address=192.168.50.1/24 interface=bridge-LAN network=192.168.50.0
add address=192.168.30.1/24 interface=vlan30-MGMT-OLT network=192.168.30.0
add address=192.168.10.106/30 interface=sfp-sfpplus1-SMI network=\
    192.168.10.104
add address=192.168.1.2/24 interface=ether12 network=192.168.1.0
add address=192.168.14.2/30 comment="SPEEDTEST SMI" interface=\
    sfp-sfpplus1-SMI network=192.168.14.0
add address=192.168.8.1/24 disabled=yes interface=vlan30-MGMT-OLT network=\
    192.168.8.0
add address=192.168.1.2/24 interface=ether11 network=192.168.1.0
add address=10.40.0.1/22 interface=vlan4000-tr069 network=10.40.0.0
add address=10.200.0.2 interface=wg-mikrotik-cib network=10.200.0.2
add address=10.40.10.1/24 comment="Gateway TR069" interface=vlan4000-tr069 \
    network=10.40.10.0
add address=10.50.10.1/24 comment="Gateway Hotspot VLAN 10" interface=\
    vlan10-hotspot network=10.50.10.0
/ip dhcp-server network
add address=10.40.10.0/24 comment="Network TR069 ACS Cibinong" dns-server=\
    1.1.1.1 gateway=10.40.10.1
add address=10.50.10.0/24 comment="DHCP Network Hotspot" dns-server=\
    10.50.10.1 gateway=10.50.10.1
add address=192.168.10.0/24 dns-server=8.8.8.8,1.1.1.1 gateway=192.168.10.1
add address=192.168.50.0/24 dns-server=1.1.1.1,1.0.0.1 gateway=192.168.50.1
/ip dns
set allow-remote-requests=yes cache-max-ttl=1d cache-size=65536KiB \
    max-concurrent-queries=1000 max-concurrent-tcp-sessions=100 servers=\
    1.1.1.1,1.0.0.1,8.8.8.8,8.8.4.4
/ip firewall address-list
add address=api.midtrans.com comment="EugineBill - Midtrans API" list=\
    payment-gateways
add address=app.midtrans.com comment="EugineBill - Midtrans Snap" list=\
    payment-gateways
add address=app.sandbox.midtrans.com comment="EugineBill - Midtrans Sandbox" \
    list=payment-gateways
add address=payment.midtrans.com comment="EugineBill - Midtrans Payment" \
    list=payment-gateways
add address=assets.midtrans.com comment=\
    "EugineBill - Midtrans Assets (JS/CSS)" list=payment-gateways
add address=api.xendit.co comment="EugineBill - Xendit API" list=\
    payment-gateways
add address=checkout.xendit.co comment="EugineBill - Xendit Checkout" list=\
    payment-gateways
add address=dashboard.xendit.co comment="EugineBill - Xendit Dashboard" list=\
    payment-gateways
add address=pay.xendit.co comment="EugineBill - Xendit Pay" list=\
    payment-gateways
add address=passport.duitku.com comment="EugineBill - Duitku API" list=\
    payment-gateways
add address=merchant.duitku.com comment="EugineBill - Duitku Merchant" list=\
    payment-gateways
add address=sandbox.duitku.com comment="EugineBill - Duitku Sandbox" list=\
    payment-gateways
add address=www.nicepay.co.id comment="EugineBill - Nicepay" list=\
    payment-gateways
add address=dev.nicepay.co.id comment="EugineBill - Nicepay Dev" list=\
    payment-gateways
add address=api.oyindonesia.com comment="EugineBill - OY! API" list=\
    payment-gateways
add address=pay.oyindonesia.com comment="EugineBill - OY! Pay" list=\
    payment-gateways
add address=api.flip.id comment="EugineBill - Flip API" list=payment-gateways
add address=flip.id comment="EugineBill - Flip" list=payment-gateways
add address=tripay.co.id comment="EugineBill - Tripay" list=payment-gateways
add address=payment.tripay.co.id comment="EugineBill - Tripay Payment" list=\
    payment-gateways
add address=my.ipaymu.com comment="EugineBill - iPaymu" list=payment-gateways
add address=payment.ipaymu.com comment="EugineBill - iPaymu Payment" list=\
    payment-gateways
add address=api.gojek.com comment="EugineBill - Gojek API" list=\
    payment-gateways
add address=gopay.co.id comment="EugineBill - GoPay" list=payment-gateways
add address=payment.gojek.com comment="EugineBill - Gojek Payment" list=\
    payment-gateways
add address=api.dana.id comment="EugineBill - DANA API" list=payment-gateways
add address=m.dana.id comment="EugineBill - DANA Mobile" list=\
    payment-gateways
add address=checkout.dana.id comment="EugineBill - DANA Checkout" list=\
    payment-gateways
add address=api.ovo.id comment="EugineBill - OVO API" list=payment-gateways
add address=checkout.ovo.id comment="EugineBill - OVO Checkout" list=\
    payment-gateways
add address=open-api.airpay.co.id comment="EugineBill - ShopeePay API" list=\
    payment-gateways
add address=open-api.pay.shopee.co.id comment="EugineBill - ShopeePay" list=\
    payment-gateways
add address=p2p.klikbca.com comment="EugineBill - BCA KlikBCA" list=\
    payment-gateways
add address=partner.bri.co.id comment="EugineBill - BRI Partner API" list=\
    payment-gateways
add address=qris.id comment="EugineBill - QRIS" list=payment-gateways
add address=api.qris.id comment="EugineBill - QRIS API" list=payment-gateways
add address=qrin.web.id comment="EugineBill - QRIN Web" list=payment-gateways
add address=api.qrin.web.id comment="EugineBill - QRIN API" list=\
    payment-gateways
add address=qrin.id comment="EugineBill - QRIN Domain" list=payment-gateways
/ip firewall filter
add action=passthrough chain=unused-hs-chain comment=\
    "place hotspot rules here" disabled=yes
add action=accept chain=input comment="1. Accept Established/Related" \
    connection-state=established,related
add action=accept chain=input comment="Accept Established/Related" \
    connection-state=established,related
add action=accept chain=input comment="2. Accept ICMP/Ping" protocol=icmp
add action=accept chain=forward comment=\
    "EugineBill - Allow established/related for isolated users" \
    connection-state=established,related src-address-list=isolir
add action=drop chain=input comment="3. Block DNS UDP from WAN SMI" dst-port=\
    53 in-interface=sfp-sfpplus1-SMI protocol=udp
add action=accept chain=input comment="Accept ICMP/Ping" protocol=icmp
add action=drop chain=input comment="4. Block DNS TCP from WAN SMI" dst-port=\
    53 in-interface=sfp-sfpplus1-SMI protocol=tcp
add action=accept chain=forward comment=\
    "EugineBill - Allow return traffic to isolated users" connection-state=\
    established,related dst-address-list=isolir
add action=accept chain=forward comment=\
    "EugineBill - Allow DNS for isolated users" dst-port=53 protocol=udp \
    src-address-list=isolir
add action=accept chain=forward comment=\
    "EugineBill - Allow ping for isolated users" protocol=icmp \
    src-address-list=isolir
add action=accept chain=forward comment=\
    "EugineBill - Allow access to billing server" dst-address=43.173.14.236 \
    src-address-list=isolir
add action=accept chain=forward comment=\
    "EugineBill - Allow access to payment gateways" dst-address-list=\
    payment-gateways src-address-list=isolir
add action=drop chain=forward comment=\
    "EugineBill - Block internet for isolated users" src-address-list=isolir
add action=accept chain=input comment="EugineBill-RADIUS CoA from 10.200.0.1" \
    dst-port=3799 protocol=udp src-address=10.200.0.1
add action=accept chain=input comment=\
    "EugineBill-RADIUS CoA via gateway 10.200.0.1" dst-port=3799 protocol=udp \
    src-address=10.200.0.1
add action=accept chain=input comment=\
    "EugineBill-RADIUS Auth/Acct from 10.200.0.1" dst-port=1812,1813 \
    protocol=udp src-address=10.200.0.1
/ip firewall mangle
add action=change-mss chain=forward new-mss=clamp-to-pmtu passthrough=yes \
    protocol=tcp tcp-flags=syn
add action=mark-connection chain=prerouting comment=MLBB dst-port="5000-5221,5\
    224-5227,5229-5241,5243-5508,5551-5559,5601-5700,9000-9010,9443" \
    new-connection-mark=pkg-game passthrough=yes protocol=tcp
add action=mark-connection chain=prerouting dst-port=\
    5520-5529,10003,30000-30300 new-connection-mark=pkg-game passthrough=yes \
    protocol=tcp
add action=mark-connection chain=prerouting dst-port=\
    4001-4009,5000-5221,5224-5241,5243-5509,5551-5559,5601-5700,8130,9120 \
    new-connection-mark=pkg-game passthrough=yes protocol=udp
add action=mark-connection chain=prerouting dst-port=\
    2702,3702,5517,5520-5529,9000-9010,9992,10003,30000-30300 \
    new-connection-mark=pkg-game passthrough=yes protocol=udp
add action=mark-connection chain=prerouting comment=PUBGMobile dst-port=\
    7889,10012,13004,14000,17000,17500,18081,20000-20002,20371 \
    new-connection-mark=pkg-game passthrough=yes protocol=tcp
add action=mark-connection chain=prerouting dst-port=\
    8011,9030,10491,10612,12235,13004,13748,17000,17500,20000-20002 \
    new-connection-mark=pkg-game passthrough=yes protocol=udp
add action=mark-connection chain=prerouting dst-port=\
    7086-7995,10039,10096,11455,12070-12460,13894,13972,41182-41192 \
    new-connection-mark=pkg-game passthrough=yes protocol=udp
add action=mark-packet chain=forward connection-mark=pkg-game \
    new-packet-mark=paket-game passthrough=no
/ip firewall nat
add action=passthrough chain=unused-hs-chain comment=\
    "place hotspot rules here" disabled=yes
add action=masquerade chain=srcnat comment="JANGAN PERNAH HAPUS" \
    out-interface=sfp-sfpplus1-SMI
add action=dst-nat chain=dstnat comment=HSGQ dst-address=103.157.79.178 \
    dst-port=8229 protocol=tcp to-addresses=192.168.30.2
add action=dst-nat chain=dstnat comment=VSOL dst-address=103.157.79.178 \
    dst-port=8003 protocol=tcp to-addresses=192.168.30.6 to-ports=8003
add action=dst-nat chain=dstnat comment="VSOL V1600GT" dst-address=\
    103.157.79.178 dst-port=8004 protocol=tcp to-addresses=192.168.30.7 \
    to-ports=8004
add action=dst-nat chain=dstnat comment="HSGQ SNMP" dst-address=\
    103.157.79.178 dst-port=1611 protocol=udp to-addresses=192.168.30.2 \
    to-ports=161
add action=dst-nat chain=dstnat comment="VSOL SNMP" dst-address=\
    103.157.79.178 dst-port=1614 protocol=udp to-addresses=192.168.30.6 \
    to-ports=161
add action=dst-nat chain=dstnat comment="VSOL V1600GT SNMP" dst-address=\
    103.157.79.178 dst-port=1615 protocol=udp to-addresses=192.168.30.7 \
    to-ports=1615
add action=dst-nat chain=dstnat comment=\
    "EugineBill - Redirect HTTP to isolation page" dst-address=!43.173.14.236 \
    dst-address-list=!payment-gateways dst-port=80 protocol=tcp \
    src-address-list=isolir to-addresses=43.173.14.236 to-ports=80
add action=dst-nat chain=dstnat comment=\
    "EugineBill - Redirect HTTPS to isolation page" dst-address=\
    !43.173.14.236 dst-address-list=!payment-gateways dst-port=443 protocol=\
    tcp src-address-list=isolir to-addresses=43.173.14.236 to-ports=443
add action=masquerade chain=srcnat comment=\
    "TR-069 SRCNAT MASQUERADE CIBINONG" src-address=10.40.0.0/22
add action=masquerade chain=srcnat comment="NAT Hotspot VLAN 10" src-address=\
    10.50.10.0/24
add action=dst-nat chain=dstnat comment=TEMP_TELNET_OLT dst-port=8223 \
    protocol=tcp to-addresses=192.168.30.2 to-ports=23
add action=dst-nat chain=dstnat comment=REMOTE-ZTE-MODEM dst-address=\
    192.168.50.1 dst-port=8088 protocol=tcp to-addresses=10.40.10.59 \
    to-ports=80
add action=masquerade chain=srcnat comment=REMOTE-ZTE-MODEM-SRCNAT \
    dst-address=10.40.10.59
/ip hotspot
add address-pool=dhcp_pool0 interface=bridge-LAN name=hotspot-bridge profile=\
    *2
/ip hotspot user
add comment=EugineBill:BATCH-1788780152877 limit-uptime=10m name=BASLYJ \
    profile=EugineBillradius
add comment=EugineBill:BATCH-1788780362116 limit-uptime=1h name=APKMSJ \
    profile=EugineBillradius
add comment=EugineBill:BATCH-1788780411764 limit-uptime=1h name=EYPNXK \
    profile=EugineBillradius
/ip hotspot walled-garden
add comment=EugineBill dst-host=*.euginemediagroup.com
add comment=EugineBill dst-host=euginemediagroup.com
add comment=Midtrans dst-host=*.midtrans.com
add comment=Tripay dst-host=*.tripay.co.id
add comment=Xendit dst-host=*.xendit.co
add comment="EugineBill Walled Garden" dst-host=*.duitku.com
add comment="EugineBill Walled Garden" dst-host=*.nicepay.co.id
add comment="EugineBill Walled Garden" dst-host=*.oyindonesia.com
add comment="EugineBill Walled Garden" dst-host=*.flip.id
add comment="EugineBill Walled Garden" dst-host=*.ipaymu.com
add comment="EugineBill Walled Garden" dst-host=*.gojek.com
add comment="EugineBill Walled Garden" dst-host=*.gopay.co.id
add comment="EugineBill Walled Garden" dst-host=*.dana.id
add comment="EugineBill Walled Garden" dst-host=*.ovo.id
add comment="EugineBill Walled Garden" dst-host=*.airpay.co.id
add comment="EugineBill Walled Garden" dst-host=*.shopee.co.id
add comment="EugineBill Walled Garden" dst-host=*.klikbca.com
add comment="EugineBill Walled Garden" dst-host=*.bri.co.id
add comment="EugineBill Walled Garden" dst-host=*.qris.id
add comment="EugineBill Walled Garden" dst-host=*.qrin.id
add comment="EugineBill Walled Garden" dst-host=*.qrin.web.id
/ip route
add check-gateway=ping disabled=no distance=1 dst-address=0.0.0.0/0 gateway=\
    103.157.79.177 routing-table=main scope=30 suppress-hw-offload=no \
    target-scope=10
add comment="static route topsetting-vpn" disabled=yes dst-address=\
    172.23.64.1 gateway=*1D routing-table=TOPSETTING-VPN
add disabled=no distance=2 dst-address=0.0.0.0/0 gateway=192.168.1.1 \
    routing-table=main suppress-hw-offload=no
add comment="Nottik WG server route" dst-address=10.22.0.1/32 gateway=*16
add comment="ROUTE ONT REMOTE CITEUREUP" disabled=no dst-address=\
    172.168.20.0/24 gateway=10.20.20.2 routing-table=main \
    suppress-hw-offload=no
add comment=EugineBill-VPN dst-address=10.200.0.0/24 gateway=wg-mikrotik-cib
/ip service
set telnet disabled=yes
set ftp disabled=yes
set ssh disabled=yes
set www-ssl disabled=no
set api address=0.0.0.0/0 port=8520
set winbox port=8228
set api-ssl address=0.0.0.0/0 port=8815
/ppp aaa
set accounting=no interim-update=5m
/radius
add address=10.200.0.1 comment="EugineBill RADIUS - Auto Setup" disabled=yes \
    require-message-auth=no service=hotspot src-address=10.200.0.2 timeout=3s
add address=10.200.0.1 comment="CoA from VPS via gateway masquerade" \
    disabled=yes require-message-auth=no service=hotspot src-address=\
    10.200.0.2 timeout=1s100ms
/radius incoming
set accept=yes
/routing rule
add action=lookup-only-in-table comment="static route topsetting-vpn" \
    dst-address=172.23.64.1 table=TOPSETTING-VPN
/system clock
set time-zone-name=Asia/Jakarta
/system identity
set name=RO-EugineMedia
/system note
set show-at-login=no
/system routerboard settings
set enter-setup-on=delete-key
/system scheduler
add interval=1d name="BERSIH-BERSIH -SUBUH" on-event="CLEAR TRASH" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=2026-03-28 start-time=03:00:00
/system script
add dont-require-permissions=no name="CLEAR TRASH" owner=euginemedia policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source="/\
    ip dns cache flush\r\
    \n/system logging action set memory memory-lines=1\r\
    \n/system logging action set memory memory-lines=1000\r\
    \n:log info \"Maintenance Rutin: DNS Cache dan Log berhasil dibersihkan.\"\
    "
/tool graphing interface
add
/tool graphing queue
add
/tool graphing resource
add
/tool netwatch
add comment="EugineBill RADIUS Monitor" down-script="/log warning message=\"Eu\
    gineBill: RADIUS server 10.200.0.1 tidak reachable\"" host=10.200.0.1 \
    interval=30s timeout=5s type=simple up-script="/log info message=\"EugineB\
    ill: RADIUS server 10.200.0.1 kembali online\""
/tool sniffer
set filter-interface=vlan10-hotspot filter-vlan=20
/user group
add comment="Limited API Access Group" name=api-users policy="local,ssh,read,w\
    rite,policy,test,winbox,password,web,sensitive,api,!telnet,!ftp,!reboot,!s\
    niff,!romon,!rest-api"
