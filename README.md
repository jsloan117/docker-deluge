# docker-deluge

![License](https://img.shields.io/badge/License-GPLv3-blue.svg)
[![Build Status](https://travis-ci.com/jsloan117/docker-deluge.svg?branch=master)](https://travis-ci.com/jsloan117/docker-deluge)
[![Docker Pulls](https://img.shields.io/docker/pulls/jsloan117/deluge.svg)](https://img.shields.io/docker/pulls/jsloan117/deluge.svg)

Deluge BitTorrent client

## Quickstart

The below is a quick method to get this up and running. Please see the full documentation for more options.

The default password for the webui is "deluge".

```bash
docker run -d --name deluge \
-v deluge:/deluge-home \
-v /path/to/deluge/download-data:/data \
-p 8112:8112 \
jsloan117/deluge
```

## Documentation

The full documentation is available [here](http://jsloan117.github.io/docker-deluge).
