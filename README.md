# Jackett torrent search engine aggregator

## Configuration

| Command | Config   | Description
| ------- | -------- | -----
| ENV     | PUID     | UID of the runtime user (Default: 1001)
| ENV     | PGID     | GID of the runtime group (Default: 1001)
| ENV     | TZ       | Timezone (Default: Australia/Melbourne)
| VOLUME  | /config  | Configuration directory
| EXPOSE  | 9117/tcp | HTTP port for Jackett

## Instructions

Build and run:
```shell script
PUID=1001
PGID=1001
TZ=Australia/Melbourne
VIDEOS_DIR=/videos
JACKETT_CONFIG_DIR=/etc/config/jackett
JACKETT_IMAGE=localhost/jackett # Or damiantroy/jackett if deploying from docker.io

sudo mkdir -p ${VIDEOS_DIR} ${JACKETT_CONFIG_DIR}
sudo chown -R ${PUID}:${PGID} ${VIDEOS_DIR} ${JACKETT_CONFIG_DIR}

# You can skip the 'build' step if deploying from docker.io
sudo podman build -t jackett .

sudo podman run -d \
    --pod video \
    --name=jackett \
    -e PUID=${PUID} \
    -e PGID=${PGID} \
    -e TZ=${TZ} \
    -v ${JACKETT_CONFIG_DIR}:/config:Z \
    -v ${VIDEOS_DIR}:/videos:z \
    ${JACKETT_IMAGE}
```
