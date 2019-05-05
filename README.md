# docker-deluge

Docker container for deluge

![License](https://img.shields.io/badge/License-GPLv3-blue.svg)
![Docker Cloud Automated build](https://img.shields.io/docker/cloud/automated/jsloan117/deluge.svg)
[![Docker Pulls](https://img.shields.io/docker/pulls/jsloan117/deluge.svg)](https://img.shields.io/docker/pulls/jsloan117/deluge.svg)
[![](https://images.microbadger.com/badges/image/jsloan117/deluge.svg)](https://microbadger.com/images/jsloan117/deluge "Get your own image badge on microbadger.com")
[![Codefresh build status]( https://g.codefresh.io/api/badges/pipeline/jsloan117_marketplace/jsloan117%2Fdocker-deluge%2Fdocker-deluge?type=cf-1)]( https://g.codefresh.io/public/accounts/jsloan117_marketplace/pipelines/jsloan117/docker-deluge/docker-deluge)

Docker container based on Alpine with Deluge

## Run container from Docker registry

The container is available from the Docker registry and this is the simplest way to get it.
To run the container use this command:

```bash
$ docker run -d --name deluge \
-v /path/to/deluge/download/data:/data \
-v /path/to/deluge/config:/config \
-v /etc/resolv.conf:/etc/resolv.conf:ro \
-v /etc/localtime:/etc/localtime:ro \
--env-file /dockerenvironmentfile/path/DockerEnv \
-p 8112:8112 -p 58846:58846 -p 58946:58946 \
jsloan117/deluge
```

```bash
$ docker run -d --name deluge \
-v /path/to/deluge/download/data:/data \
-v /path/to/deluge/config:/config \
-v /etc/resolv.conf:/etc/resolv.conf:ro \
-v /etc/localtime:/etc/localtime:ro \
-e PUID=996 -e PGID=994 \
-e DELUGE_DOWNLOAD_DIR=/data/completed \
-e DELUGE_INCOMPLETE_DIR=/data/incomplete \
-e DELUGE_WATCH_DIR=/data/watched \
-e DELUGE_TORRENT_BACKUP=/data/torrents \
-e SSL=yes \
-p 8112:8112 -p 58846:58846 -p 58946:58946 \
jsloan117/deluge
```

## Note:

Currently variables DELUGE_HOME & UMASK are not being used, so setting them won't do much.

Default password for the webui is "deluge"
