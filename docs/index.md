<h1 align="center">
  Deluge
</h1>

<p align="center">
  Deluge BitTorrent client
  <br/><br/>

  <a href="https://github.com/jsloan117/docker-deluge/blob/master/LICENSE">
    <img alt="license" src="https://img.shields.io/badge/License-GPLv3-blue.svg" />
  </a>
  <a href="https://travis-ci.com/jsloan117/docker-deluge">
    <img alt="build" src="https://travis-ci.com/jsloan117/docker-deluge.svg?branch=master" />
  </a>
  <a href="https://hub.docker.com/repository/docker/jsloan117/deluge">
    <img alt="pulls" src="https://img.shields.io/docker/pulls/jsloan117/deluge.svg" />
  </a>
</p>

## Quickstart

The below is a quick method to get this up and running. Please see the other documentation links for further details.

The default password for the webui is "deluge".

```bash
docker run -d --name deluge \
-v deluge:/deluge-home \
-v /path/to/deluge/download-data:/data \
-p 8112:8112 \
jsloan117/deluge
```
