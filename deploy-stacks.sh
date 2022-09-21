#!/bin/sh
deploy() {
    name=$(echo "$1" | cut -f 2 -d '/' | cut -f 1 -d '.')
    stackfile=$name.yml
    echo docker stack deploy -c "./enabled/${stackfile}" "${name}"
}

if [ -n "$1" ]
then
    deploy "$1"
else
    for stackfile in enabled/*;
    do
        deploy "$stackfile"
    done
fi
