#!/usr/bin/env bash
# Start block explorer in production mode

set -o errexit
set -o pipefail
set -o nounset

pm2 start start_explorer.sh --name="block_explorer"
pm2 save
pm2 startup
