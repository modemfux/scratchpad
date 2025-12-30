# New loopback interface

[**Назад**](/README.md)

Источник: <https://habr.com/ru/articles/884824/>

```bash
ip link add name lo1 type dummy
ip link set dev lo1 up
sysctl -w net.mpls.conf.lo1.input=1
```

`sysctl -w net.mpls.conf.lo1.input=1` - включаем поддержку MPLS-пакетов на интерфейсе.
