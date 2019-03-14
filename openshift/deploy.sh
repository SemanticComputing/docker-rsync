#!/bin/bash

set -euo pipefail

usage() {
    echo "Usage: $0 <template-yaml> <param-file>"
}

if [ $# -ne 2 ]; then
    usage
    exit 1
fi

LABELS=''
while true; do
    read -p "Add a label to resoucres (e.g. 'rsync=example', empty to continue): " label
    if [ -z "$label" ]; then
        break;
    else
        LABELS+="$(printf "%s %q" '-l' "$label")"
    fi
done

YAML="$(oc process -f "$1" --param-file "$2" $LABELS)"
echo "$YAML"
read -p "Create these resoures (y/n): " prompt
if [ "$prompt" == "y" ]; then
    echo "$YAML" | oc apply -f -
fi

