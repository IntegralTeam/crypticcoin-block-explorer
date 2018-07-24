#!/bin/bash

echo "switching to correct node version"
echo

# nvm setup

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm

# switch node setup with nvm
nvm install v4

echo "---------------"
echo "installing bitcore dependencies"
echo

# install zeromq
sudo apt-get -y install libzmq3-dev

echo "---------------"
echo "installing crypticcoin patched bitcore"
echo 
npm install git+ssh://git@git.sfxdx.ru:cryptic/bitcore-node-crypticcoin.git

echo "---------------"
echo "setting up bitcore"
echo

# setup bitcore
./node_modules/bitcore-node-crypticcoin/bin/bitcore-node create crypticcoin-explorer

cd crypticcoin-explorer

echo "---------------"
echo "installing insight UI"
echo
../node_modules/bitcore-node-crypticcoin/bin/bitcore-node install git+ssh://git@git.sfxdx.ru:cryptic/insight-api-crypticcoin git+ssh://git@git.sfxdx.ru:cryptic/insight-ui-crypticcoin


echo "---------------"
echo "creating config files"
echo

# point crypticcoin at mainnet
cat << EOF > bitcore-node.json
{
  "network": "mainnet",
  "port": 3001,
  "services": [
    "bitcoind",
    "insight-api-crypticcoin",
    "insight-ui-crypticcoin",
    "web"
  ],
  "servicesConfig": {
    "bitcoind": {
      "spawn": {
        "datadir": "./data",
        "exec": "./secretcoin/src/zcashd"
      }
    }
  }
}

EOF

# create .conf
cat << EOF > ./data/zcash.conf
addnode=195.201.141.24
server=1
testnet=0
whitelist=127.0.0.1
txindex=1
addressindex=1
timestampindex=1
spentindex=1
zmqpuawtx=1
zmqpubrawtx=tcp://127.0.0.1:18332
zmqpubhashblock=tcp://127.0.0.1:18332
rpcallowip=127.0.0.1
rpcuser=bitcoin
rpcpassword=local321
uacomment=bitcore
showmetrics=0

EOF


echo "---------------"
# start block explorer
echo "To start the block explorer, from within the crypticcoin-explorer directory issue the command:"
echo " nvm use v4; ./node_modules/bitcore-node-crypticcoin/bin/bitcore-node start"
