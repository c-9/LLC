#!/usr/bin/env bash
current_dir=$(dirname $0)
source $current_dir/env.sh

rsync -vhra $LLC_ROOT/. chunk@chunk-legion:/home/chunk/workspace/git/git-own/LLC/ --include='**.gitignore' --exclude='/.git' --filter=':- .gitignore' --delete-after
