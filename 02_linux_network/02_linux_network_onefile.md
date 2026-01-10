# Linux network

- [Linux network](#linux-network)
  - [Bridge config](#bridge-config)
  - [New loopback interface](#new-loopback-interface)
  - [Create dot1q subinterface](#create-dot1q-subinterface)
  - [MPLS](#mpls)
  - [VxLAN](#vxlan)
  - [Изменить наименование сетевых интерфейсов](#изменить-наименование-сетевых-интерфейсов)
  - [LLDP](#lldp)
  - [network.interfaces - Debian / Alpine interfaces](#networkinterfaces---debian--alpine-interfaces)
  - [Ubuntu Netplan](#ubuntu-netplan)
  - [VRF](#vrf)
    - [Создание VRF в iproute2](#создание-vrf-в-iproute2)
    - [Включить обработку входящих пакетов для VRF](#включить-обработку-входящих-пакетов-для-vrf)
    - [Debian / Alpine interfaces - автосоздание VRF](#debian--alpine-interfaces---автосоздание-vrf)

## Bridge config

Источник: <https://habr.com/ru/articles/884824/>

```bash
apt install bridge-utils
# brctl из bridge-utils
brctl addbr Bridge1
brctl addif Bridge1 ens4
brctl addif Bridge1 ens5
ip link set up ens4
ip link set up ens5
ip link set up dev Bridge1
```

---

## New loopback interface

Источник: <https://habr.com/ru/articles/884824/>

```bash
ip link add name lo1 type dummy
ip link set dev lo1 up
sysctl -w net.mpls.conf.lo1.input=1
```

`sysctl -w net.mpls.conf.lo1.input=1` - включаем поддержку MPLS-пакетов на интерфейсе.

---

## Create dot1q subinterface

```linux
ip link add link eth7 name eth7.100 type vlan id 100
ip link set dev eth7 up
ip link set dev eth7.100 up
```

Разбор команды `ip link add link eth7 name eth7.100 type vlan id 100`

`ip link` - основная "ветка" для добавления "интерфейсов" в iproute2.
`add` - добавляем новый интерфейс
`link eth7` - основным интерфейсом будет eth7
`name eth7.100` - имя нового интерфейса (может быть практически любым)
`type vlan` - тип нового интерфейса - vlan (dot1q)
`id 100` - vlan-id == 100

---

## MPLS

Источник: <https://habr.com/ru/articles/884824/>

```bash
# Включаем опции ядра
modprobe mpls_router
modprobe mpls_iptunnel
modprobe mpls_gso
# Включаем обработку MPLS меток на интерфейсах:
sysctl -w net.mpls.conf.ens4.input=1
sysctl -w net.mpls.conf.ens5.input=1
sysctl -w net.mpls.conf.ens6.input=1
# Сколько меток сможем использовать. Мильёна должно хватить сегодня
sysctl -w net.mpls.platform_labels=1048575
```

---

## VxLAN

Источник: <https://habr.com/ru/articles/884824/>

Включение поддержки VxLAN на уровне ядра:

```bash
modprobe vxlan
modprobe ip6_udp_tunnel
modprobe udp_tunnel
```

---

## Изменить наименование сетевых интерфейсов

```bash
modemfux@docker-vm-nb:/etc/netplan$ ip -br -c l
lo               UNKNOWN        00:00:00:00:00:00 <LOOPBACK,UP,LOWER_UP>
ens33            UP             00:0c:29:df:eb:8b <BROADCAST,MULTICAST,UP,LOWER_UP>
docker0          DOWN           ba:41:ee:f2:fd:35 <NO-CARRIER,BROADCAST,MULTICAST,UP>
modemfux@docker-vm-nb:/etc/netplan$ sudo sed -i 's/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="net.ifnames=0 biosdevname=0"/' /etc/default/grub
modemfux@docker-vm-nb:/etc/netplan$ sudo update-grub
Sourcing file `/etc/default/grub'
Generating grub configuration file ...
Found linux image: /boot/vmlinuz-6.8.0-58-generic
Found initrd image: /boot/initrd.img-6.8.0-58-generic
Found linux image: /boot/vmlinuz-6.8.0-56-generic
Found initrd image: /boot/initrd.img-6.8.0-56-generic
Warning: os-prober will not be executed to detect other bootable partitions.
Systems on them will not be added to the GRUB boot configuration.
Check GRUB_DISABLE_OS_PROBER documentation entry.
Adding boot menu entry for UEFI Firmware Settings ...
done
modemfux@docker-vm-nb:/etc/netplan$sudo reboot
```

После перезагрузки:

```bash
modemfux@docker-vm-nb:~$ ip -br -c l
lo               UNKNOWN        00:00:00:00:00:00 <LOOPBACK,UP,LOWER_UP>
eth0             UP             00:0c:29:df:eb:8b <BROADCAST,MULTICAST,UP,LOWER_UP>
docker0          DOWN           aa:f3:45:ce:f0:5c <NO-CARRIER,BROADCAST,MULTICAST,UP>
modemfux@docker-vm-nb:~$ ip -br -c a
lo               UNKNOWN        127.0.0.1/8 ::1/128
eth0             UP             10.250.254.111/24 fe80::20c:29ff:fedf:eb8b/64
docker0          DOWN           172.17.0.1/16
modemfux@docker-vm-nb:~$
```

Адрес сохранился, т.к. остались "псевдонимы" для интерфейса:

```bash
modemfux@docker-vm-nb:~$ ip link show eth0
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DEFAULT group default qlen 1000
    link/ether 00:0c:29:df:eb:8b brd ff:ff:ff:ff:ff:ff
    altname enp2s1
    altname ens33
```

Но, все же, лучше поправить конфиг в netplan:

```bash
modemfux@docker-vm-nb:~$ sudo sed -i 's/ens33/eth0/' /etc/netplan/50-cloud-init.yaml
modemfux@docker-vm-nb:~$ sudo cat /etc/netplan/50-cloud-init.yaml
network:
  version: 2
  ethernets:
    eth0:
      addresses:
      - "10.250.254.111/24"
      nameservers:
        addresses:
        - 10.250.137.2
        - 8.8.8.8
        - 1.1.1.1
        search: []
      routes:
      - to: "default"
        via: "10.250.254.1"
modemfux@docker-vm-nb:~$ sudo netplan apply
modemfux@docker-vm-nb:~$ ip -br -c a
lo               UNKNOWN        127.0.0.1/8 ::1/128
eth0             UP             10.250.254.111/24 fe80::20c:29ff:fedf:eb8b/64
docker0          DOWN           172.17.0.1/16
modemfux@docker-vm-nb:~$
```

---

## LLDP

Установка и добавление в автозагрузку:

```bash
apt update && apt install lldpd -y
systemctl start lldpd
systemctl enable lldpd
```

По умолчанию вместо имени интерфейса lldpd отдает MAC-адрес. Чтобы исправить это, нужно в `/etc/lldpd.d` создать conf-файл и добавить следующее:

```bash
root@proxmox:~# cd /etc/lldpd.d/
root@proxmox:/etc/lldpd.d# ll
total 12
drwxr-xr-x  2 root root 4096 May  2 08:46 ./
drwxr-xr-x 94 root root 4096 May  2 08:37 ../
-rw-r--r--  1 root root  342 Sep 22  2023 README.conf
root@proxmox:/etc/lldpd.d# touch lldpd_modified.conf
root@proxmox:/etc/lldpd.d# echo "config lldp portidsubtype ifname" > lldpd_modified.conf
root@proxmox:/etc/lldpd.d# systemctl restart lldpd.service
root@proxmox:/etc/lldpd.d#
```

```huawei
<nn-van28a-r01>dis lldp ne br
Local Intf   Neighbor Dev             Neighbor Intf             Exptime
GE0/0/0      proxmox.local            enp1s0                    120
GE0/0/2      -                        d493-9020-15b1            3050
<nn-van28a-r01>
```

## network.interfaces - Debian / Alpine interfaces

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

---

## Ubuntu Netplan

Заходим в папку netplan (`/etc/netplan`)

```bash
frruser@FRR:~$ cd /etc/netplan/
frruser@FRR:/etc/netplan$ ls -la
total 20
drwxr-xr-x   2 root root  4096 May  1 08:14 .
drwxr-xr-x 119 root root 12288 Apr 25 19:20 ..
-rw-------   1 root root   399 Apr 15 17:32 50-cloud-init.yaml
frruser@FRR:/etc/netplan$
```

```yaml
frruser@FRR:/etc/netplan$ sudo cat 50-cloud-init.yaml
network:                       # 
  version: 2                   # 
  ethernets:                   # 
    eth0:                      # Имя интерфейса
      dhcp4: false             # Получение IPv4-адреса по DHCP
      optional: true           # Опциональность. необходимо, чтобы в случае отсутствия каких-либо настроек или невозможности получить адрес по DHCP, загрузка ОС не стопорилась
      addresses:               # 
        - 10.250.253.81/24     # Статический IPv4-адрес
      routes:                  # Статические маршруты
        - to: 10.250.252.0/22  # 
          via: 10.250.253.1    # 
        - to: default          # 
          via: 10.250.253.1    # 
      nameservers:             # Настройка DNS
        addresses:             # 
          - 8.8.8.8            # 
  vrfs:                        # Секция VRF
    MGMT:                      # Название отдельного инстанса VRF
      table: 10                # номер таблицы маршрутизации для vrf
      optional: true           # 
      interfaces:              # Привязка интерфейса
        - eth0                 # 
```

После изменения используем apply:

```bash
frruser@FRR:/etc/netplan$ sudo cp 50-cloud-init.yaml 50-cloud-init.yaml.backup
frruser@FRR:/etc/netplan$ sudo vim 50-cloud-init.yaml
frruser@FRR:/etc/netplan$ sudo diff -y 50-cloud-init.yaml 50-cloud-init.yaml.backup
network:                                                        network:
  version: 2                                                      version: 2
  ethernets:                                                      ethernets:
    lo:                                                       <
      addresses:                                              <
        - 1.1.1.1/32                                          <
    eth0:                                                           eth0:
      dhcp4: false                                                    dhcp4: false
      optional: true                                                  optional: true
      addresses:                                                      addresses:
        - 10.250.253.81/24                                              - 10.250.253.81/24
      routes:                                                         routes:
        - to: 10.250.252.0/22                                           - to: 10.250.252.0/22
          via: 10.250.253.1                                               via: 10.250.253.1
        - to: default                                                   - to: default
          via: 10.250.253.1                                               via: 10.250.253.1
      nameservers:                                                    nameservers:
        addresses:                                                      addresses:
          - 8.8.8.8                                                       - 8.8.8.8
  vrfs:                                                           vrfs:
    MGMT:                                                           MGMT:
      table: 10                                                       table: 10
      optional: true                                                  optional: true
      interfaces:                                                     interfaces:
        - eth0                                                          - eth0

frruser@FRR:/etc/netplan$ ip -br -c a
lo               UNKNOWN        127.0.0.1/8 ::1/128
eth0             UP             10.250.253.81/24 fe80::250:ff:fe00:400/64
eth1             DOWN
eth2             DOWN
eth3             DOWN
eth4             DOWN
MGMT             UP
pimreg@NONE      UNKNOWN
pimreg10@NONE    UNKNOWN
frruser@FRR:/etc/netplan$ sudo netplan apply
frruser@FRR:/etc/netplan$ ip -br -c a
lo               UNKNOWN        127.0.0.1/8 1.1.1.1/32 ::1/128
eth0             UP             10.250.253.81/24 fe80::250:ff:fe00:400/64
eth1             DOWN
eth2             DOWN
eth3             DOWN
eth4             DOWN
MGMT             UP
pimreg@NONE      UNKNOWN
pimreg10@NONE    UNKNOWN
frruser@FRR:/etc/netplan$
```

---

## VRF

### Создание VRF в iproute2

Источник: <https://habr.com/ru/articles/884824/>

```bash
# Делаем vrf и привязываем его к выделенной таблице маршрутизации
sudo ip link add vrf-Red type vrf table 1001
sudo ip link set dev vrf-Red up

# Запихиваем наш интерфейс в этот vrf, включаем его и вешаем адрес
sudo ip link set dev ens6  master vrf-Red
sudo ip addr add 192.168.0.254/24 dev ens6
sudo ip link set dev ens6 up
```

### Включить обработку входящих пакетов для VRF

```bash
sudo echo "" >> /etc/sysctl.conf
sudo echo "net.ipv4.tcp_l3mdev_accept=1" >> /etc/sysctl.conf
sudo echo "net.ipv4.udp_l3mdev_accept=1" >> /etc/sysctl.conf
```

В качестве альтернативы, echo можно заменить на прямые запросы через `sysctl -w`.

### Debian / Alpine interfaces - автосоздание VRF

```bash
auto DUT1
iface DUT1 inet manual
        pre-up ip link add DUT1 type vrf table 1001
        up ip link set dev DUT1 up
```

Здесь:

- `auto DUT1` - инструкция, что это срабатывает автоматически.
- `iface DUT1 inet manual` - настройки в ручном режиме (расположены ниже).
- `pre-up ip link add DUT1 type vrf table 1001` - предварительная команда (pre-up): создает vrf DUT1 и привязывает его к таблице 1001.
- `up ip link set dev DUT1 up` - основная команда (up): переводит интерфейс vrf DUT1 в статус `up`.

```bash
auto eth1 inet static
        address 172.16.15.5/24
        pre-up ip link set eth1 master DUT1
```

Здесь:

- `auto eth1 inet static`: автоматическая настройка интерфейса eth1 настройками ниже.
- `address 172.16.15.5/24`: задание IPv4-адреса.
- `pre-up ip link set eth1 master DUT1` - привязка к vrf DUT1

```bash
auto Loopback105
iface Loopback105 inet manual
        pre-up ip link add Loopback105 type dummy
        pre-up ip link set Loopback105 master DUT1
        address 172.21.255.105/32
```

Здесь:

- `auto Loopback105`: инструкция, что это срабатывает автоматически.
- `iface Loopback105 inet manual`: настройки в ручном режиме (расположены ниже).
- `pre-up ip link add Loopback105 type dummy`: предварительное создание линка типа `dummy`
- `pre-up ip link set Loopback105 master DUT1`: предварительная привязка созданного линка к vrf
- `address 172.21.255.105/32`: настройка IPv4-адреса.
