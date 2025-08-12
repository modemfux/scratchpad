# Various linux memoes

## Base Linux

### Изменить hostname

```linux
sudo hostnamectl hostname FRR
```

### Разрешаем SUDO без пароля

В sudoers (через `sudo visudo`) в конце добавляем строчку вида `$USERNAME ALL=(ALL) NOPASSWD: ALL`. В итоге выглядеть будет как-то так:

```linux
modemfux@docker-vm-nb:/etc$ sudo cat sudoers
#
# This file MUST be edited with the 'visudo' command as root.
#
# Please consider adding local content in /etc/sudoers.d/ instead of
# directly modifying this file.
#
# See the man page for details on how to write a sudoers file.
#
Defaults        env_reset
Defaults        mail_badpass
Defaults        secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin"

# This fixes CVE-2005-4890 and possibly breaks some versions of kdesu
# (#1011624, https://bugs.kde.org/show_bug.cgi?id=452532)
Defaults        use_pty

# This preserves proxy settings from user environments of root
# equivalent users (group sudo)
#Defaults:%sudo env_keep += "http_proxy https_proxy ftp_proxy all_proxy no_proxy"

# This allows running arbitrary commands, but so does ALL, and it means
# different sudoers have their choice of editor respected.
#Defaults:%sudo env_keep += "EDITOR"

# Completely harmless preservation of a user preference.
#Defaults:%sudo env_keep += "GREP_COLOR"

# While you shouldn't normally run git as root, you need to with etckeeper
#Defaults:%sudo env_keep += "GIT_AUTHOR_* GIT_COMMITTER_*"

# Per-user preferences; root won't have sensible values for them.
#Defaults:%sudo env_keep += "EMAIL DEBEMAIL DEBFULLNAME"

# "sudo scp" or "sudo rsync" should be able to use your SSH agent.
#Defaults:%sudo env_keep += "SSH_AGENT_PID SSH_AUTH_SOCK"

# Ditto for GPG agent
#Defaults:%sudo env_keep += "GPG_AGENT_INFO"

# Host alias specification

# User alias specification

# Cmnd alias specification

# User privilege specification
root    ALL=(ALL:ALL) ALL

# Members of the admin group may gain root privileges
%admin ALL=(ALL) ALL

# Allow members of group sudo to execute any command
%sudo   ALL=(ALL:ALL) ALL

# See sudoers(5) for more information on "@include" directives:
modemfux ALL=(ALL) NOPASSWD: ALL # <==== Добавил это

@includedir /etc/sudoers.d
modemfux@docker-vm-nb:/etc$
```

Добавлять нужно в конце, а не в "блоке" User privilege specification, т.к. иначе последующие инструкции затрут внесенные изменения.

### Изменить редактор по умолчанию

```linux
modemfux@docker-vm-nb:~$ sudo update-alternatives --config editor
There are 4 choices for the alternative editor (providing /usr/bin/editor).

  Selection    Path                Priority   Status
------------------------------------------------------------
  0            /bin/nano            40        auto mode
  1            /bin/ed             -100       manual mode
  2            /bin/nano            40        manual mode
* 3            /usr/bin/vim.basic   30        manual mode
  4            /usr/bin/vim.tiny    15        manual mode

Press <enter> to keep the current choice[*], or type selection number: 3
modemfux@docker-vm-nb:~$
```

## Network config

### Create dot1q subinterface

```linux
ip link add link eth7 name eth7.100 type vlan id 100
ip link set dev eth7 up
ip link set dev eth7.100 up
```

Часть взята отсюда: [https://habr.com/ru/articles/884824/](https://habr.com/ru/articles/884824/)

### Bridge config

```linux
brctl addbr Bridge1
brctl addif Bridge1 ens4
brctl addif Bridge1 ens5
ip link set up ens4
ip link set up ens5
ip link set up dev Bridge1
```

### VLAN config

```linux
# Тут подымем пару интерфейсов типа влан и повесим адреса
ip link add link ens4 name SVI10 type vlan id 10
ip link add link ens4 name SVI20 type vlan id 20
ip link set up ens4
ip addr add 192.168.0.254/24 dev SVI10
ip addr add 172.16.0.254/24 dev SVI20
```

### MPLS

```linux
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

### VRF

```linux
# Делаем vrf и привязываем его к выделенной таблице маршрутизации
sudo ip link add vrf-Red type vrf table 1001
sudo ip link set dev vrf-Red up

# Запихиваем наш интерфейс в этот vrf, включаем его и вешаем адрес
sudo ip link set dev ens6  master vrf-Red
sudo ip addr add 192.168.0.254/24 dev ens6
sudo ip link set dev ens6 up
```

### New Loopback interface

```linux
ip link add name lo1 type dummy
ip link set dev lo1 up
sysctl -w net.mpls.conf.lo1.input=1
```

### VxLAN

```linux
modprobe vxlan
modprobe ip6_udp_tunnel
modprobe udp_tunnel
```

### Ubuntu Netplan

Заходим в папку netplan (`/etc/netplan`)

```linux
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

```linux
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

### Изменить наименование сетевых интерфейсов

```linux
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

```linux
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

```linux
modemfux@docker-vm-nb:~$ ip link show eth0
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DEFAULT group default qlen 1000
    link/ether 00:0c:29:df:eb:8b brd ff:ff:ff:ff:ff:ff
    altname enp2s1
    altname ens33
```

Но, все же, лучше поправить конфиг в netplan:

```linux
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

### Включить обработку входящих пакетов для VRF

```linux
sudo echo "" >> /etc/sysctl.conf
sudo echo "net.ipv4.tcp_l3mdev_accept=1" >> /etc/sysctl.conf
sudo echo "net.ipv4.udp_l3mdev_accept=1" >> /etc/sysctl.conf
```

### LLDP

Установка и добавление в автозагрузку:

```linux
apt update && apt install lldpd -y
systemctl start lldpd
systemctl enable lldpd
```

По умолчанию вместо имени интерфейса lldpd отдает MAC-адрес. Чтобы исправить это, нужно в `/etc/lldpd.d` создать conf-файл и добавить следующее:

```linux
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
