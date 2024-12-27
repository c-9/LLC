#!/usr/bin/env bash

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

export NUMA_NODE=1
export PYTHON_ROOT=$HOME/anaconda3
# export PYTHON_ROOT=$HOME/anaconda3/envs/py39
export PMEM_ROOT=/usr/local/pmdk-2.1.0
export BOOST_ROOT=/usr/local/Boost-1.75.0
# export ROCKSDB_ROOT=/usr/local/rocksdb-6.11.4
export ROCKSDB_ROOT=/usr/local/pmem-rocksdb-6.11.4
export KVDK_ROOT=/usr/local/kvdk
export LLC_ROOT=$script_dir/../
# export LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:/usr/local/lib:/usr/lib
export LD_LIBRARY_PATH=$CEPH_BUILD_ROOT/lib:$PMEM_ROOT/lib:$BOOST_ROOT/lib:$ROCKSDB_ROOT/lib:$KVDK_ROOT/lib:/usr/lib/x86_64-linux-gnu:/usr/local/lib:/usr/lib
export PATH=$LLC_ROOT/bin:$PATH

nrun() {
    numactl --cpunodebind=$NUMA_NODE --membind=$NUMA_NODE "$@"
}

mytime () {
     /usr/bin/time -f "real %es user %Us sys %Ss CPU %P\n(%Xtext+%Ddata %Mmax)k\t%Iinputs+%Ooutputs\n(%Fmajor+%Rminor)pagefaults\t%Wswaps" "$@"
}
