#!/bin/bash
for i in $(seq $1 $3 $2)
do
    echo $i
    taskset -c $i mbw -q -n 9999 256 >/dev/null &
done

