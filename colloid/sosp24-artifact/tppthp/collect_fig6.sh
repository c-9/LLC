#!/bin/bash

scripts_path="${BASH_SOURCE%/*}/../../scripts"
i=15 # no. of app cores
bg_cores=$(($1*5)) #background traffic cores (0x => 0, 1x => 5, 2x => 10, 3x => 15)
b=$bg_cores;

printf "%-15s %-15s %-15s %-15s\n" "Latency" "tppthp" "tppthp+colloid" "Perf. Improvement"

tpp_output=$(python3 $scripts_path/collect_ts.py tpp-thp-gups64-rw-app$i-bg$b gups | tail -n 30 | awk '{s += $1;} END {print (s/NR)*64*2/1e9;}')
tpp_colloid_output=$(python3 $scripts_path/collect_ts.py tpp-thp-colloid-gups64-rw-app$i-bg$b gups | tail -n 30 | awk '{s += $1;} END {print (s/NR)*64*2/1e9;}')
impr=$(awk -v num="$tpp_colloid_output" -v den="$tpp_output" 'BEGIN {print num/den;}')
printf "%-15s %-15s %-15s %-15s\n" "135" "$tpp_output" "$tpp_colloid_output" "$impr"

unc_regs=("0x818" "0x70e" "0x50a" "0x408")
unc_lats=(135 148 168 192)

for idx in 1 2 3; do
    u="${unc_regs[$idx]}"
    tpp_output=$(python3 $scripts_path/collect_ts.py tpp-thp-unc$u-gups64-rw-app$i-bg$b gups | tail -n 30 | awk '{s += $1;} END {print (s/NR)*64*2/1e9;}')
    tpp_colloid_output=$(python3 $scripts_path/collect_ts.py tpp-thp-colloid-unc$u-gups64-rw-app$i-bg$b gups | tail -n 30 | awk '{s += $1;} END {print (s/NR)*64*2/1e9;}')
    impr=$(awk -v num="$tpp_colloid_output" -v den="$tpp_output" 'BEGIN {print num/den;}')
    printf "%-15s %-15s %-15s %-15s\n" "${unc_lats[$idx]}" "$tpp_output" "$tpp_colloid_output" "$impr"
done