# Docker notes

[**Назад**](/README.md)

- [Docker notes](#docker-notes)
  - [Начало](#начало)
  - [Базовые команды](#базовые-команды)
  - [Проброс портов](#проброс-портов)
  - [Сети в docker](#сети-в-docker)
    - [Запуск контейнера со статически IP-адресом](#запуск-контейнера-со-статически-ip-адресом)
  - [Вывести контейнер в общую сеть с сетевым интерфейсом](#вывести-контейнер-в-общую-сеть-с-сетевым-интерфейсом)

## Начало

Для работы без sudo или не из под root'а необходимо добавить пользователя в группу docker:

```linux
modemfux@docker-vm-nb:~$ sudo usermod -aG docker modemfux
modemfux@docker-vm-nb:~$ id
uid=1000(modemfux) gid=1000(modemfux) groups=1000(modemfux),4(adm),24(cdrom),27(sudo),30(dip),46(plugdev),101(lxd),988(docker)
modemfux@docker-vm-nb:~$
```

## Базовые команды

**Скачать образ:**

```linux
modemfux@docker-vm-nb:~$ docker pull nginx:latest
latest: Pulling from library/nginx
8a628cdd7ccc: Pull complete
b0c073cda91f: Pull complete
e6557c42ebea: Pull complete
ec74683520b9: Pull complete
6c95adab80c5: Pull complete
ad8a0171f43e: Pull complete
32ef64864ec3: Pull complete
Digest: sha256:5ed8fcc66f4ed123c1b2560ed708dc148755b6e4cbd8b943fab094f2c6bfa91e
Status: Downloaded newer image for nginx:latest
docker.io/library/nginx:latest
```

**Посмотреть список образов:**

```linux
modemfux@docker-vm-nb:~$ docker image ls
REPOSITORY   TAG       IMAGE ID       CREATED       SIZE
nginx        latest    4e1b6bae1e48   11 days ago   192MB
modemfux@docker-vm-nb:~$ docker images
REPOSITORY   TAG       IMAGE ID       CREATED       SIZE
nginx        latest    4e1b6bae1e48   11 days ago   192MB
modemfux@docker-vm-nb:~$
```

**Посмотреть подробную информацию образа:**

```json
modemfux@docker-vm-nb:~$ docker inspect nginx
[
    {
        "Id": "sha256:4e1b6bae1e48cdbde8e6ec3e6ee42d86ad4780156e75790465bf6fb16c551c27",
        "RepoTags": [
            "nginx:latest"
        ],
        "RepoDigests": [
            "nginx@sha256:5ed8fcc66f4ed123c1b2560ed708dc148755b6e4cbd8b943fab094f2c6bfa91e"
        ],
        "Parent": "",
        "Comment": "buildkit.dockerfile.v0",
        "Created": "2025-04-16T14:50:31Z",
        "DockerVersion": "",
        "Author": "",
        "Config": {
            "Hostname": "",
            "Domainname": "",
            "User": "",
            "AttachStdin": false,
            "AttachStdout": false,
            "AttachStderr": false,
            "ExposedPorts": {
                "80/tcp": {}
            },
            "Tty": false,
            "OpenStdin": false,
            "StdinOnce": false,
            "Env": [
                "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
                "NGINX_VERSION=1.27.5",
                "NJS_VERSION=0.8.10",
                "NJS_RELEASE=1~bookworm",
                "PKG_RELEASE=1~bookworm",
                "DYNPKG_RELEASE=1~bookworm"
            ],
            "Cmd": [
                "nginx",
                "-g",
                "daemon off;"
            ],
            "Image": "",
            "Volumes": null,
            "WorkingDir": "",
            "Entrypoint": [
                "/docker-entrypoint.sh"
            ],
            "OnBuild": null,
            "Labels": {
                "maintainer": "NGINX Docker Maintainers <docker-maint@nginx.com>"
            },
            "StopSignal": "SIGQUIT"
        },
        "Architecture": "amd64",
        "Os": "linux",
        "Size": 192484923,
        "GraphDriver": {
            "Data": {
                "LowerDir": "/var/lib/docker/overlay2/79bead9dbbc651f6c5f28210d3df551e824e74a028aa605eb2d1735982ebd249/diff:/var/lib/docker/overlay2/d47653308b32f30cf3fe839511f276005c24b5d49427e9dd984f16e251e175f2/diff:/var/lib/docker/overlay2/04209318b8fbc769641550942036c787ef59775fb2ba56c3d6ff81cc8bb9c0f5/diff:/var/lib/docker/overlay2/0b35c7a5b817995a9db4eb1b738a82e28d44f8241868c0aafe089344ea1583ce/diff:/var/lib/docker/overlay2/5e457cfcf4dd9635553cc20e57f860de4f37ecefa4b2975642f2ac9120679790/diff:/var/lib/docker/overlay2/c09bc0417f3cf8aa11c6988ef46922dc63f191aa439ec214b6ddb9f00622b914/diff",
                "MergedDir": "/var/lib/docker/overlay2/cd1886179090b204a043ec2aeb6c7ccf374c781a0d53a2a37e3c7e2f06d1ea24/merged",
                "UpperDir": "/var/lib/docker/overlay2/cd1886179090b204a043ec2aeb6c7ccf374c781a0d53a2a37e3c7e2f06d1ea24/diff",
                "WorkDir": "/var/lib/docker/overlay2/cd1886179090b204a043ec2aeb6c7ccf374c781a0d53a2a37e3c7e2f06d1ea24/work"
            },
            "Name": "overlay2"
        },
        "RootFS": {
            "Type": "layers",
            "Layers": [
                "sha256:ea680fbff095473bb8a6c867938d6d851e11ef0c177fce983ccc83440172bd72",
                "sha256:bd903131a05ed20c1ad9a8d5bb5b59cd0afa1b5b48683678cf71305863b74433",
                "sha256:9aad78ecf38071e3f8840ed045b8942764c9422f57a93f7ce3ef454cefea1493",
                "sha256:9e3c6e8c1e2584acc82890d31d41f8728460629ea3933e584815122eaa954984",
                "sha256:8d83f6b791435d460ba4e233e9be563a2308d7712fc15239836ea01365f8c008",
                "sha256:ccc5aac17fc4db15cf1c4562216e158143fc4540bf88a116b3862c5c205a2bbd",
                "sha256:d1e3e4dd1aaaad7a94f9d28564746092e7da13a34ee69a8c23d5ae34eabdc480"
            ]
        },
        "Metadata": {
            "LastTagTime": "0001-01-01T00:00:00Z"
        }
    }
]
```

**Создать и запустить контейнер. По умолчанию запускается не в detached mode, для выхода необходимо нажать Ctrl+C.**

```linux
modemfux@docker-vm-nb:~$ docker run nginx
/docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
/docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
/docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh
10-listen-on-ipv6-by-default.sh: info: Getting the checksum of /etc/nginx/conf.d/default.conf
10-listen-on-ipv6-by-default.sh: info: Enabled listen on IPv6 in /etc/nginx/conf.d/default.conf
/docker-entrypoint.sh: Sourcing /docker-entrypoint.d/15-local-resolvers.envsh
/docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh
/docker-entrypoint.sh: Launching /docker-entrypoint.d/30-tune-worker-processes.sh
/docker-entrypoint.sh: Configuration complete; ready for start up
2025/04/27 15:57:49 [notice] 1#1: using the "epoll" event method
2025/04/27 15:57:49 [notice] 1#1: nginx/1.27.5
2025/04/27 15:57:49 [notice] 1#1: built by gcc 12.2.0 (Debian 12.2.0-14)
2025/04/27 15:57:49 [notice] 1#1: OS: Linux 6.8.0-58-generic
2025/04/27 15:57:49 [notice] 1#1: getrlimit(RLIMIT_NOFILE): 1048576:1048576
2025/04/27 15:57:49 [notice] 1#1: start worker processes
2025/04/27 15:57:49 [notice] 1#1: start worker process 28
2025/04/27 15:57:49 [notice] 1#1: start worker process 29
^C2025/04/27 15:58:49 [notice] 1#1: signal 2 (SIGINT) received, exiting ## Здесь нажали Ctrl+C
2025/04/27 15:58:49 [notice] 28#28: exiting
2025/04/27 15:58:49 [notice] 28#28: exit
2025/04/27 15:58:49 [notice] 29#29: exiting
2025/04/27 15:58:49 [notice] 29#29: exit
2025/04/27 15:58:49 [notice] 1#1: signal 17 (SIGCHLD) received from 28
2025/04/27 15:58:49 [notice] 1#1: worker process 28 exited with code 0
2025/04/27 15:58:49 [notice] 1#1: worker process 29 exited with code 0
2025/04/27 15:58:49 [notice] 1#1: exit
modemfux@docker-vm-nb:~$
```

Если образа в системе нет, то он будет автоматически скачан:

```linux
modemfux@docker-vm-nb:~$ docker images
REPOSITORY   TAG       IMAGE ID       CREATED       SIZE
nginx        latest    4e1b6bae1e48   11 days ago   192MB
modemfux@docker-vm-nb:~$ docker run hello-world
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
e6590344b1a5: Pull complete
Digest: sha256:c41088499908a59aae84b0a49c70e86f4731e588a737f1637e73c8c09d995654
Status: Downloaded newer image for hello-world:latest

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/

modemfux@docker-vm-nb:~$ docker images
REPOSITORY    TAG       IMAGE ID       CREATED        SIZE
nginx         latest    4e1b6bae1e48   11 days ago    192MB
hello-world   latest    74cc54e27dc4   3 months ago   10.1kB
modemfux@docker-vm-nb:~$
```

**Создать и запустить в detached-режиме:**

```linux
modemfux@docker-vm-nb:~$ docker run -d nginx
29ce8023f7e9da17e86a1d74e526d483aa1f46211ae3e710680b3cb6d8a068d1
modemfux@docker-vm-nb:~$
```

**Можно задать вручную имя:**

```linux
modemfux@docker-vm-nb:~$ docker run -d --rm --name Zappa nginx
56966776981ca8c764c55c92e85b032857b4b0aac971fafaa86b4908ad8e4432
modemfux@docker-vm-nb:~$ docker ps
CONTAINER ID   IMAGE     COMMAND                  CREATED         STATUS        PORTS     NAMES
56966776981c   nginx     "/docker-entrypoint.…"   2 seconds ago   Up 1 second   80/tcp    Zappa
modemfux@docker-vm-nb:~$
```

Ключ `--rm` здесь нужен, чтобы автоматически удалить контейнер после остановки.

```linux
modemfux@docker-vm-nb:~$ docker ps -a
CONTAINER ID   IMAGE     COMMAND                  CREATED              STATUS              PORTS     NAMES
56966776981c   nginx     "/docker-entrypoint.…"   About a minute ago   Up About a minute   80/tcp    Zappa
modemfux@docker-vm-nb:~$ docker stop Zappa
Zappa
modemfux@docker-vm-nb:~$ docker ps -a
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
modemfux@docker-vm-nb:~$
```

**Посмотреть список запущенных контейнеров:**

```linux
modemfux@docker-vm-nb:~$ docker ps
CONTAINER ID   IMAGE     COMMAND                  CREATED          STATUS          PORTS     NAMES
29ce8023f7e9   nginx     "/docker-entrypoint.…"   13 seconds ago   Up 13 seconds   80/tcp    recursing_noyce
```

**Посмотреть список всех контейнеров, включая остановленные:**

```linux
modemfux@docker-vm-nb:~$ docker ps -a
CONTAINER ID   IMAGE         COMMAND                  CREATED       STATUS                   PORTS     NAMES
29ce8023f7e9   nginx         "/docker-entrypoint.…"   3 hours ago   Up 3 hours               80/tcp    recursing_noyce
0d9075e4cab2   hello-world   "/hello"                 3 hours ago   Exited (0) 3 hours ago             relaxed_ride
46e6d26b8bb7   nginx         "/docker-entrypoint.…"   3 hours ago   Exited (0) 3 hours ago             peaceful_cerf
modemfux@docker-vm-nb:~$ docker container ls -a
CONTAINER ID   IMAGE         COMMAND                  CREATED       STATUS                   PORTS     NAMES
29ce8023f7e9   nginx         "/docker-entrypoint.…"   3 hours ago   Up 3 hours               80/tcp    recursing_noyce
0d9075e4cab2   hello-world   "/hello"                 3 hours ago   Exited (0) 3 hours ago             relaxed_ride
46e6d26b8bb7   nginx         "/docker-entrypoint.…"   3 hours ago   Exited (0) 3 hours ago             peaceful_cerf
modemfux@docker-vm-nb:~$ docker container ls -a -s
CONTAINER ID   IMAGE         COMMAND                  CREATED       STATUS                   PORTS     NAMES             SIZE
29ce8023f7e9   nginx         "/docker-entrypoint.…"   3 hours ago   Up 3 hours               80/tcp    recursing_noyce   1.09kB (virtual 192MB)
0d9075e4cab2   hello-world   "/hello"                 3 hours ago   Exited (0) 3 hours ago             relaxed_ride      0B (virtual 10.1kB)
46e6d26b8bb7   nginx         "/docker-entrypoint.…"   3 hours ago   Exited (0) 3 hours ago             peaceful_cerf     1.09kB (virtual 192MB)
modemfux@docker-vm-nb:~$
```

**Остановить контейнер:**

```linux
modemfux@docker-vm-nb:~$ docker stop 29ce8023f7e9
29ce8023f7e9
modemfux@docker-vm-nb:~$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
modemfux@docker-vm-nb:~$ docker ps -a
CONTAINER ID   IMAGE         COMMAND                  CREATED       STATUS                     PORTS     NAMES
29ce8023f7e9   nginx         "/docker-entrypoint.…"   3 hours ago   Exited (0) 8 seconds ago             recursing_noyce
0d9075e4cab2   hello-world   "/hello"                 3 hours ago   Exited (0) 3 hours ago               relaxed_ride
46e6d26b8bb7   nginx         "/docker-entrypoint.…"   3 hours ago   Exited (0) 3 hours ago               peaceful_cerf
modemfux@docker-vm-nb:~$
```

**Запустить созданный контейнер:**

```linux
modemfux@docker-vm-nb:~$ docker start 29ce8023f7e9
29ce8023f7e9
modemfux@docker-vm-nb:~$ docker ps
CONTAINER ID   IMAGE     COMMAND                  CREATED       STATUS         PORTS     NAMES
29ce8023f7e9   nginx     "/docker-entrypoint.…"   3 hours ago   Up 4 seconds   80/tcp    recursing_noyce
modemfux@docker-vm-nb:~$
```

**Посмотреть детальную информацию об объекте (контейнере):**

```json
modemfux@docker-vm-nb:~$ docker inspect 29ce8023f7e9
[
    {
        "Id": "29ce8023f7e9da17e86a1d74e526d483aa1f46211ae3e710680b3cb6d8a068d1",
        "Created": "2025-04-27T16:25:39.738055367Z",
        "Path": "/docker-entrypoint.sh",
        "Args": [
            "nginx",
            "-g",
            "daemon off;"
        ],
        "State": {
            "Status": "running",
            "Running": true,
            "Paused": false,
            "Restarting": false,
            "OOMKilled": false,
            "Dead": false,
            "Pid": 4963,
            "ExitCode": 0,
            "Error": "",
            "StartedAt": "2025-04-27T19:13:15.440923437Z",
            "FinishedAt": "2025-04-27T19:11:55.608962372Z"
        },
        "Image": "sha256:4e1b6bae1e48cdbde8e6ec3e6ee42d86ad4780156e75790465bf6fb16c551c27",
        "ResolvConfPath": "/var/lib/docker/containers/29ce8023f7e9da17e86a1d74e526d483aa1f46211ae3e710680b3cb6d8a068d1/resolv.conf",
        "HostnamePath": "/var/lib/docker/containers/29ce8023f7e9da17e86a1d74e526d483aa1f46211ae3e710680b3cb6d8a068d1/hostname",
        "HostsPath": "/var/lib/docker/containers/29ce8023f7e9da17e86a1d74e526d483aa1f46211ae3e710680b3cb6d8a068d1/hosts",
        "LogPath": "/var/lib/docker/containers/29ce8023f7e9da17e86a1d74e526d483aa1f46211ae3e710680b3cb6d8a068d1/29ce8023f7e9da17e86a1d74e526d483aa1f46211ae3e710680b3cb6d8a068d1-json.log",
        "Name": "/recursing_noyce",
        "RestartCount": 0,
        "Driver": "overlay2",
        "Platform": "linux",
        "MountLabel": "",
        "ProcessLabel": "",
        "AppArmorProfile": "docker-default",
        "ExecIDs": null,
        "HostConfig": {
            "Binds": null,
            "ContainerIDFile": "",
            "LogConfig": {
                "Type": "json-file",
                "Config": {}
            },
            "NetworkMode": "bridge",
            "PortBindings": {},
            "RestartPolicy": {
                "Name": "no",
                "MaximumRetryCount": 0
            },
            "AutoRemove": false,
            "VolumeDriver": "",
            "VolumesFrom": null,
            "ConsoleSize": [
                50,
                233
            ],
            "CapAdd": null,
            "CapDrop": null,
            "CgroupnsMode": "private",
            "Dns": [],
            "DnsOptions": [],
            "DnsSearch": [],
            "ExtraHosts": null,
            "GroupAdd": null,
            "IpcMode": "private",
            "Cgroup": "",
            "Links": null,
            "OomScoreAdj": 0,
            "PidMode": "",
            "Privileged": false,
            "PublishAllPorts": false,
            "ReadonlyRootfs": false,
            "SecurityOpt": null,
            "UTSMode": "",
            "UsernsMode": "",
            "ShmSize": 67108864,
            "Runtime": "runc",
            "Isolation": "",
            "CpuShares": 0,
            "Memory": 0,
            "NanoCpus": 0,
            "CgroupParent": "",
            "BlkioWeight": 0,
            "BlkioWeightDevice": [],
            "BlkioDeviceReadBps": [],
            "BlkioDeviceWriteBps": [],
            "BlkioDeviceReadIOps": [],
            "BlkioDeviceWriteIOps": [],
            "CpuPeriod": 0,
            "CpuQuota": 0,
            "CpuRealtimePeriod": 0,
            "CpuRealtimeRuntime": 0,
            "CpusetCpus": "",
            "CpusetMems": "",
            "Devices": [],
            "DeviceCgroupRules": null,
            "DeviceRequests": null,
            "MemoryReservation": 0,
            "MemorySwap": 0,
            "MemorySwappiness": null,
            "OomKillDisable": null,
            "PidsLimit": null,
            "Ulimits": [],
            "CpuCount": 0,
            "CpuPercent": 0,
            "IOMaximumIOps": 0,
            "IOMaximumBandwidth": 0,
            "MaskedPaths": [
                "/proc/asound",
                "/proc/acpi",
                "/proc/interrupts",
                "/proc/kcore",
                "/proc/keys",
                "/proc/latency_stats",
                "/proc/timer_list",
                "/proc/timer_stats",
                "/proc/sched_debug",
                "/proc/scsi",
                "/sys/firmware",
                "/sys/devices/virtual/powercap"
            ],
            "ReadonlyPaths": [
                "/proc/bus",
                "/proc/fs",
                "/proc/irq",
                "/proc/sys",
                "/proc/sysrq-trigger"
            ]
        },
        "GraphDriver": {
            "Data": {
                "ID": "29ce8023f7e9da17e86a1d74e526d483aa1f46211ae3e710680b3cb6d8a068d1",
                "LowerDir": "/var/lib/docker/overlay2/fdce620d7096ca4e87e8a4ca0302061247ee99ba8fd20255d9b70fa52d2227bd-init/diff:/var/lib/docker/overlay2/cd1886179090b204a043ec2aeb6c7ccf374c781a0d53a2a37e3c7e2f06d1ea24/diff:/var/lib/docker/overlay2/79bead9dbbc651f6c5f28210d3df551e824e74a028aa605eb2d1735982ebd249/diff:/var/lib/docker/overlay2/d47653308b32f30cf3fe839511f276005c24b5d49427e9dd984f16e251e175f2/diff:/var/lib/docker/overlay2/04209318b8fbc769641550942036c787ef59775fb2ba56c3d6ff81cc8bb9c0f5/diff:/var/lib/docker/overlay2/0b35c7a5b817995a9db4eb1b738a82e28d44f8241868c0aafe089344ea1583ce/diff:/var/lib/docker/overlay2/5e457cfcf4dd9635553cc20e57f860de4f37ecefa4b2975642f2ac9120679790/diff:/var/lib/docker/overlay2/c09bc0417f3cf8aa11c6988ef46922dc63f191aa439ec214b6ddb9f00622b914/diff",
                "MergedDir": "/var/lib/docker/overlay2/fdce620d7096ca4e87e8a4ca0302061247ee99ba8fd20255d9b70fa52d2227bd/merged",
                "UpperDir": "/var/lib/docker/overlay2/fdce620d7096ca4e87e8a4ca0302061247ee99ba8fd20255d9b70fa52d2227bd/diff",
                "WorkDir": "/var/lib/docker/overlay2/fdce620d7096ca4e87e8a4ca0302061247ee99ba8fd20255d9b70fa52d2227bd/work"
            },
            "Name": "overlay2"
        },
        "Mounts": [],
        "Config": {
            "Hostname": "29ce8023f7e9",
            "Domainname": "",
            "User": "",
            "AttachStdin": false,
            "AttachStdout": false,
            "AttachStderr": false,
            "ExposedPorts": {
                "80/tcp": {}
            },
            "Tty": false,
            "OpenStdin": false,
            "StdinOnce": false,
            "Env": [
                "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
                "NGINX_VERSION=1.27.5",
                "NJS_VERSION=0.8.10",
                "NJS_RELEASE=1~bookworm",
                "PKG_RELEASE=1~bookworm",
                "DYNPKG_RELEASE=1~bookworm"
            ],
            "Cmd": [
                "nginx",
                "-g",
                "daemon off;"
            ],
            "Image": "nginx",
            "Volumes": null,
            "WorkingDir": "",
            "Entrypoint": [
                "/docker-entrypoint.sh"
            ],
            "OnBuild": null,
            "Labels": {
                "maintainer": "NGINX Docker Maintainers <docker-maint@nginx.com>"
            },
            "StopSignal": "SIGQUIT"
        },
        "NetworkSettings": {
            "Bridge": "",
            "SandboxID": "ce844e1df5c11d637bd95a6b739dea0eafcb7fcfc6b430e611a49dce7745c3f9",
            "SandboxKey": "/var/run/docker/netns/ce844e1df5c1",
            "Ports": {
                "80/tcp": null
            },
            "HairpinMode": false,
            "LinkLocalIPv6Address": "",
            "LinkLocalIPv6PrefixLen": 0,
            "SecondaryIPAddresses": null,
            "SecondaryIPv6Addresses": null,
            "EndpointID": "54f40d5a90a41f8dfc7380f3e91c6cc3fe80f8e8c0bec4273aea11d95943a869",
            "Gateway": "172.17.0.1",
            "GlobalIPv6Address": "",
            "GlobalIPv6PrefixLen": 0,
            "IPAddress": "172.17.0.2",
            "IPPrefixLen": 16,
            "IPv6Gateway": "",
            "MacAddress": "c6:dd:9c:a0:7c:6c",
            "Networks": {
                "bridge": {
                    "IPAMConfig": null,
                    "Links": null,
                    "Aliases": null,
                    "MacAddress": "c6:dd:9c:a0:7c:6c",
                    "DriverOpts": null,
                    "GwPriority": 0,
                    "NetworkID": "b55a0e278841c88ee37bd27d1a8e7da583d316517f2f430b77e288f0995bc1a4",
                    "EndpointID": "54f40d5a90a41f8dfc7380f3e91c6cc3fe80f8e8c0bec4273aea11d95943a869",
                    "Gateway": "172.17.0.1",
                    "IPAddress": "172.17.0.2",
                    "IPPrefixLen": 16,
                    "IPv6Gateway": "",
                    "GlobalIPv6Address": "",
                    "GlobalIPv6PrefixLen": 0,
                    "DNSNames": null
                }
            }
        }
    }
]
```

**Посмотреть статистику в реальном времени (чтобы выйти, нужно три раза нажать Ctrl+C):**

```linux
modemfux@docker-vm-nb:~$ docker stats 29ce8023f7e9

CONTAINER ID   NAME              CPU %     MEM USAGE / LIMIT     MEM %     NET I/O         BLOCK I/O    PIDS
29ce8023f7e9   recursing_noyce   0.00%     3.094MiB / 7.709GiB   0.04%     1.09kB / 126B   0B / 4.1kB   3
^C
got 3 SIGTERM/SIGINTs, forcefully exiting
```

**Чтобы удалить образ необходимо использовать `docker rmi $IMAGE_NAME`:**

```linux
modemfux@docker-vm-nb:~$ docker ps
CONTAINER ID   IMAGE     COMMAND                  CREATED       STATUS         PORTS     NAMES
29ce8023f7e9   nginx     "/docker-entrypoint.…"   3 hours ago   Up 4 minutes   80/tcp    recursing_noyce
modemfux@docker-vm-nb:~$ docker rmi nginx
Error response from daemon: conflict: unable to remove repository reference "nginx" (must force) - container 46e6d26b8bb7 is using its referenced image 4e1b6bae1e48
modemfux@docker-vm-nb:~$
```

Как видно, удалить нельзя, т.к. есть контейнер, использующий этот образ. Остановим его и попробуем снова:

```linux
modemfux@docker-vm-nb:~$ docker ps -a
CONTAINER ID   IMAGE         COMMAND                  CREATED       STATUS                   PORTS     NAMES
29ce8023f7e9   nginx         "/docker-entrypoint.…"   3 hours ago   Up 7 minutes             80/tcp    recursing_noyce
0d9075e4cab2   hello-world   "/hello"                 3 hours ago   Exited (0) 3 hours ago             relaxed_ride
46e6d26b8bb7   nginx         "/docker-entrypoint.…"   3 hours ago   Exited (0) 3 hours ago             peaceful_cerf
modemfux@docker-vm-nb:~$ docker rm 46e6d26b8bb7
46e6d26b8bb7
modemfux@docker-vm-nb:~$ docker ps -a
CONTAINER ID   IMAGE         COMMAND                  CREATED       STATUS                   PORTS     NAMES
29ce8023f7e9   nginx         "/docker-entrypoint.…"   3 hours ago   Up 7 minutes             80/tcp    recursing_noyce
0d9075e4cab2   hello-world   "/hello"                 3 hours ago   Exited (0) 3 hours ago             relaxed_ride
modemfux@docker-vm-nb:~$ docker rmi nginx
Error response from daemon: conflict: unable to remove repository reference "nginx" (must force) - container 29ce8023f7e9 is using its referenced image 4e1b6bae1e48
```

Сейчас нам мешает и контейнер с ID == 29ce8023f7e9. Разберемся и с ним:

```linux
modemfux@docker-vm-nb:~$ docker rm 29ce8023f7e9
Error response from daemon: cannot remove container "/recursing_noyce": container is running: stop the container before removing or force remove
modemfux@docker-vm-nb:~$ docker stop 29ce8023f7e9
29ce8023f7e9
modemfux@docker-vm-nb:~$ docker rm 29ce8023f7e9
29ce8023f7e9
modemfux@docker-vm-nb:~$ docker rmi nginx
Untagged: nginx:latest
Untagged: nginx@sha256:5ed8fcc66f4ed123c1b2560ed708dc148755b6e4cbd8b943fab094f2c6bfa91e
Deleted: sha256:4e1b6bae1e48cdbde8e6ec3e6ee42d86ad4780156e75790465bf6fb16c551c27
Deleted: sha256:54e3ab6292c032a67a0b40e4efb1d1103fc0cf511adc81d76d3a38b95346f723
Deleted: sha256:a0d2387b1619ddad596155d0d9b898e646b267dfdf3cbe7771cb0cdadd5d15b5
Deleted: sha256:7f2e29110e65e19a2fd3fb6f692345c62d9d1d45fccc69f0f2e4e5282bf5a153
Deleted: sha256:6326ba543c8ab9588de067410d5ad23828fcf83d5d04719a1f88c02c9118ccfa
Deleted: sha256:164dfb151284668c54c8259d6a82900f19b157b655deafc294db044ee4da219e
Deleted: sha256:6a2a04bbab5eca06a23a05254ed5166c9a548245861f9db0e23796fb87d490a3
Deleted: sha256:ea680fbff095473bb8a6c867938d6d851e11ef0c177fce983ccc83440172bd72
modemfux@docker-vm-nb:~$ docker images
REPOSITORY    TAG       IMAGE ID       CREATED        SIZE
hello-world   latest    74cc54e27dc4   3 months ago   10.1kB
modemfux@docker-vm-nb:~$
```

Очистка кэша и удаление незапущенных контейнеров:

```linux
modemfux@docker-vm-nb:~$ docker ps -a
CONTAINER ID   IMAGE         COMMAND    CREATED       STATUS                   PORTS     NAMES
0d9075e4cab2   hello-world   "/hello"   3 hours ago   Exited (0) 3 hours ago             relaxed_ride
modemfux@docker-vm-nb:~$ docker images
REPOSITORY    TAG       IMAGE ID       CREATED        SIZE
hello-world   latest    74cc54e27dc4   3 months ago   10.1kB
modemfux@docker-vm-nb:~$ docker system prune
WARNING! This will remove:
  - all stopped containers
  - all networks not used by at least one container
  - all dangling images
  - unused build cache

Are you sure you want to continue? [y/N] Y
Deleted Containers:
0d9075e4cab220bc685869e93d512b59a56d59ee3e8414de5ee39c9e5298e4e9

Deleted build cache objects:
f4o05hmjs1nil41kjm5tosqaa

Total reclaimed space: 0B
modemfux@docker-vm-nb:~$ docker ps -a
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
modemfux@docker-vm-nb:~$ docker images
REPOSITORY    TAG       IMAGE ID       CREATED        SIZE
hello-world   latest    74cc54e27dc4   3 months ago   10.1kB
modemfux@docker-vm-nb:~$
```

**Подключиться к запущенному контейнеру (выполнить команду в интерактивном режиме):**

```linux
modemfux@docker-vm-nb:~$ docker run --rm -d --name=DOCK nginx
4e061430f06d993f23adf24d1ed1582baafb8acaa4026c3763c8e8d15d90b0fc
modemfux@docker-vm-nb:~$ docker exec -it DOCK /bin/bash
root@4e061430f06d:/# ls
bin  boot  dev  docker-entrypoint.d  docker-entrypoint.sh  etc  home  lib  lib64  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var
root@4e061430f06d:/# pwd
/
root@4e061430f06d:/# exit
exit
modemfux@docker-vm-nb:~$
```

## Проброс портов

Обычный запуск:

```linux
modemfux@docker-vm-nb:~$ docker run --rm -d --name=DOCK nginx
618ed93f6c04a335583e0334ae0747bb47d637842951c31c0facd5805a419ee7
modemfux@docker-vm-nb:~$ docker inspect DOCK | grep IPA
            "SecondaryIPAddresses": null,
            "IPAddress": "172.17.0.2",
                    "IPAMConfig": null,
                    "IPAddress": "172.17.0.2",
modemfux@docker-vm-nb:~$ curl http://172.17.0.2/
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
modemfux@docker-vm-nb:~$ curl http://localhost
curl: (7) Failed to connect to localhost port 80 after 0 ms: Couldn't connect to server
modemfux@docker-vm-nb:~$ docker ps
CONTAINER ID   IMAGE     COMMAND                  CREATED          STATUS          PORTS     NAMES
618ed93f6c04   nginx     "/docker-entrypoint.…"   13 seconds ago   Up 12 seconds   80/tcp    DOCK
modemfux@docker-vm-nb:~$ ss -tlpn
State                       Recv-Q                      Send-Q                                           Local Address:Port                                           Peer Address:Port                     Process
LISTEN                      0                           4096                                                127.0.0.54:53                                                  0.0.0.0:*
LISTEN                      0                           128                                                  127.0.0.1:6010                                                0.0.0.0:*
LISTEN                      0                           4096                                             127.0.0.53%lo:53                                                  0.0.0.0:*
LISTEN                      0                           4096                                                         *:22                                                        *:*
LISTEN                      0                           128                                                      [::1]:6010                                                   [::]:*
modemfux@docker-vm-nb:~$
```

Теперь включим с пробросом портов:

```linux
modemfux@docker-vm-nb:~$ docker stop DOCK
DOCK
modemfux@docker-vm-nb:~$ docker run --rm -d --name=DOCK2 -p 80:80 nginx
e052090d5fe157a2a320e774151a68c4fe956c801bbfde6330c45c053914fc3b
modemfux@docker-vm-nb:~$ docker ps
CONTAINER ID   IMAGE     COMMAND                  CREATED         STATUS         PORTS                                 NAMES
e052090d5fe1   nginx     "/docker-entrypoint.…"   3 seconds ago   Up 2 seconds   0.0.0.0:80->80/tcp, [::]:80->80/tcp   DOCK2
modemfux@docker-vm-nb:~$ docker inspect DOCK2 | grep IPA
            "SecondaryIPAddresses": null,
            "IPAddress": "172.17.0.2",
                    "IPAMConfig": null,
                    "IPAddress": "172.17.0.2",
modemfux@docker-vm-nb:~$ ss -tlpn
State                       Recv-Q                      Send-Q                                           Local Address:Port                                           Peer Address:Port                     Process
LISTEN                      0                           4096                                                   0.0.0.0:80                                                  0.0.0.0:*
LISTEN                      0                           4096                                                127.0.0.54:53                                                  0.0.0.0:*
LISTEN                      0                           128                                                  127.0.0.1:6010                                                0.0.0.0:*
LISTEN                      0                           4096                                             127.0.0.53%lo:53                                                  0.0.0.0:*
LISTEN                      0                           4096                                                         *:22                                                        *:*
LISTEN                      0                           4096                                                      [::]:80                                                     [::]:*
LISTEN                      0                           128                                                      [::1]:6010                                                   [::]:*
modemfux@docker-vm-nb:~$ curl http://172.17.0.2/
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
modemfux@docker-vm-nb:~$ curl http://localhost
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
modemfux@docker-vm-nb:~$
```

## Сети в docker

По умолчанию все контейнеры создаются в дефолтной бриджевой сети `bridge`:

```linux
modemfux@docker-vm-nb:~$ docker network ls
NETWORK ID     NAME      DRIVER    SCOPE
68c69a7aec35   bridge    bridge    local
c604d91d1acf   host      host      local
2a19832f71a2   none      null      local
```

Для этой сети создан бридж-интерфейс docker0

```linux
modemfux@docker-vm-nb:~$ ip -d addr show docker0
3: docker0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default
    link/ether 36:e6:80:30:63:93 brd ff:ff:ff:ff:ff:ff promiscuity 0  allmulti 0 minmtu 68 maxmtu 65535
    bridge forward_delay 1500 hello_time 200 max_age 2000 ageing_time 30000 stp_state 0 priority 32768 vlan_filtering 0 vlan_protocol 802.1Q bridge_id 8000.36:e6:80:30:63:93 designated_root 8000.36:e6:80:30:63:93 root_port 0 root_path_cost 0 topology_change 0 topology_change_detected 0 hello_timer    0.00 tcn_timer    0.00 topology_change_timer    0.00 gc_timer    7.09 vlan_default_pvid 1 vlan_stats_enabled 0 vlan_stats_per_port 0 group_fwd_mask 0 group_address 01:80:c2:00:00:00 mcast_snooping 1 no_linklocal_learn 0 mcast_vlan_snooping 0 mcast_router 1 mcast_query_use_ifaddr 0 mcast_querier 0 mcast_hash_elasticity 16 mcast_hash_max 4096 mcast_last_member_count 2 mcast_startup_query_count 2 mcast_last_member_interval 100 mcast_membership_interval 26000 mcast_querier_interval 25500 mcast_query_interval 12500 mcast_query_response_interval 1000 mcast_startup_query_interval 3125 mcast_stats_enabled 0 mcast_igmp_version 2 mcast_mld_version 1 nf_call_iptables 0 nf_call_ip6tables 0 nf_call_arptables 0 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535 tso_max_size 524280 tso_max_segs 65535 gro_max_size 65536
    inet 172.17.0.1/16 brd 172.17.255.255 scope global docker0
       valid_lft forever preferred_lft forever
    inet6 fe80::34e6:80ff:fe30:6393/64 scope link
       valid_lft forever preferred_lft forever
```

```linux
modemfux@docker-vm-nb:~$ docker run -d --rm --name WEB01 -p 80:80 sample_nginx:3
da5b48e71920d8a34a3e15d5571d09f5dded9f071ecd5f88226db2100c6b9ea8
modemfux@docker-vm-nb:~$ docker run -d --rm --name WEB02 -p 8080:80 sample_nginx:3
786b44e4fc7783300cd544521d2bed6384fecfacfab965a8cb37ef2c1f9fb417
modemfux@docker-vm-nb:~$ docker ps
CONTAINER ID   IMAGE            COMMAND                  CREATED          STATUS          PORTS                                     NAMES
786b44e4fc77   sample_nginx:3   "nginx -g 'daemon of…"   21 seconds ago   Up 20 seconds   0.0.0.0:8080->80/tcp, [::]:8080->80/tcp   WEB02
da5b48e71920   sample_nginx:3   "nginx -g 'daemon of…"   26 seconds ago   Up 26 seconds   0.0.0.0:80->80/tcp, [::]:80->80/tcp       WEB01
modemfux@docker-vm-nb:~$ docker inspect WEB01 | grep -A 100 "NetworkSettings"
        "NetworkSettings": {
            "Bridge": "",
            "SandboxID": "55ff13d883b438cbe24dd070f1a5bd7326518d0ec5b2f7159a440b9ae0796638",
            "SandboxKey": "/var/run/docker/netns/55ff13d883b4",
            "Ports": {
                "80/tcp": [
                    {
                        "HostIp": "0.0.0.0",
                        "HostPort": "80"
                    },
                    {
                        "HostIp": "::",
                        "HostPort": "80"
                    }
                ]
            },
            "HairpinMode": false,
            "LinkLocalIPv6Address": "",
            "LinkLocalIPv6PrefixLen": 0,
            "SecondaryIPAddresses": null,
            "SecondaryIPv6Addresses": null,
            "EndpointID": "f1c7d3ab7bf58d4300ba31cc9e9e31dcf8a282f9be3ed90682d215b306ed1c5b",
            "Gateway": "172.17.0.1",
            "GlobalIPv6Address": "",
            "GlobalIPv6PrefixLen": 0,
            "IPAddress": "172.17.0.2",
            "IPPrefixLen": 16,
            "IPv6Gateway": "",
            "MacAddress": "4e:da:df:01:3d:98",
            "Networks": {
                "bridge": {
                    "IPAMConfig": null,
                    "Links": null,
                    "Aliases": null,
                    "MacAddress": "4e:da:df:01:3d:98",
                    "DriverOpts": null,
                    "GwPriority": 0,
                    "NetworkID": "68c69a7aec35495886aabcad95f06e948767abbccc7122687378d0c174efbdf4",
                    "EndpointID": "f1c7d3ab7bf58d4300ba31cc9e9e31dcf8a282f9be3ed90682d215b306ed1c5b",
                    "Gateway": "172.17.0.1",
                    "IPAddress": "172.17.0.2",
                    "IPPrefixLen": 16,
                    "IPv6Gateway": "",
                    "GlobalIPv6Address": "",
                    "GlobalIPv6PrefixLen": 0,
                    "DNSNames": null
                }
            }
        }
    }
]
modemfux@docker-vm-nb:~$ docker inspect WEB02 | grep -A 100 "NetworkSettings"
        "NetworkSettings": {
            "Bridge": "",
            "SandboxID": "5a7ff3ceca8e9e7e96cb694fb74e7eeb989a1faa1a09ed925a53f32fe675df9d",
            "SandboxKey": "/var/run/docker/netns/5a7ff3ceca8e",
            "Ports": {
                "80/tcp": [
                    {
                        "HostIp": "0.0.0.0",
                        "HostPort": "8080"
                    },
                    {
                        "HostIp": "::",
                        "HostPort": "8080"
                    }
                ]
            },
            "HairpinMode": false,
            "LinkLocalIPv6Address": "",
            "LinkLocalIPv6PrefixLen": 0,
            "SecondaryIPAddresses": null,
            "SecondaryIPv6Addresses": null,
            "EndpointID": "1fee50af2e6bb00ea9b04d2c4029857adcfc0f5acbaf427f8ca6e4c21d46aea9",
            "Gateway": "172.17.0.1",
            "GlobalIPv6Address": "",
            "GlobalIPv6PrefixLen": 0,
            "IPAddress": "172.17.0.3",
            "IPPrefixLen": 16,
            "IPv6Gateway": "",
            "MacAddress": "06:2f:6b:ab:a6:b4",
            "Networks": {
                "bridge": {
                    "IPAMConfig": null,
                    "Links": null,
                    "Aliases": null,
                    "MacAddress": "06:2f:6b:ab:a6:b4",
                    "DriverOpts": null,
                    "GwPriority": 0,
                    "NetworkID": "68c69a7aec35495886aabcad95f06e948767abbccc7122687378d0c174efbdf4",
                    "EndpointID": "1fee50af2e6bb00ea9b04d2c4029857adcfc0f5acbaf427f8ca6e4c21d46aea9",
                    "Gateway": "172.17.0.1",
                    "IPAddress": "172.17.0.3",
                    "IPPrefixLen": 16,
                    "IPv6Gateway": "",
                    "GlobalIPv6Address": "",
                    "GlobalIPv6PrefixLen": 0,
                    "DNSNames": null
                }
            }
        }
    }
]
modemfux@docker-vm-nb:~$
```

```linux
modemfux@docker-vm-nb:~$ docker exec -it WEB01 /bin/bash
root@da5b48e71920:/# ip -br a show
lo               UNKNOWN        127.0.0.1/8 ::1/128
eth0@if36        UP             172.17.0.2/16
root@da5b48e71920:/# ping -c 2 172.17.0.3
PING 172.17.0.3 (172.17.0.3) 56(84) bytes of data.
64 bytes from 172.17.0.3: icmp_seq=1 ttl=64 time=0.063 ms
64 bytes from 172.17.0.3: icmp_seq=2 ttl=64 time=0.107 ms

--- 172.17.0.3 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1033ms
rtt min/avg/max/mdev = 0.063/0.085/0.107/0.022 ms
root@da5b48e71920:/# ping -c 2 172.17.0.1
PING 172.17.0.1 (172.17.0.1) 56(84) bytes of data.
64 bytes from 172.17.0.1: icmp_seq=1 ttl=64 time=0.085 ms
64 bytes from 172.17.0.1: icmp_seq=2 ttl=64 time=0.143 ms

--- 172.17.0.1 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1032ms
rtt min/avg/max/mdev = 0.085/0.114/0.143/0.029 ms
root@da5b48e71920:/# ping -c 2 ya.ru
PING ya.ru (77.88.55.242) 56(84) bytes of data.
64 bytes from ya.ru (77.88.55.242): icmp_seq=1 ttl=52 time=14.8 ms
64 bytes from ya.ru (77.88.55.242): icmp_seq=2 ttl=52 time=15.1 ms

--- ya.ru ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1002ms
rtt min/avg/max/mdev = 14.785/14.957/15.129/0.172 ms
root@da5b48e71920:/# ping -c 2 WEB01
ping: WEB01: Name or service not known
root@da5b48e71920:/# ping -c 2 WEB02
ping: WEB02: Name or service not known
root@da5b48e71920:/#
```

Создаем новую сеть типа `bridge`:

```linux
modemfux@docker-vm-nb:~$ docker network create --gateway 192.168.0.1 --driver bridge --subnet 192.168.0.0/24 NET
595f2f902e4e42446aef56c6eebba794456668f77e3489d3275e65e428e06d21
modemfux@docker-vm-nb:~$ docker networks ls
docker: unknown command: docker networks

Run 'docker --help' for more information
modemfux@docker-vm-nb:~$ docker network ls
NETWORK ID     NAME      DRIVER    SCOPE
595f2f902e4e   NET       bridge    local
68c69a7aec35   bridge    bridge    local
c604d91d1acf   host      host      local
2a19832f71a2   none      null      local
modemfux@docker-vm-nb:~$ docker inspect NET
[
    {
        "Name": "NET",
        "Id": "595f2f902e4e42446aef56c6eebba794456668f77e3489d3275e65e428e06d21",
        "Created": "2025-05-04T08:49:38.191568154Z",
        "Scope": "local",
        "Driver": "bridge",
        "EnableIPv4": true,
        "EnableIPv6": false,
        "IPAM": {
            "Driver": "default",
            "Options": {},
            "Config": [
                {
                    "Subnet": "192.168.0.0/24",
                    "Gateway": "192.168.0.1"
                }
            ]
        },
        "Internal": false,
        "Attachable": false,
        "Ingress": false,
        "ConfigFrom": {
            "Network": ""
        },
        "ConfigOnly": false,
        "Containers": {},
        "Options": {},
        "Labels": {}
    }
]
modemfux@docker-vm-nb:~$ ip -br -c link
lo               UNKNOWN        00:00:00:00:00:00 <LOOPBACK,UP,LOWER_UP>
eth0             UP             00:0c:29:df:eb:8b <BROADCAST,MULTICAST,UP,LOWER_UP>
docker0          UP             36:e6:80:30:63:93 <BROADCAST,MULTICAST,UP,LOWER_UP>
br-595f2f902e4e  DOWN           5e:0f:e7:e8:e2:ba <NO-CARRIER,BROADCAST,MULTICAST,UP>
modemfux@docker-vm-nb:~$ ip -c -br a show
lo               UNKNOWN        127.0.0.1/8 ::1/128
eth0             UP             10.250.254.111/24 fe80::20c:29ff:fedf:eb8b/64
docker0          UP             172.17.0.1/16 fe80::34e6:80ff:fe30:6393/64
br-595f2f902e4e  DOWN           192.168.0.1/24 fe80::5c0f:e7ff:fee8:e2ba/64
modemfux@docker-vm-nb:~$
```

Создаем и запускаем контейнеры уже в новой сети:

```linux
modemfux@docker-vm-nb:~$ docker run -d --rm --name WEB01 -p 80:80 --network NET sample_nginx:3
4156e0df2b79a9bf4219f4ab6e9d15c756d94985cde74d59d974a835c4b228d9
modemfux@docker-vm-nb:~$ docker run -d --rm --name WEB02 -p 8080:80 --network NET sample_nginx:3
ada8718a1f83a1e1ac597a5ff6fdf8f446a6319105a5ed3be2c546696b7c6236
modemfux@docker-vm-nb:~$ docker ps
CONTAINER ID   IMAGE            COMMAND                  CREATED          STATUS          PORTS                                     NAMES
ada8718a1f83   sample_nginx:3   "nginx -g 'daemon of…"   4 seconds ago    Up 4 seconds    0.0.0.0:8080->80/tcp, [::]:8080->80/tcp   WEB02
4156e0df2b79   sample_nginx:3   "nginx -g 'daemon of…"   13 seconds ago   Up 12 seconds   0.0.0.0:80->80/tcp, [::]:80->80/tcp       WEB01
modemfux@docker-vm-nb:~$ docker inspect WEB01 | grep -A 100 "NetworkSettings"
        "NetworkSettings": {
            "Bridge": "",
            "SandboxID": "de8652fd0f2b0e4c2a64920da7439645474ae9297674a49efae744dedc1c78c7",
            "SandboxKey": "/var/run/docker/netns/de8652fd0f2b",
            "Ports": {
                "80/tcp": [
                    {
                        "HostIp": "0.0.0.0",
                        "HostPort": "80"
                    },
                    {
                        "HostIp": "::",
                        "HostPort": "80"
                    }
                ]
            },
            "HairpinMode": false,
            "LinkLocalIPv6Address": "",
            "LinkLocalIPv6PrefixLen": 0,
            "SecondaryIPAddresses": null,
            "SecondaryIPv6Addresses": null,
            "EndpointID": "",
            "Gateway": "",
            "GlobalIPv6Address": "",
            "GlobalIPv6PrefixLen": 0,
            "IPAddress": "",
            "IPPrefixLen": 0,
            "IPv6Gateway": "",
            "MacAddress": "",
            "Networks": {
                "NET": {
                    "IPAMConfig": null,
                    "Links": null,
                    "Aliases": null,
                    "MacAddress": "ee:ea:1f:99:c2:12",
                    "DriverOpts": null,
                    "GwPriority": 0,
                    "NetworkID": "595f2f902e4e42446aef56c6eebba794456668f77e3489d3275e65e428e06d21",
                    "EndpointID": "85009eacd7f239060ea6cf8b9f3a16fcefcab17c8a6563683635bf72803c4cd6",
                    "Gateway": "192.168.0.1",
                    "IPAddress": "192.168.0.2",
                    "IPPrefixLen": 24,
                    "IPv6Gateway": "",
                    "GlobalIPv6Address": "",
                    "GlobalIPv6PrefixLen": 0,
                    "DNSNames": [
                        "WEB01",
                        "4156e0df2b79"
                    ]
                }
            }
        }
    }
]
modemfux@docker-vm-nb:~$ docker inspect WEB02 | grep -A 100 "NetworkSettings"
        "NetworkSettings": {
            "Bridge": "",
            "SandboxID": "78cc09d0b55eacb5ecce92ab4aaa3d48425417f1ff3fe6d36fe0cbf8739b9f98",
            "SandboxKey": "/var/run/docker/netns/78cc09d0b55e",
            "Ports": {
                "80/tcp": [
                    {
                        "HostIp": "0.0.0.0",
                        "HostPort": "8080"
                    },
                    {
                        "HostIp": "::",
                        "HostPort": "8080"
                    }
                ]
            },
            "HairpinMode": false,
            "LinkLocalIPv6Address": "",
            "LinkLocalIPv6PrefixLen": 0,
            "SecondaryIPAddresses": null,
            "SecondaryIPv6Addresses": null,
            "EndpointID": "",
            "Gateway": "",
            "GlobalIPv6Address": "",
            "GlobalIPv6PrefixLen": 0,
            "IPAddress": "",
            "IPPrefixLen": 0,
            "IPv6Gateway": "",
            "MacAddress": "",
            "Networks": {
                "NET": {
                    "IPAMConfig": null,
                    "Links": null,
                    "Aliases": null,
                    "MacAddress": "8a:68:69:2c:94:73",
                    "DriverOpts": null,
                    "GwPriority": 0,
                    "NetworkID": "595f2f902e4e42446aef56c6eebba794456668f77e3489d3275e65e428e06d21",
                    "EndpointID": "112445898c389c7c6a7d1f9a97786de4f2babf3022d4e3932305e720739305ef",
                    "Gateway": "192.168.0.1",
                    "IPAddress": "192.168.0.3",
                    "IPPrefixLen": 24,
                    "IPv6Gateway": "",
                    "GlobalIPv6Address": "",
                    "GlobalIPv6PrefixLen": 0,
                    "DNSNames": [
                        "WEB02",
                        "ada8718a1f83"
                    ]
                }
            }
        }
    }
]
modemfux@docker-vm-nb:~$
```

Проверяем:

```linux
modemfux@docker-vm-nb:~$ docker exec -it WEB01 /bin/bash
root@4156e0df2b79:/# ip -c -br a
lo               UNKNOWN        127.0.0.1/8 ::1/128
eth0@if41        UP             192.168.0.2/24
root@4156e0df2b79:/# ping -c 2 192.168.0.3
PING 192.168.0.3 (192.168.0.3) 56(84) bytes of data.
64 bytes from 192.168.0.3: icmp_seq=1 ttl=64 time=0.645 ms
64 bytes from 192.168.0.3: icmp_seq=2 ttl=64 time=0.136 ms

--- 192.168.0.3 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1065ms
rtt min/avg/max/mdev = 0.136/0.390/0.645/0.254 ms
root@4156e0df2b79:/# ping -c 2 ya.ru
PING ya.ru (77.88.55.242) 56(84) bytes of data.
64 bytes from ya.ru (77.88.55.242): icmp_seq=1 ttl=52 time=13.2 ms
64 bytes from ya.ru (77.88.55.242): icmp_seq=2 ttl=52 time=15.3 ms

--- ya.ru ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1001ms
rtt min/avg/max/mdev = 13.229/14.250/15.271/1.021 ms
root@4156e0df2b79:/# ping -c 2 WEB02
PING WEB02 (192.168.0.3) 56(84) bytes of data.
64 bytes from WEB02.NET (192.168.0.3): icmp_seq=1 ttl=64 time=0.153 ms
64 bytes from WEB02.NET (192.168.0.3): icmp_seq=2 ttl=64 time=0.046 ms

--- WEB02 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1002ms
rtt min/avg/max/mdev = 0.046/0.099/0.153/0.053 ms
root@4156e0df2b79:/# ping -c 2 WEB01
PING WEB01 (192.168.0.2) 56(84) bytes of data.
64 bytes from 4156e0df2b79 (192.168.0.2): icmp_seq=1 ttl=64 time=0.037 ms
64 bytes from 4156e0df2b79 (192.168.0.2): icmp_seq=2 ttl=64 time=0.093 ms

--- WEB01 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1030ms
rtt min/avg/max/mdev = 0.037/0.065/0.093/0.028 ms
root@4156e0df2b79:/#
```

Теперь у нас контейнеры друг к другу могут обращаться и по именам.

### Запуск контейнера со статически IP-адресом

```linux
modemfux@docker-vm-nb:~$ docker run -d --name WEB03 --network NET --ip 192.168.0.200 -p 8880:80 sample_nginx:3
9d065a46cf37378a89963fc1f82ab4a3bfa89ee1e087269590652cf93d499a09
modemfux@docker-vm-nb:~$ docker ps
CONTAINER ID   IMAGE            COMMAND                  CREATED         STATUS         PORTS                                     NAMES
9d065a46cf37   sample_nginx:3   "nginx -g 'daemon of…"   4 seconds ago   Up 3 seconds   0.0.0.0:8880->80/tcp, [::]:8880->80/tcp   WEB03
ada8718a1f83   sample_nginx:3   "nginx -g 'daemon of…"   8 minutes ago   Up 8 minutes   0.0.0.0:8080->80/tcp, [::]:8080->80/tcp   WEB02
4156e0df2b79   sample_nginx:3   "nginx -g 'daemon of…"   8 minutes ago   Up 8 minutes   0.0.0.0:80->80/tcp, [::]:80->80/tcp       WEB01
modemfux@docker-vm-nb:~$ docker exec WEB03 ip -br -c a
lo               UNKNOWN        127.0.0.1/8 ::1/128
eth0@if47        UP             192.168.0.200/24
modemfux@docker-vm-nb:~$ docker stop WEB03
WEB03
modemfux@docker-vm-nb:~$ docker start WEB03
WEB03
modemfux@docker-vm-nb:~$ docker exec WEB03 ip -br -c a
lo               UNKNOWN        127.0.0.1/8 ::1/128
eth0@if49        UP             192.168.0.200/24
modemfux@docker-vm-nb:~$ docker exec WEB03 ping WEB01
PING WEB01 (192.168.0.2) 56(84) bytes of data.
64 bytes from WEB01.NET (192.168.0.2): icmp_seq=1 ttl=64 time=0.103 ms
64 bytes from WEB01.NET (192.168.0.2): icmp_seq=2 ttl=64 time=0.074 ms
^Ccontext canceled
modemfux@docker-vm-nb:~$ docker exec WEB01 ping WEB03
PING WEB03 (192.168.0.200) 56(84) bytes of data.
64 bytes from WEB03.NET (192.168.0.200): icmp_seq=1 ttl=64 time=0.064 ms
64 bytes from WEB03.NET (192.168.0.200): icmp_seq=2 ttl=64 time=0.103 ms
^Ccontext canceled
modemfux@docker-vm-nb:~$
```

## Вывести контейнер в общую сеть с сетевым интерфейсом

Для этого используется сеть типа `macvlan` или `ipvlan`.

```linux
modemfux@docker-vm-nb:~$ docker network create \
> --driver=macvlan \
> --gateway=10.250.254.1 \
> --subnet=10.250.254.0/24 \
> --ip-range=10.250.254.64/30 \
> --opt parent=eth0 \
> NB_NET
2628c4b4a767488f8241cec8d8e9fe660f36c2d9c2b576559597164fea9bd355
modemfux@docker-vm-nb:~$ docker network inspect NB_NET
[
    {
        "Name": "NB_NET",
        "Id": "2628c4b4a767488f8241cec8d8e9fe660f36c2d9c2b576559597164fea9bd355",
        "Created": "2025-05-04T09:27:51.844939947Z",
        "Scope": "local",
        "Driver": "macvlan",
        "EnableIPv4": true,
        "EnableIPv6": false,
        "IPAM": {
            "Driver": "default",
            "Options": {},
            "Config": [
                {
                    "Subnet": "10.250.254.0/24",
                    "IPRange": "10.250.254.64/30",
                    "Gateway": "10.250.254.1"
                }
            ]
        },
        "Internal": false,
        "Attachable": false,
        "Ingress": false,
        "ConfigFrom": {
            "Network": ""
        },
        "ConfigOnly": false,
        "Containers": {},
        "Options": {
            "parent": "eth0"
        },
        "Labels": {}
    }
]
modemfux@docker-vm-nb:~$
```

```linux
modemfux@docker-vm-nb:~$ docker run -d --network NB_NET --name WEB01 sample_nginx:3
89f7e89dc2a99e624ca3414254604e049718f1205adcf1da413b6838b1254985
modemfux@docker-vm-nb:~$ docker run -d --network NB_NET --name WEB02 sample_nginx:3
e26b2d8c9ebf711c91cc801a103f5527138f3b94dc44c9c5e3a248b51d9adc85
modemfux@docker-vm-nb:~$ docker run -d --network NB_NET --name WEB03 sample_nginx:3
4963fc92f2cce2af46d5968b5334fed58cfeaf62429c074229346aba532e1740
modemfux@docker-vm-nb:~$ docker run -d --network NB_NET --name WEB04 sample_nginx:3
b4992aa3dea59ccf0127f4c85b2d498543a4345c18ac1f3e8adb52b688385daf
```

```huawei
<nn-van28a-r01>dis arp int vlan254
IP ADDRESS      MAC ADDRESS     EXPIRE(M) TYPE        INTERFACE   VPN-INSTANCE
                                    VLAN/CEVLAN(SIP/DIP)      PVC
------------------------------------------------------------------------------
10.250.254.1    2c9d-1ec7-ee19            I -         Vlanif254      LAN
10.250.254.100  d493-9020-15b1  6         D-0         GE0/0/2        LAN
                                           254/-
10.250.254.111  000c-29df-eb8b  15        D-0         GE0/0/2        LAN
                                           254/-
10.250.254.64   9e12-f086-7301  20        D-0         GE0/0/2        LAN
                                           254/-
10.250.254.65   4ed0-69e7-1278  20        D-0         GE0/0/2        LAN
                                           254/-
10.250.254.66   4ab8-8562-2eeb  20        D-0         GE0/0/2        LAN
                                           254/-
10.250.254.67   02a2-0bbe-baa9  20        D-0         GE0/0/2        LAN
                                           254/-
------------------------------------------------------------------------------
Total:7         Dynamic:6       Static:0     Interface:1
<nn-van28a-r01>
```

```cmd
PS C:\Users\modem\AppData\Roaming\MobaXterm\home> curl http://10.250.254.64/


StatusCode        : 200
StatusDescription : OK
Content           : <!DOCTYPE html>
                    <html>
                    <head>
                    <title>Welcome to nginx!</title>
                    <style>
                    html { color-scheme: light dark; }
                    body { width: 35em; margin: 0 auto;
                    font-family: Tahoma, Verdana, Arial, sans-serif; }
                    </style...
RawContent        : HTTP/1.1 200 OK
                    Connection: keep-alive
                    Accept-Ranges: bytes
                    Content-Length: 615
                    Content-Type: text/html
                    Date: Sun, 04 May 2025 09:32:09 GMT
                    ETag: "681727d4-267"
                    Last-Modified: Sun, 04 May 2025 ...
Forms             : {}
Headers           : {[Connection, keep-alive], [Accept-Ranges, bytes], [Content-Length, 615], [Content-Type, text/html]...}
Images            : {}
InputFields       : {}
Links             : {@{innerHTML=nginx.org; innerText=nginx.org; outerHTML=<A href="http://nginx.org/">nginx.org</A>; outerText=nginx.org; tagName=A; href=http://nginx.org/}, @{innerHTML=nginx.com; innerText=nginx.com; outerHTML=<A href="http://nginx.com/">nginx.com</A
                    >; outerText=nginx.com; tagName=A; href=http://nginx.com/}}
ParsedHtml        : mshtml.HTMLDocumentClass
RawContentLength  : 615
```

Если попытаться запустить еще один контейнер, то возникнет ошибка, т.к. адреса из диапазона закончились.

```linux
modemfux@docker-vm-nb:~$ docker run -d --network NB_NET --name WEB05 sample_nginx:3
21f0f89088879a3c2123002e08928470a97681779922040f01af70beca8fb561
docker: Error response from daemon: failed to set up container networking: no available IPv4 addresses on this network's address pools: NB_NET (2628c4b4a767488f8241cec8d8e9fe660f36c2d9c2b576559597164fea9bd355)

Run 'docker run --help' for more information
modemfux@docker-vm-nb:~$
```

Но, при этом, спокойно можно будет запустить с указанным вручную адресом:

```linux
modemfux@docker-vm-nb:~$ docker run -d --network NB_NET --ip 10.250.254.68 --name WEB05 sample_nginx:3
09f8ca63a6b5e44d4e23fd2bee1bf7b1fe20409de115550e4f0fe893684b4d84
modemfux@docker-vm-nb:~$
```

```huawei
<nn-van28a-r01>dis arp int vlan254 | i 10.250.254.68
IP ADDRESS      MAC ADDRESS     EXPIRE(M) TYPE        INTERFACE   VPN-INSTANCE
                                    VLAN/CEVLAN(SIP/DIP)      PVC
------------------------------------------------------------------------------
10.250.254.68   aed3-3fd6-4b30  20        D-0         GE0/0/2        LAN
------------------------------------------------------------------------------
Total:8         Dynamic:7       Static:0     Interface:1
<nn-van28a-r01>
```
