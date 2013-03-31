#!/bin/bash

usage() {
    sed -n '0,/# -\+$/d;/# -\+$/,$d;s/^#\s\?//g;p' "$0" >&2
}

die() {
    echo "$@" >&2
    exit 1
}

options() {
    getopt -q -n "$0" -o "$1" -l "$2" -- "${@:3:$#}"
}
