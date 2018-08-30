#!/bin/sh
for stackfile in $(ls enabled/);
do
    name=$(echo "${stackfile}" | cut -f 1 -d '.')
    docker stack deploy -c "./enabled/${stackfile}" "${name}"
done
