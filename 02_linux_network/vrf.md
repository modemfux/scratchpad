# VRF

[**Назад**](/README.md)

## Создание VRF в iproute2

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

## Включить обработку входящих пакетов для VRF

```bash
sudo echo "" >> /etc/sysctl.conf
sudo echo "net.ipv4.tcp_l3mdev_accept=1" >> /etc/sysctl.conf
sudo echo "net.ipv4.udp_l3mdev_accept=1" >> /etc/sysctl.conf
```

В качестве альтернативы, echo можно заменить на прямые запросы через `sysctl -w`.

## Debian / Alpine interfaces - автосоздание VRF

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
