# Изменить наименование сетевых интерфейсов

[**Назад**](/README.md)

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
