There are many variables and options available to customize how deluge is ran.

## User configuration options

You may set the following parameters to customize the user id that runs deluge.

| Variable | Function                              | Defaults   |
| -------- | ------------------------------------- | ---------- |
| `PUID`   | Sets the user id who will run deluge  | `PUID=911` |
| `PGID`   | Sets the group id for the deluge user | `PGID=911` |

## Deluge environment options

The below are example settings, while some may actually be the defaults, some variables are unset.

| Variable                  | Function                      | Defaults                                 |
| ------------------------- | ----------------------------- | ---------------------------------------- |
| `DELUGE_HOME`             | Deluge config files           | `DELUGE_HOME=/deluge-home`               |
| `DELUGE_DOWNLOAD_DIR`     | Completed downloads           | `DELUGE_DOWNLOAD_DIR=/data/completed`    |
| `DELUGE_INCOMPLETE_DIR`   | Incomplete downloads          | `DELUGE_INCOMPLETE_DIR=/data/incomplete` |
| `DELUGE_WATCH_DIR`        | Folder for importing torrents | `DELUGE_WATCH_DIR=/data/watched`         |
| `DELUGE_TORRENT_BACKUP`   | Torrent file backups          | `DELUGE_TORRENT_BACKUP=/data/torrents`   |
| `DELUGE_DAEMON_LOG_LEVEL` | Deluge daemon log level       | `DELUGE_DAEMON_LOG_LEVEL=info`           |
| `DELUGE_WEB_LOG_LEVEL`    | Deluge web log level          | `DELUGE_WEB_LOG_LEVEL=info`              |

## SSL configuration options for create_cert.sh

This script can be manually ran to generate the certificate or automatically.

```bash
/scripts/create_cert.sh
```

| Variable  | Function                              | Defaults |
| --------- | ------------------------------------- | -------- |
| `SSL`     | Enables SSL within deluge             | yes      |
| `GENCERT` | Generates SSL Cert with below options | unset    |

| Variable     | Defaults                   |
| ------------ | -------------------------- |
| `Country`    | `Country=US`               |
| `State`      | `State=Reach`              |
| `Locality`   | `Locality=Sector9`         |
| `Company`    | `Company=MediaServices`    |
| `Department` | `Department=Mediaservices` |
| `HostName`   | `HostName=MediaBox.local`  |
