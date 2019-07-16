#!/bin/bash
RED='\033[0;31m'
NOCOLOR='\033[0m'
if [[ $EUID -ne 0 ]]; then
	echo "This script must be run as root" 
	exit 1
else
	echo "------------------------------------------------------------------------"
	echo  "Enter your TOKEN"
	read token
	echo "------------------------------------------------------------------------"
	echo "How much sessions you want, chosse 1 or 2"
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
			echo -e "${RED}IF YOU SET EXCESIVE AMOUNT OF SESSIONS THIS SESSIONS MAY BE BLOCKED ${NOCOLOR}"
			read number
			;;
		*)
			echo "Invalid number"
			echo "Select 1 or 2"
			;;
	esac
	apt update
        apt upgrade -y
        apt install -y unzip libcanberra-gtk-module curl libxss1 xvfb htop sed tar
        wget https://www.dropbox.com/s/u13w9qcbqd5c0fx/9hviewer-linux-x64-2.3.9.tar.bz2
	curl -L -o crontab "https://drive.google.com/uc?export=download&id=1RjhqDfdc_b89G3SqD6J2EUY6UaKIooV9"
        curl -L -o script.sh "https://drive.google.com/uc?export=download&id=1dQ32aV5mzep9xQXrfd9hQjEjvPCJqUMY"
	wget "https://www.dropbox.com/s/h4o9hozm8v5t58h/test.sh"
        curl -L -o reboot.sh "https://drive.google.com/uc?export=download&id=1Bl5_K1aL78q6UIkOdXriS26HG4aWjOeJ"
        sed -i -e 's/\r$//' script.sh
        sed -i -e 's/\r$//' crontab
        sed -i -e 's/\r$//' test.sh
        sed -i -e 's/\r$//' reboot.sh
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
	crontab crontab
	chmod 777 -R /root
	rm 9h* crontab
fi