#!/usr/bin/env bash
D="$(dirname "$(readlink -f "$0")")"

docker run \
    -e DEBUG=1 \
    -e SSH_PRIVATE_KEY_FILE=/secrets/private_key \
    -e RSYNC_SOURCE=/m/source/ \
    -e RSYNC_TARGET=/m/target/ \
    -e RSYNC_OPTIONS=-avz \
    -u "$(id -u)" \
    -v "$D/test/source:/m/source" \
    -v "$D/test/target:/m/target" \
    -v "$D/secrets/private_key:/secrets/private_key" \
    -v "$D/entrypoint:/entrypoint" \
    "secoresearch/rsync:latest"
