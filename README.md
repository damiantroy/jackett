# Jackett torrent search engine aggregator

This is a CentOS 7 container for [Jackett](https://github.com/Jackett/Jackett), which gives API Support for your favorite torrent trackers.

## Building

To build and test the image, run:

```shell script
make all # build test
```

## Running

More complete instructions are in my [VideoBot Tutorial](https://github.com/damiantroy/videobot),
but this should be enough to get you started.

### Configuration

| Command | Config   | Description
| ------- | -------- | -----
| ENV     | PUID     | UID of the runtime user (Default: 1001)
| ENV     | PGID     | GID of the runtime group (Default: 1001)
| ENV     | TZ       | Timezone (Default: Australia/Melbourne)
| VOLUME  | /config  | Configuration directory
| EXPOSE  | 9117/tcp | HTTP port for Jackett


```shell script
PUID=1001
PGID=1001
TZ=Australia/Melbourne
VIDEOS_DIR=/videos
JACKETT_CONFIG_DIR=/etc/config/jackett
JACKETT_IMAGE=localhost/jackett # Or damiantroy/jackett if deploying from docker.io

sudo mkdir -p ${VIDEOS_DIR} ${JACKETT_CONFIG_DIR}
sudo chown -R ${PUID}:${PGID} ${VIDEOS_DIR} ${JACKETT_CONFIG_DIR}

sudo podman run -d \
    --name=jackett \
    --network host \
    -e PUID=${PUID} \
    -e PGID=${PGID} \
    -e TZ=${TZ} \
    -v ${JACKETT_CONFIG_DIR}:/config:Z \
    -v ${VIDEOS_DIR}:/videos:z \
    ${JACKETT_IMAGE}
```
