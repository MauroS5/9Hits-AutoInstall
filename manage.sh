#!/bin/bash
cd /root/9Hits/
source parameters
if [[ $EUID -ne 0 ]]; then
    whiptail --title "ERROR" --msgbox "This script must be run as root" 8 78
    exit
else
    os=$(whiptail --title "What do you want to do?" --menu "Choose an option" 16 100 9 \
    "1)" "Start"   \
    "2)" "Stop"   \
    "3)" "Modify ammount of sessions / Change session token"        \
    "4)" "Remove"       \
    "5)" "Update to last version (No sessions will get lose)"        3>&2 2>&1 1>&3
    )
    case $os in
        "1)")
            crontab /root/9Hits/crontab
            echo "All right"
            ;;
        "2)")
            crontab -r
            /root/9Hits/kill.sh
            echo "All right"
            ;;
        "3)")
            a=$((1 + RANDOM % 28))
            crontab -r
            /root/9Hits/kill.sh
            rm /root/9Hits/9HitsViewer_x64/sessions/*.txt
            token=$(whiptail --inputbox "Enter your TOKEN" 8 78 --title "TOKEN" 3>&1 1>&2 2>&3)
            tokenstatus=$?
            if [ $tokenstatus = 0 ]; then
                    echo "All right"
            else
                    echo "User selected Cancel"
                    exit
            fi
            option=$(whiptail --title "How often do you want it to restart" --menu "Choose an option" 16 100 9 \
            "1)" "Every 30 minutes"   \
            "2)" "Every 1 hour"     \
            "3)" "Every 2 hours"    \
            "4)" "Every 6 houts"    \
            "5)" "Every 12 hours"   \
            "6)" "Every day"    3>&2 2>&1 1>&3
            )
            case $option in
                    "1")
                        let b=a+30
                        cronvar="$a,$b * * * * /root/9Hits/kill.sh"
                        ;;
                    "2")
                        cronvar="$a * * * * /root/9Hits/kill.sh"
                        ;;
                    "3")
                        cronvar="$a 1,3,5,7,9,11,13,15,17,19,21,23 * * * /root/9Hits/kill.sh"
                        ;;
                    "4")
                        cronvar="$a 1,7,13,19 * * * /root/9Hits/kill.sh"
                        ;;
                    "5")
                        cronvar="$a 1,13 * * * /root/9Hits/kill.sh"
                        ;;
                    "6")
                        cronvar="$a 1 * * * /root/9Hits/kill.sh"
                        ;;
            esac
            option=$(whiptail --title "How much sessions you want" --menu "Choose an option" 16 100 9 \
            "1)" "Use one session"   \
            "2)" "Automatic max session based on system (Green Faces)"   \
            "3)" "Automatic max session based on system (Yellow Faces)"   \
            "4)" "Automatic max session based on system (Red Faces)"   \
            "5)" "Automatic max session based on system (MAX POSSIBLE)"   \
            "6)" "Use number you want"  \
            "7)" "Use external server"  3>&2 2>&1 1>&3
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
                    whiptail --title "WARNING" --msgbox "This feature is under development and can not works as expected, please report any error" 8 78
                    cores=`getconf _NPROCESSORS_ONLN`
                    memphy=`grep MemTotal /proc/meminfo | awk '{print $2}'`
                    memswap=`grep SwapTotal /proc/meminfo | awk '{print $2}'`
                    let memtotal=$memphy+$memswap
                    let memtotalgb=$memtotal/100000
                    let sscorelimit=$cores*3
                    let ssmemlimit=$memtotalgb*3/10
                    if [[ $sscorelimit -le $ssmemlimit ]]
                    then
                        number=$sscorelimit
                    else
                        number=$ssmemlimit
                    fi
                    color=1
                    lookup="*/15 * * * * /root/9Hits/lookup.sh"
                    ;;
                "3)")
                    export NEWT_COLORS='
                    window=,red
                    border=white,red
                    textbox=white,red
                    button=black,white
                    '
                    whiptail --title "WARNING" --msgbox "This feature is under development and can not works as expected, please report any error" 8 78
                    cores=`getconf _NPROCESSORS_ONLN`
                    memphy=`grep MemTotal /proc/meminfo | awk '{print $2}'`
                    memswap=`grep SwapTotal /proc/meminfo | awk '{print $2}'`
                    let memtotal=$memphy+$memswap
                    let memtotalgb=$memtotal/100000
                    let sscorelimit=$cores*6
                    let ssmemlimit=$memtotalgb*6/10
                    if [[ $sscorelimit -le $ssmemlimit ]]
                    then
                        number=$sscorelimit
                    else
                        number=$ssmemlimit
                    fi
                    color=2
                    lookup="*/15 * * * * /root/9Hits/lookup.sh"
                    ;;
                "4)")
                    export NEWT_COLORS='
                    window=,red
                    border=white,red
                    textbox=white,red
                    button=black,white
                    '
                    whiptail --title "WARNING" --msgbox "This feature is under development and can not works as expected, please report any error" 8 78
                    cores=`getconf _NPROCESSORS_ONLN`
                    memphy=`grep MemTotal /proc/meminfo | awk '{print $2}'`
                    memswap=`grep SwapTotal /proc/meminfo | awk '{print $2}'`
                    let memtotal=$memphy+$memswap
                    let memtotalgb=$memtotal/100000
                    let sscorelimit=$cores*8
                    let ssmemlimit=$memtotalgb*8/10
                    if [[ $sscorelimit -le $ssmemlimit ]]
                    then
                        number=$sscorelimit
                    else
                        number=$ssmemlimit
                    fi
                    color=3
                    lookup="*/15 * * * * /root/9Hits/lookup.sh"
                    ;;
                "5)")
                    export NEWT_COLORS='
                    window=,red
                    border=white,red
                    textbox=white,red
                    button=black,white
                    '
                    whiptail --title "WARNING" --msgbox "This feature is under development and can not works as expected, please report any error\n\nYOU CAN GET REJECTED FACES AND YOUR SYSTEM WILL BE UNABLE TO DO NOTHING MORE EXPECT 9HITS" 15 78
                    cores=`getconf _NPROCESSORS_ONLN`
                    memphy=`grep MemTotal /proc/meminfo | awk '{print $2}'`
                    memswap=`grep SwapTotal /proc/meminfo | awk '{print $2}'`
                    let memtotal=$memphy+$memswap
                    let memtotalgb=$memtotal/100000
                    let sscorelimit=$cores*9
                    let ssmemlimit=$memtotalgb*9/10
                    if [[ $sscorelimit -le $ssmemlimit ]]
                    then
                        number=$sscorelimit
                    else
                        number=$ssmemlimit
                    fi
                    color=4
                    lookup="*/15 * * * * /root/9Hits/lookup.sh"
                    ;;  
                "6)")
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
                "7)")
                    exProxyServer=$(whiptail --inputbox "Enter your proxy server link (Just like -> http://example.com/index.php)" 8 78 --title "TOKEN" 3>&1 1>&2 2>&3)
                    tokenstatus=$?
                    if [ $tokenstatus = 0 ]; then
                        echo "All right"
                    else
                        echo "User selected Cancel"
                        exit
                    fi
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
            cpumax=$(whiptail --inputbox "Enter max % of cpu you want set per page" 8 78 --title "Max Cpu" 3>&1 1>&2 2>&3)
            cpumaxstatus=$?
            if [ $cpumaxstatus = 0 ]; then
                echo "All right"
            else
                echo "User selected Cancel"
                exit
            fi
            isproxy=false
            for i in `seq 1 $number`;
            do
                file="/root/9Hits/9HitsViewer_x64/sessions/156288217488$i.txt"
cat > $file <<EOFSS
{
  "token": "$token",
  "note": "",
  "proxyType": "system",
  "proxyServer": "",
  "proxyUser": "",
  "proxyPw": "",
  "maxCpu": $cpumax,
  "isUse9HitsProxy": $isproxy
}
EOFSS
                isproxy=true
                proxytype=ssh
            done
            cronfile="/root/9Hits/crontab"
cat > $cronfile <<EOFSS
* * * * * /root/9Hits/crashdetect.sh
$cronvar
58 23 * * * /root/9Hits/reboot.sh
EOFSS
            crontab crontab
            ;;
        "4)")
            crontab -r
            /root/9Hits/kill.sh
            rm -R /root/9Hits/
            echo "All right"
            ;;
        "5)")
            crontab -r
            /root/9Hits/kill.sh
            cd /root/9Hits/9HitsViewer_x64
            rm 9hbrowser 9hmultiss 9hviewer
            wget https://rs.9hits.com/9hviewer/9h-patch-linux-x64.zip
            unzip 9h-patch-linux-x64.zip
            crontab /root/9Hits/crontab
            echo "All right"
            ;;
    esac
fi