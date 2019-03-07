#! /bin/bash

IMAGE="rsync"

set -euo pipefail
D="$(readlink -f "$(dirname "$0")")"
PARAMS=""
while [ $# -gt 0 ] && [[ $1 =~ ^-.* ]]; do
    case $1 in
        --debug) set -x; shift ;;
        --no-cache|-c) PARAMS+=" --no-cache --pull"; shift ;;
        -*) shift ;;
    esac
done

( cd "$D"; docker build $PARAMS -t $IMAGE . )
