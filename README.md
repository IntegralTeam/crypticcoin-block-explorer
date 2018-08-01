# crypticcoin-block-explorer

Script to install and setup a CrypticCoin block explorer on Ubuntu 16.x or newer, or Debian 8+ for the CrypticCoin network.

## To run locally

On a fresh Ubuntu/Debian server, from a non-root user's home directory, run the following commands:
```
sudo apt-get update

sudo apt-get -y install build-essential pkg-config libc6-dev m4 g++-multilib autoconf libtool ncurses-dev unzip git python zlib1g-dev wget bsdmainutils automake

git clone https://git.sfxdx.ru/cryptic/crypticcoin-block-explorer.git

cp ./crypticcoin-block-explorer/block-explorer.sh ./block-explorer.sh

git clone https://git.sfxdx.ru/cryptic/secretcoin.git

cd secretcoin

./zcutil/fetch-params.sh

./zcutil/build.sh -j$(nproc)

cd ..

sudo apt-get -y install npm

wget -qO- https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

exit

bash build_explorer.sh
cp *.sh crypticcoin-explorer/ # copy scripts inside crypticcoin-explore directory
cd crypticcoin-explorer/
bash start_explorer.sh

```
The script requires you to logout when it is finished, log back in and run build_explorer.sh and start_explorer.sh. It outputs the commands to do so.

The server runs in the foreground, and for production use scripts from "To setup production" section.

The block explorer will be available on http://localhost:3001/insight/ and any additional IP addresses your server has bound to its network interface.

All actions performed by the script are thouroughly commented. 

## To setup production

##### Start in production mode:
```
bash start_production_explorer.sh
```
##### Stop:
```
bash stop_production_explorer.sh
```
##### Monitoring:
```
bash monitor_production_explorer.sh
```



