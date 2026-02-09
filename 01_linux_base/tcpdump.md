# tcpdump

[**Назад**](/README.md)

***tcpdump*** - утилита, позволяющая захватывать сетевой трафик с интерфейсов.

Запускается через sudo или root'ом.

## Ограничения по захвату

```bash
sudo tcpdump -w sample_file_Ethernet0.pcap -G 60 -W 1 -i Ethernet0
```

Здесь:

- `-w sample_file_Ethernet0.pcap` - запись захваченных пакетов в файл `sample_file_Ethernet0.pcap`.
- `-G 60` - ротация (смена файла для записи) каждые 60 секунд.
- `-W 1` - записать один файл.
- `-i Ethernet0` - производить захват с интерфейса `Ethernet0`.

Как вариант, можно ограничить по количеству пакетов:

```bash
sudo tcpdump -w sample_file_Ethernet0.pcap -c 1000 -i Ethernet0
```

`-c 1000` - прервать работу после захвата 1000 пакетов.
