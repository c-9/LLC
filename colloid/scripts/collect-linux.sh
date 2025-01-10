#!/bin/bash

config="colloidv3-default-gupsrw"
gups_path=/home/zjq/colloid/apps/gups
mio_path=/home/zjq/mio-colloid
record_path=/home/zjq/colloid/colloid-stats
stats_path=/home/zjq/membw-eval

echo "App Throughput, no background traffic"
cat $stats_path/$config-iso.gups.txt | tail -n 30 | awk '{sum+=$1} END {print (sum/NR)*2*4096/1e9;}'

echo "App Throughput, with background traffic"
cat $stats_path/$config-bg.gups.txt | tail -n 30 | awk '{sum+=$1} END {print (sum/NR)*2*4096/1e9;}'

# Local DRAM BW usage
echo "Local DRAM BW usage, no background traffic (app, page migration)"
paste <(cat $stats_path/$config-iso.gups.txt | tail -n 30) <(cat $stats_path/$config-iso.stats.txt | tail -n 30) | awk '{print ($4*64+$5*64-$10*4096-$11*4096)/1e9, ($10*4096+$11*4096)/1e9}' | awk '{sum1 += $1; sum2 += $2} END {print sum1/NR, sum2/NR;}';
echo "Local DRAM BW usage, with background traffic (app, background, page migration)"
paste <(cat $stats_path/$config-bg.gups.txt | tail -n 30) <(cat $stats_path/$config-bg.stats.txt | tail -n 30) | awk '{print (2*$1*4096 - $6*64 - $7*64 + $10*4096 + $11*4096)/1e9, ($4*64+$5*64-2*$1*4096 + $6*64 + $7*64 - 2*$10*4096 - 2*$11*4096)/1e9, ($10*4096 + $11*4096)/1e9}' | awk '{sum1 += $1; sum2 += $2; sum3 += $3;} END {print sum1/NR, sum2/NR, sum3/NR}';

# UPI Rx BW usage
echo "UPI Rx BW usage, no background traffic (data, non-data)"
cat $stats_path/$config-iso.stats.txt | tail -n 30 | awk '{print $5*64/1e9, $7*64/1e9}' | awk '{sum1 += $1; sum2 += $2} END {print sum1/NR, sum2/NR;}'
echo "UPI Rx BW usage, with background traffic (data, non-data)"
cat $stats_path/$config-bg.stats.txt | tail -n 30 | awk '{print $5*64/1e9, $7*64/1e9}' | awk '{sum1 += $1; sum2 += $2} END {print sum1/NR, sum2/NR;}'

# UPI Tx BW usage
echo "UPI Tx BW usage, no background traffic (data, non-data)"
cat $stats_path/$config-iso.stats.txt | tail -n 30 | awk '{print $6*64/1e9, $8*64/1e9}' | awk '{sum1 += $1; sum2 += $2} END {print sum1/NR, sum2/NR;}'
echo "UPI Tx BW usage, with background traffic (data, non-data)"
cat $stats_path/$config-bg.stats.txt | tail -n 30 | awk '{print $6*64/1e9, $8*64/1e9}' | awk '{sum1 += $1; sum2 += $2} END {print sum1/NR, sum2/NR;}'

# App hit rate
echo "App hit rate, no background traffic"
paste <(cat $stats_path/$config-iso.gups.txt | tail -n 30) <(cat $stats_path/$config-iso.stats.txt | tail -n 30) | awk '{print (2*$1*4096 - $6*64 -$7*64 + $10*4096 + $11*4096)/(2*$1*4096)}' | awk '{sum1 += $1;} END {print sum1/NR}';
echo "App hit rate, with background traffic"
paste <(cat $stats_path/$config-bg.gups.txt | tail -n 30) <(cat $stats_path/$config-bg.stats.txt | tail -n 30) | awk '{print (2*$1*4096 - $6*64 -$7*64 + $10*4096 + $11*4096)/(2*$1*4096)}' | awk '{sum1 += $1;} END {print sum1/NR}';

