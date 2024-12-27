#!/bin/bash

scripts_path="${BASH_SOURCE%/*}/../../scripts"
gups_path="${BASH_SOURCE%/*}/../../apps/gups"
duration=600
i=15 # no. of app cores

prefix="tpp"
if [ -n "$PREFIX" ]; then
    prefix="$PREFIX"
fi

# TPP
echo "Running TPP"
for b in 0 5 10 15;
    do MIO_STATS="--stats_colloid_mbm --stats_colloid_wait 570" $scripts_path/linux.sh $prefix-gups64-rw-app$i-bg$b $duration $i $b -- $gups_path/gups64-rw $i; 
done;

# TPP+colloid
echo "Running TPP+colloid"
for b in 0 5 10 15;
    do MIO_STATS="--stats_colloid_mbm --stats_colloid_wait 570" $scripts_path/linux-colloid.sh $prefix-colloid-gups64-rw-app$i-bg$b $duration $i $b -- $gups_path/gups64-rw $i; 
done;
