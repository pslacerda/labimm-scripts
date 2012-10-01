#!/bin/bash

#
function usage {
    sed -n '0,/# -\+$/d;/# -\+$/,$d;s/^#\s\?//g;p' "$0" > /dev/stderr
}

function error {
    put red "$@" > /dev/stderr
    exit 1
}

function quit {
    echo "$2"
    exit $1
}

##
# array-contains 
#
#  Description:
#       check if an array contains an value.
#
#  Synopsis:
#       array-contains value array
#
#  Example:
#       $ arr=("a" "bb" "ccc")
#       $ array-contains "xyz" "${arr[@]}"; echo $?
#       > 1
#       $ array-contains "bb" "${arr[@]}"; echo $?
#       > 0
#
function array-contains() {
    for elem in "${@:2}"; do
        [[ "$elem" == "$1" ]] && return 0;
    done
    return 1;
}


function put {

    local -A colors=( [red]=1 [green]=2 [yellow]=3 [blue]=4 [purple]=5 \
        [cyan]=6 [white]=7 [black]=8 )
    
    if [[ $# == 1 ]]; then
        local message="$1"
        echo $message

    elif [[ $# == 2 ]]; then
        local color="${colors[$1]}"
        local message="$2"

        if [[ ! -z $color ]]; then
            echo -n `tput bold`
            echo -n `tput setaf $color`
        fi
        echo $message
        echo -n `tput sgr0` 
    else
        return 1
    fi

    return 0
}
