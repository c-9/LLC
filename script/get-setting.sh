#!/bin/bash
current_dir=$(dirname $0)
source $current_dir/env.sh
export NUMA_NODE=1
export LMBENCH_ROOT=/home/zjq/chunk/git/lmbench

# CPU model/type
echo "CPU model/type"
cat /proc/cpuinfo | grep "model name" | head -1

# CPU cores (physical and logical)
echo "CPU cores (physical and logical)"
lscpu | grep -E "^CPU\(s\)|Core\(s\) per socket|Thread\(s\) per core"

# L2 cache per core
echo "L2 cache per core"
lscpu | grep "L2"

# LLC (Last Level Cache, usually L3)
echo "LLC (Last Level Cache, usually L3)"
lscpu | grep "L3"

# Memory channels and configuration
echo "Memory channels and configuration"
sudo ls /sys/devices/system/edac/mc/ | grep -i mc
sudo ipmctl show -topology
sudo lstopo --no-io
sudo dmidecode -t memory | grep -A16 "Memory Device" | grep -E "Size|Locator|Speed"
sudo lshw -class memory | grep -E "bank|slot|size"

#mem-bench with vtune
echo "mem-bench with vtune"
$current_dir/run_mbw.sh 0 10 2 && sudo /opt/intel/oneapi/vtune/latest/bin64/vtune -collect memory-access -d 20
sleep 25 
pkill -9 mbw

#mem-bench with lmbench
echo "mem-bench with lmbench"
echo "local:"
numactl --cpunodebind=0 --membind=0 $LMBENCH_ROOT/bin/x86_64-pc-linux-gnu/bw_mem -P 16 1000000000 rd
echo "remote:"
numactl --cpunodebind=0 --membind=1 $LMBENCH_ROOT/bin/x86_64-pc-linux-gnu/bw_mem -P 16 1000000000 rd

#lat-bench with lmbench
echo "lat-bench with lmbench"
echo "local:"
numactl --cpunodebind=0 --membind=0 $LMBENCH_ROOT/bin/x86_64-pc-linux-gnu/lat_mem_rd -P 1 -t -N 10 256 1024
echo "remote:"
numactl --cpunodebind=0 --membind=1 $LMBENCH_ROOT/bin/x86_64-pc-linux-gnu/lat_mem_rd -P 1 -t -N 10 256 1024

