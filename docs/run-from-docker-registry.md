The image is available from the Docker registry and this is the simplest way to get it.

To run the image use one of the following commands:

```bash
docker run -d --name deluge \
-v deluge:/deluge-home \
-v /path/to/deluge/download-data:/data \
-e PUID=911 -e PGID=911 \
-p 8112:8112 \
jsloan117/deluge
```

Use an environment file:

```bash
docker run -d --name deluge \
-v deluge:/deluge-home \
-v /path/to/deluge/download-data:/data \
--env-file /dockerenvironmentfiles/deluge.env \
-p 8112:8112 \
jsloan117/deluge
```

Using environment variables example:

```bash
docker run -d --name deluge \
-v /data/deluge:/deluge-home \
-v /data/torrents:/data \
-v /etc/resolv.conf:/etc/resolv.conf:ro \
-v /etc/localtime:/etc/localtime:ro \
-e PUID=1000 -e PGID=1000 \
-e DELUGE_DOWNLOAD_DIR=/data/download \
-e DELUGE_INCOMPLETE_DIR=/data/downloading \
-e DELUGE_WATCH_DIR=/data/downloading \
-e DELUGE_TORRENT_BACKUP=/data/torrents \
-e SSL=yes \
-p 8112:8112 \
jsloan117/deluge
```
