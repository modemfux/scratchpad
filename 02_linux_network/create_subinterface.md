# Create dot1q subinterface

[**Назад**](/README.md)

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
