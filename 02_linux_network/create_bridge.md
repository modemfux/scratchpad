# Bridge config

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
