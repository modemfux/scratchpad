# MPLS

[**Назад**](/README.md)

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
