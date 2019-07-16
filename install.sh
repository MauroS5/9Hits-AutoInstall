#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
NOCOLOR='\033[0m'
cd /root
if [[ $EUID -ne 0 ]]; then
	echo "This script must be run as root" 
	exit 1
else
	echo "------------------------------------------------------------------------"
	echo  "Enter your TOKEN"
	read token
	echo "------------------------------------------------------------------------"
	echo "How much sessions you want, choose 1 or 2"
	echo "1) Automatic max session based on system      2) Use number you want"
	read option
	echo "------------------------------------------------------------------------"
	case $option in
		1)
			cores=`nproc --all`
			memphy=`grep MemTotal /proc/meminfo | awk '{print $2}'`
			memswap=`grep SwapTotal /proc/meminfo | awk '{print $2}'`
			let memtotal=$memphy+$memswap
			let memtotalgb=$memtotal/100000
			let sscorelimit=$cores*5
			let ssmemlimit=$memtotalgb*5/10
			if [[ $sscorelimit -le $ssmemlimit ]]
			then
				number=$sscorelimit
			else
				number=$ssmemlimit
			fi
			;;
		2)
			echo "How much you want"
			echo -e "${RED}WARNING"
			echo -e "${RED}IF YOU SET EXCESSIVE AMOUNT OF SESSIONS THIS SESSIONS MAY BE BLOCKED ${NOCOLOR}"
			read number
			;;
		*)
			echo "Invalid number"
			echo "Select 1 or 2"
			;;
	esac
	apt update
    apt upgrade -y
    apt install -y unzip libcanberra-gtk-module curl libxss1 xvfb htop sed tar libxtst6 libnss3
    wget https://www.dropbox.com/s/u13w9qcbqd5c0fx/9hviewer-linux-x64-2.3.9.tar.bz2
    tar -xjvf 9hviewer-linux-x64-2.3.9.tar.bz2
    cd /root/9HitsViewer_x64/sessions/
	isproxy=false
	for i in `seq 1 $number`;
        do
		file="/root/9HitsViewer_x64/sessions/156288217488$i.txt"
cat > $file <<EOFSS
{
  "token": "$token",
  "note": "",
  "proxyType": "system",
  "proxyServer": "",
  "proxyUser": "",
  "proxyPw": "",
  "maxCpu": 100,
  "isUse9HitsProxy": $isproxy
}
EOFSS
		isproxy=true
		proxytype=ssh
	done
	cd /root
	mv 9Hits-AutoInstall/* ./
	crontab crontab
	chmod 777 -R /root
	rm 9h* crontab
fi