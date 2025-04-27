# Docker memo

Для работы без sudo или не из под root'а необходимо добавить пользователя в группу docker:

```linux
modemfux@docker-vm-nb:~$ sudo usermod -aG docker modemfux
modemfux@docker-vm-nb:~$ id
uid=1000(modemfux) gid=1000(modemfux) groups=1000(modemfux),4(adm),24(cdrom),27(sudo),30(dip),46(plugdev),101(lxd),988(docker)
modemfux@docker-vm-nb:~$
```

Скачать образ:

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

Посмотреть список образов:

```linux
modemfux@docker-vm-nb:~$ docker image ls
REPOSITORY   TAG       IMAGE ID       CREATED       SIZE
nginx        latest    4e1b6bae1e48   11 days ago   192MB
modemfux@docker-vm-nb:~$ docker images
REPOSITORY   TAG       IMAGE ID       CREATED       SIZE
nginx        latest    4e1b6bae1e48   11 days ago   192MB
modemfux@docker-vm-nb:~$
```

Посмотреть подробную информацию образа:

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

Создать и запустить контейнер. По умолчанию запускается не в detached mode, для выхода необходимо нажать Ctrl+C.

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

Создать и запустить в detached-режиме:

```linux
modemfux@docker-vm-nb:~$ docker run -d nginx
29ce8023f7e9da17e86a1d74e526d483aa1f46211ae3e710680b3cb6d8a068d1
modemfux@docker-vm-nb:~$
```

Можно задать вручную имя:

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

Посмотреть список запущенных контейнеров:

```linux
modemfux@docker-vm-nb:~$ docker ps
CONTAINER ID   IMAGE     COMMAND                  CREATED          STATUS          PORTS     NAMES
29ce8023f7e9   nginx     "/docker-entrypoint.…"   13 seconds ago   Up 13 seconds   80/tcp    recursing_noyce
```

Посмотреть список всех контейнеров, включая остановленные:

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

Остановить контейнер:

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

Запустить созданный контейнер:

```linux
modemfux@docker-vm-nb:~$ docker start 29ce8023f7e9
29ce8023f7e9
modemfux@docker-vm-nb:~$ docker ps
CONTAINER ID   IMAGE     COMMAND                  CREATED       STATUS         PORTS     NAMES
29ce8023f7e9   nginx     "/docker-entrypoint.…"   3 hours ago   Up 4 seconds   80/tcp    recursing_noyce
modemfux@docker-vm-nb:~$
```

Посмотреть детальную информацию об объекте (контейнере):

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

Посмотреть статистику в реальном времени (чтобы выйти, нужно три раза нажать Ctrl+C)

```linux
modemfux@docker-vm-nb:~$ docker stats 29ce8023f7e9

CONTAINER ID   NAME              CPU %     MEM USAGE / LIMIT     MEM %     NET I/O         BLOCK I/O    PIDS
29ce8023f7e9   recursing_noyce   0.00%     3.094MiB / 7.709GiB   0.04%     1.09kB / 126B   0B / 4.1kB   3
^C
got 3 SIGTERM/SIGINTs, forcefully exiting
```

Чтобы удалить образ необходимо использовать `docker rmi $IMAGE_NAME`:

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
