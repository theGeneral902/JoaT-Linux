#!/bin/bash

echo -e "       __    ______        ___   .___________.    __       __  .__   __.  __    __  ___   ___ \n      |  |  /  __  \      /   \  |           |   |  |     |  | |  \ |  | |  |  |  | \  \ /  / \n      |  | |  |  |  |    /  ^  \ \`---|  |----\`   |  |     |  | |   \|  | |  |  |  |  \  V  /  \n
.--.  |  | |  |  |  |   /  /_\  \    |  |        |  |     |  | |  . \`  | |  |  |  |   >   <   \n|  \`--'  | |  \`--'  |  /  _____  \   |  |        |  \`----.|  | |  |\   | |  \`--'  |  /  .  \  \n \______/   \______/  /__/     \__\  |__|        |_______||__| |__| \__|  \______/  /__/ \__\ \n"
echo -e "==============================================================================================\n"
echo -e " __________________________\n/ Created By: Andrew Leeth \ \n\ (theGeneral902)          /\n --------------------------\n        \   ^__^\n         \  (oo)\_______\n            (__)\       )\/\ \n                ||----w |\n                ||     ||\n"
echo -e "GitHub: https://github.com/theGeneral902/JoaT-Linux\n \n \n"

#sleep 2

RED='\033[0;31m'
NC='\033[0m'

# Make sure the user is root
if [ "$EUID" -ne 0 ]
	then echo -e "\n${RED}[ERROR]${NC}  Please run as root or sudo.\n"
	exit 1
fi

if [[ -r /etc/os-release ]]; then
    . /etc/os-release
    if [[ $ID = ubuntu ]]; then
        read _ UBUNTU_VERSION_NAME <<< "$VERSION"
	if [[ $UBUNTU_VERSION_NAME =~ .*Xenial.* ]]
		then
		  echo "deb http://cran.rstudio.com/bin/linux/ubuntu xenial/" | tee -a /etc/apt/sources.list
	fi
	if [[ $UBUNTU_VERSION_NAME =~ .*Yakkety.* ]]
		then
		  echo "deb http://cran.rstudio.com/bin/linux/ubuntu yakkety/" | tee -a /etc/apt/sources.list
	fi
	if [[ $UBUNTU_VERSION_NAME =~ .*Trusty.* ]]
		then
		  echo "deb http://cran.rstudio.com/bin/linux/ubuntu trusty/" | tee -a /etc/apt/sources.list
	fi
	if [[ $UBUNTU_VERSION_NAME =~ .*Precise.* ]]
		then
		  echo "deb http://cran.rstudio.com/bin/linux/ubuntu precise/" | tee -a /etc/apt/sources.list
	fi
    else
        echo "Not running an Ubuntu distribution. ID=$ID, VERSION=$VERSION"
    fi
else
    echo "Not running a distribution with /etc/os-release available"
fi
exit 1

# Create joat user
id -u joat &>/dev/null || useradd joat
id -u joat &>/dev/null || echo -e "joat\njoat" | (passwd joat)
usermod -aG sudo joat

# Update OS
apt-get upgrade -y
apt-get update -y

# Install latest Anaconda
CONTREPO=https://repo.continuum.io/archive/
ANACONDAURL=$(wget -q -O - $CONTREPO index.html | grep "Anaconda3-" | grep "Linux" | grep "86_64" | head -n 1 | cut -d \" -f 2)
wget -O ~/Downloads/anaconda.sh $CONTREPO$ANACONDAURL
bash ~/Downloads/anaconda.sh -b -p $HOME/anaconda
export PATH="/home/hadoop/anaconda/bin/:$PATH"
rm -f ~/Downloads/anaconda.sh
conda update conda -y
conda update anaconda -y
conda install -c r r-essentials -y
