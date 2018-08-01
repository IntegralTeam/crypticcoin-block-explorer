#!/usr/bin/env bash
# Monitor block explorer

set -o errexit
set -o pipefail
set -o nounset

pm2 monit
