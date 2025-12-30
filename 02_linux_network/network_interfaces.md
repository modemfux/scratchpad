# network.interfaces - Debian / Alpine interfaces

[**Назад**](/README.md)

Пример из лабы:

```bash
FRR-R5:~# cat /etc/network/interfaces
#
# This is a sample network config, uncomment lines to configure the network
#
# Loopback interface
auto lo
iface lo inet loopback
auto DUT1
iface DUT1 inet manual
        pre-up ip link add DUT1 type vrf table 1001
        up ip link set dev DUT1 up
auto DUT2
iface DUT2
        pre-up ip link add DUT2 type vrf table 1002
        up ip link set dev DUT2 up
auto DUT3
iface DUT3
        pre-up ip link add DUT3 type vrf table 1003
        up ip link set dev DUT3 up
auto eth1 inet static
        address 172.16.15.5/24
        pre-up ip link set eth1 master DUT1
auto eth2 inet static
        address 172.16.25.5/24
        pre-up ip link set eth2 master DUT2
auto eth3 inet static
        address 172.16.35.5/24
        pre-up ip link set eth3 master DUT3
auto Loopback105
iface Loopback105 inet manual
        pre-up ip link add Loopback105 type dummy
        pre-up ip link set Loopback105 master DUT1
        address 172.21.255.105/32
auto Loopback115
iface Loopback115 inet manual
        pre-up ip link add Loopback115 type dummy
        pre-up ip link set Loopback115 master DUT1
        address 172.21.255.115/32
auto Loopback125
iface Loopback125 inet manual
        pre-up ip link add Loopback125 type dummy
        pre-up ip link set Loopback125 master DUT1
        address 172.21.255.125/32
auto Loopback205
iface Loopback205 inet manual
        pre-up ip link add Loopback205 type dummy
        pre-up ip link set Loopback205 master DUT2
        address 172.21.255.205/32
auto Loopback215
iface Loopback215 inet manual
        pre-up ip link add Loopback215 type dummy
        pre-up ip link set Loopback215 master DUT2
        address 172.21.255.215/32
auto Loopback225
iface Loopback225 inet manual
        pre-up ip link add Loopback225 type dummy
        pre-up ip link set Loopback225 master DUT2
        address 172.21.255.225/32
auto Loopback305
iface Loopback305 inet manual
        pre-up ip link add Loopback305 type dummy
        pre-up ip link set Loopback305 master DUT3
        address 172.21.255.5/32
auto Loopback315
iface Loopback315 inet manual
        pre-up ip link add Loopback315 type dummy
        pre-up ip link set Loopback315 master DUT3
        address 172.21.255.15/32
auto Loopback325
iface Loopback325 inet manual
        pre-up ip link add Loopback325 type dummy
        pre-up ip link set Loopback325 master DUT3
        address 172.21.255.25/32
```
