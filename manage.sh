#!/bin/bash
cd /root
if [[ $EUID -ne 0 ]]; then
    whiptail --title "ERROR" --msgbox "This script must be run as root" 8 78
    exit
else
	os=$(whiptail --title "What do you want to do?" --menu "Choose an option" 16 100 9 \
	"1)" "Start"   \
	"2)" "Stop"   \
	"3)" "Modify / Change session token"        \
	"4)" "Remove"		3>&2 2>&1 1>&3
	)
	case $os in
		"1)")
			crontab crontab
			echo "All right"
			;;
		"2)")
			crontab -r
			/root/kill.sh
			echo "All right"
			;;
		"3)")
			rm /root/9HitsViewer_x64/sessions/156288217488*
			token=$(whiptail --inputbox "Enter your TOKEN" 8 78 --title "TOKEN" 3>&1 1>&2 2>&3)
	        tokenstatus=$?
	        if [ $tokenstatus = 0 ]; then
	          	echo "All right"
	        else
	           	echo "User selected Cancel"
	           	exit
	        fi
			option=$(whiptail --title "How much sessions you want" --menu "Choose an option" 16 100 9 \
	        "1)" "Use one session"   \
	        "2)" "Automatic max session based on system"   \
	        "3)" "Use number you want"  3>&2 2>&1 1>&3
	        )
	        case $option in
	            "1)")
	                number=1
	                ;;
	            "2)")
	                export NEWT_COLORS='
	                window=,red
	                border=white,red
	                textbox=white,red
	                button=black,white
	                '
	                whiptail --title "WARNING" --msgbox "THIS CAN GET A YELLOW/RED FACE || RECOMMENDED USE A SINGLE SESSION" 8 78
	                cores=`nproc --all`
	                memphy=`grep MemTotal /proc/meminfo | awk '{print $2}'`
	                memswap=`grep SwapTotal /proc/meminfo | awk '{print $2}'`
	                let memtotal=$memphy+$memswap
	                let memtotalgb=$memtotal/100000
	                let sscorelimit=$cores*4
	                let ssmemlimit=$memtotalgb*4/10
	                if [[ $sscorelimit -le $ssmemlimit ]]
	                then
	                    number=$sscorelimit
	                else
                    	number=$ssmemlimit
	                fi
	                ;;
	            "3)")
	                export NEWT_COLORS='
	                window=,red
	                border=white,red
	                textbox=white,red
	                button=black,white
	                '
	                whiptail --title "WARNING" --msgbox "IF YOU SET EXCESIVE AMOUNT OF SESSIONS THIS SESSIONS MAY BE BLOCKED || RECOMMENDED USE A SINGLE SESSION" 8 78
	                number=$(whiptail --inputbox "ENTER NUMBER OF SESSIONS" 8 78 --title "SESSIONS" 3>&1 1>&2 2>&3)
	                numberstatus=$?
	                if [ $numberstatus = 0 ]; then
	                    echo "All right"
	                else
	                    echo "User selected Cancel"
	                    exit
	                fi
	                ;;
	        esac
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
			;;
		"4)")
			crontab -r
			/root/kill.sh
			rm -R 9Hits-AutoInstall 9HitsViewer_x64 9hviewer-linux-x64.tar.bz2 crashdetect.sh crontab install.sh kill.sh manage.sh reboot.sh
			echo "All right"
			;;
	esac
fi