# Изменить редактор по умолчанию

По умолчанию в Ubuntu и пр. редактором выбран nano. Чтобы изменить, нужно сделать следующее:

```bash
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
