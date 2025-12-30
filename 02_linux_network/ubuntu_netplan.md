# Ubuntu Netplan

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
