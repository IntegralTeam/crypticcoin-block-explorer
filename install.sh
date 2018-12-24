#!/usr/bin/env bash
# Build block explorer

set -o errexit
set -o pipefail
set -o nounset

echo "---------------"
echo "installing system dependensies"
echo
sudo apt-get update
sudo apt-get -y install build-essential pkg-config libc6-dev m4 g++-multilib autoconf libtool ncurses-dev unzip git python python-zmq zlib1g-dev wget curl bsdmainutils automake

echo "---------------"
echo "installing bitcore dependencies"
echo
# install zeromq
sudo apt-get -y install libzmq3-dev

echo "---------------"
echo "installing tor"
echo
sudo apt-get -y install tor

echo "---------------"
echo "get source codes and build the daemon"
echo
git clone https://github.com/crypticcoinvip/CrypticCoin.git --branch sapling-explorer ./CrypticCoin
# build the daemon
cd CrypticCoin
./zcutil/fetch-params.sh
./zcutil/build.sh -j$(nproc)
cd ..

echo "---------------"
echo "installing nvm"
echo
wget -qO- https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash

# nvm setup
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm

echo "---------------"
echo "switch node setup with nvm"
echo
nvm install v4

echo "---------------"
echo "installing crypticcoin patched bitcore"
echo
npm install "https://github.com/crypticcoinvip/bitcore-node-crypticcoin.git#sapling"

echo "---------------"
echo "setting up bitcore"
echo
./node_modules/bitcore-node-crypticcoin/bin/bitcore-node create crypticcoin-explorer

cd crypticcoin-explorer

echo "---------------"
echo "installing insight UI"
echo
../node_modules/bitcore-node-crypticcoin/bin/bitcore-node install "https://github.com/crypticcoinvip/insight-api-crypticcoin#sapling" "https://github.com/crypticcoinvip/insight-ui-crypticcoin#sapling"

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
        "exec": "../CrypticCoin/src/crypticcoind"
      },
      "insight-ui-crypticcoin": {
        "routePrefix" : ""
      }
    }
  }
}

EOF

# create .conf
cat << EOF > ./data/crypticcoin.conf
tor_exe_path=/usr/bin/tor
addnode=5wa52xtesl4yjnhp.onion:23303
addnode=axjnhxwkhaqle7dh.onion:23303
onion=1
listenonion=1
server=1
listen=1
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
rpcuser=cryp_explorer
rpcpassword=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 26 ; echo '')
uacomment=bitcore
showmetrics=0

EOF

echo "---------------"
echo "installing pm2"
echo

sudo npm install pm2 -g

echo "---------------"
echo "get explorer scripts"
echo

cd ..
git clone https://github.com/crypticcoinvip/crypticcoin-block-explorer.git --branch sapling ./crypticcoin-block-explorer
# copy scripts inside crypticcoin-explorer directory
cp ./crypticcoin-block-explorer/*.sh crypticcoin-explorer/
cd crypticcoin-explorer

echo "---------------"
echo
echo "   Almost done. You can run blockchain explorer with:"
echo "   bash start_explorer.sh"
echo
echo "---------------"
echo "make sure \"servicesConfig\".\"exec\" inside bitcore-node.json points to your crypticcoind executable."
echo "make sure crypticcoind isn't running already \(ps -A | grep crypticcoind\)"
echo "make sure you have rights to bind to your port \(For example, port 80 requires special rights\)"
echo "make sure tor_exe_path \(inside data/crypticcoin.conf\) points to your tor installation."
echo "check logs in data/debug.log if have any problem"
echo



