# LLDP

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
