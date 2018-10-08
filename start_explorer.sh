#!/usr/bin/env bash
# Start block explorer

set -o errexit
set -o pipefail
set -o nounset

. ~/.nvm/nvm.sh
nvm use v4
./node_modules/bitcore-node-crypticcoin/bin/bitcore-node start
