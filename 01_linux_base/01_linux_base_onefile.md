# Linux base in one file

- [Linux base in one file](#linux-base-in-one-file)
  - [Изменить редактор по умолчанию](#изменить-редактор-по-умолчанию)
  - [Изменение hostname](#изменение-hostname)
  - [Разрешаем SUDO без пароля](#разрешаем-sudo-без-пароля)
  - [sysctl](#sysctl)

## Изменить редактор по умолчанию

[**Назад**](/README.md)

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

---

## Изменение hostname

[**Назад**](/README.md)

```bash
sudo hostnamectl hostname FRR
```

Позволяет сохранить хостнейм и после перезагрузки.

---

## Разрешаем SUDO без пароля

[**Назад**](/README.md)

В sudoers (через `sudo visudo`) в конце добавляем строчку вида `$USERNAME ALL=(ALL) NOPASSWD: ALL`. В итоге выглядеть будет как-то так:

```bash
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

---

## sysctl

[**Назад**](/README.md)

**sysctl** - утилита, позволяющая читать и изменять параметры ядра "на лету". Работает через изменение виртуальной файловой системы `/proc/sys`.

`sysctl -a` - посмотреть все текущие значения.
`sysctl -p` - загрузить все значения из `/etc/sysctl.conf`.
`sysctl -w $VAR_NAME=$NEW_VALUE` - записать значения в переменную. Например: `sysctl -w net.ipv4.ip_forward=1`.
`sysctl $VAR_NAME` - получить текущие значения для переменной.
