#!/usr/bin/env bash
THIS_DIR=$(cd $(dirname $0); pwd)
Version=`lsb_release -rs | cut -f1 -d"."`
install() {
echo -e "\033[0;36m"
echo -e "~ { Setting Up Offices - جاري رفع المكاتب } ~"
echo -e "\033[0m"
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install -y
sudo apt-get install upstart-sysv -y
sudo apt-get install tmux -y
sudo apt-get install dnsutils -y
sudo apt-get install software-properties-common -y
sudo add-apt-repository ppa:ubuntu-toolchain-r/test -y
sudo apt-get install libreadline-dev -y libconfig-dev -y libssl-dev -y lua5.2 -y liblua5.2-dev -y lua-socket -y lua-sec -y lua-expat -y libevent-dev -y make unzip git redis-server autoconf g++ -y libjansson-dev -y libpython-dev -y expat libexpat1-dev -y curl -y htop -y wget -y
sudo apt-get install screen -y
sudo apt-get install libconfig++9v5 -y 
sudo apt-get install libstdc++6 -y
sudo apt-get install lua-lgi -y
sudo apt-get install libnotify-dev -y
sudo apt-get install lua-space -y
sudo service redis-server start
sudo apt-get update -y
sudo apt-get install g++-4.7 -y c++-4.7
sudo apt-get install luarocks -y
wget http://luarocks.org/releases/luarocks-2.2.2.tar.gz;tar zxpf luarocks-2.2.2.tar.gz;cd luarocks-2.2.2 && ./configure && make && sudo make install
sudo luarocks install luasocket
sudo luarocks install luasec
sudo luarocks install redis-lua
sudo luarocks install lua-term
sudo luarocks install serpent
sudo luarocks install dkjson
sudo luarocks install Lua-cURL
sudo luarocks install luautf8
cd .. ;sudo rm -rf luarocks*
sudo timedatectl set-timezone Asia/Baghdad
cd $THIS_DIR && sudo chmod +x tg
lua HASSAN.lua
}
if [ "$1" = "install" ]; then
install
else
if [ ! -f ./tg ]; then
echo -e "\033[0;31m\n~ The tg File Was Not Found In The Bot Files\n\033[0;33m"
exit 1
fi
cd $THIS_DIR && sudo chmod +x tg
lua HASSAN.lua
fi
