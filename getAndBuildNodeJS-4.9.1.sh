#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

VERSION_STR=4.9.1
VERSION=b8eef6d # v4.9.1

rm -rf node/
rm -rf node-$VERSION_STR/

git clone https://github.com/nodejs/node.git
mv node/ node-$VERSION_STR/
cd node-$VERSION_STR/

git checkout $VERSION

./configure
make -j4

cd ..
