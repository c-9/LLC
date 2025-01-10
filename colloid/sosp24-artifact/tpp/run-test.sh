#!/bin/bash

scripts_path="${BASH_SOURCE%/*}/../../scripts"
gups_path="${BASH_SOURCE%/*}/../../apps/gups"
export BPFTRACE_BTF=/sys/kernel/btf/vmlinux
# Run simple test with TPP+colloid
# The below runs GUPS workload on 15 cores for 60 seconds
$scripts_path/linux-colloid.sh test-tpp-colloid 60 15 0 -- $gups_path/gups64-rw 15

