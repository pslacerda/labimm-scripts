

usage() {
    sed -n '0,/# -\+$/d;/# -\+$/,$d;s/^#\s\?//g;p' "$0" >&2
}

die() {
    echo "$@" >&2
    exit 1
}


options() {
    TEMP=`getopt -o "$1" -l "$2" -n "$0" -- "${@:3:$#}"`
    [[ $? != 0 ]] && die "getopt malformado"
    echo "$TEMP"
}
