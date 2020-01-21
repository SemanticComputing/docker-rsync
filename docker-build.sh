#! /bin/bash
D="$(dirname "$(readlink -f "$0")")"

docker build -t secoresearch/rsync:latest "$D"
