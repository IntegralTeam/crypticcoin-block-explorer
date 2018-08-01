#!/usr/bin/env bash
# Stop block explorer in production mode

set -o errexit
set -o pipefail
set -o nounset

pm2 stop all
