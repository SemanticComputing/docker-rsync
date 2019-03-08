#!/bin/bash

set -euo pipefail

usage() {
    echo "Usage: $0 <template-yaml> <param-file>"
}

if [ $# -ne 2 ]; then
    usage
    exit 1
fi

YAML="$(oc process -f "$1" --param-file "$2")"
echo "$YAML"
read -p "Create these resoures (y/n): " prompt

if [ "$prompt" == "y" ]; then
    echo "$YAML" | oc create -f -
fi

