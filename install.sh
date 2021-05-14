#!/bin/bash
mkdir /root/9Hits/
cd /root/9Hits/
a=$((1 + RANDOM % 28))
URL="https://rs.9hits.com/9hviewer/9hits-linux-x64.tar.bz2"
if [[ $EUID -ne 0 ]]; then
    whiptail --title "ERROR" --msgbox "This script must be run as root" 8 78
    exit
else
    if [[ $1 -eq 0 ]]; then
        if [  -f /etc/os-release  ]; then
            dist=$(awk -F= '$1 == "ID" {gsub("\"", ""); print$2}' /etc/os-release)
        elif [ -f /etc/redhat-release ]; then
            dist=$(awk '{print tolower($1)}' /etc/redhat-release)
        else
            whiptail --title "ERROR" --msgbox "Sorry, for the moment this script does not support your Distro" 8 78
        fi
        case "${dist}" in
        debian|ubuntu)
            os=1
            ;;
        centos)
            os=3
            ;;
        *)
            whiptail --title "ERROR" --msgbox "Sorry, for the moment this script does not support your Distro" 8 78
            exit
            ;;
        esac
        token=$2
        number=1
        cpumax=100
        cronvar="1,31 * * * * /root/9Hits/kill.sh"
    else
        if [[ $1 -eq 1 ]]; then
            os=$(whiptail --title "What Linux Distro do you have?" --menu "Choose an option" 16 100 9 \
            "1)" "Ubuntu"   \
            "2)" "Debian"   \
            "3)" "CentOS"   \
            "4)" "Any of that"      \
            "5)" "Dont know"        3>&2 2>&1 1>&3
            )
            case $os in
                "1)")
                    os=1
                    ;;
                "2)")
                    os=2
                    ;;
                "3)")
                    os=3
                    ;;
                "4)")
                    echo "Sorry, for the moment this script does not support your Distro"
                    exit
                   ;;
                "5)")
                    echo "Trying detect and install automatic"
                    os=`awk -F= '/^NAME/{print $2}' /etc/os-release`
                    if [ $os == '"Ubuntu"' ]; then
                        os=1
                    else
                        os=3
                    fi
                ;;
            esac
            whiptail --title "Select" --checklist --separate-output "Choose:" 20 78 15 \
            "9Hits Script" "" on \
            "Sessions AI" "" on 2>results
 
            while read choice
            do
                case $choice in
                    "Sessions AI") lookup="$a * * * * /root/9Hits/lookup.sh"
                    ;;
                    "9Hits Script") script=1
                    ;;
                    *)
                    ;;
                esac
            done < results
            if [[ $script -eq 1 ]]; then
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
                    "1)")
                        let b=a+30
                        cronvar="$a,$b * * * * /root/9Hits/kill.sh"
                        ;;
                    "2)")
                        cronvar="$a * * * * /root/9Hits/kill.sh"
                        ;;
                    "3)")
                        cronvar="$a 1,3,5,7,9,11,13,15,17,19,21,23 * * * /root/9Hits/kill.sh"
                        ;;
                    "4)")
                        cronvar="$a 1,7,13,19 * * * /root/9Hits/kill.sh"
                        ;;
                    "5)")
                        cronvar="$a 1,13 * * * /root/9Hits/kill.sh"
                        ;;
                    "6)")
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
                adultpages="deny"
                pupups="deny"
                coinMn="deny"
            whiptail --title "Select" --checklist --separate-output "Choose:" 20 78 15 \
            "show adult pages" "" on \
            "show popups" "" on 2>results
 
            while read choice
            do
                case $choice in
                    "show adult pages") adultpages="allow"
                    ;;
                    "show popups") pupups="allow"
                    ;;
                    "allow Coin Mining") coinMn="allow"
                    ;;
                    *)
                    ;;
                esac
            done < results
            else
                exit
            fi
        else
            if [[ $1 -eq 2 ]]; then
                if [  -f /etc/os-release  ]; then
                    dist=$(awk -F= '$1 == "ID" {gsub("\"", ""); print$2}' /etc/os-release)
                elif [ -f /etc/redhat-release ]; then
                    dist=$(awk '{print tolower($1)}' /etc/redhat-release)
                else
                    whiptail --title "ERROR" --msgbox "Sorry, for the moment this script does not support your Distro" 8 78
                fi
                case "${dist}" in
                debian|ubuntu)
                    os=1
                    ;;
                centos)
                    os=3
                    ;;
                *)
                    whiptail --title "ERROR" --msgbox "Sorry, for the moment this script does not support your Distro" 8 78
                    exit
                    ;;
                esac
                token=$2
                number=$3
                cpumax=$4
                case $5 in
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
                if [[ $6 -ne 0 ]]; then
                    lookup="$a * * * * /root/9Hits/lookup.sh"
                    case $6 in
                        "1")
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
                            ;;
                        "2")
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
                            ;;
                        "3")
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
                            ;;
                        "4")
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
                            ;;
                    esac
                fi
                note=$7
                exProxyServer=$8
                if [ -z "$9" ]
                then
                    URL="https://rs.9hits.com/9hviewer/9hits-linux-x64.tar.bz2"
                else
                    URL=$9
                fi
                if [ -z "${10}" ]
                then
                    pupups="allow"
                else
                    pupups=${10}
                fi
                if [ -z "${11}" ]
                then
                    adultpages="allow"
                else
                    adultpages=${11}
                fi
                if [ -z "${12}" ]
                then
                    coinMn="deny"
                else
                    coinMn=${12}
                fi
            fi
        fi
    fi
    if [ $os == "1" ] || [ $os == "2" ]; then
        apt-get update
        apt-get upgrade -y
        apt-get install -y unzip libcanberra-gtk-module curl libxss1 xvfb htop sed tar libxtst6 libnss3 wget psmisc bc libgtk-3-0 libgbm-dev libatspi2.0-0 libatomic1
    else
        yum -y update
        yum install -y unzip curl xorg-x11-server-Xvfb sed tar Xvfb wget bzip2 libXcomposite-0.4.4-4.1.el7.x86_64 libXScrnSaver libXcursor-1.1.15-1.el7.x86_64 libXi-1.7.9-1.el7.x86_64 libXtst-1.2.3-1.el7.x86_64 fontconfig-2.13.0-4.3.el7.x86_64 libXrandr-1.5.1-2.el7.x86_64 alsa-lib-1.1.6-2.el7.x86_64 pango-1.42.4-1.el7.x86_64 atk-2.28.1-1.el7.x86_64 psmisc
    fi
    wget -O 9hits-linux-x64.tar.bz2 $URL
    tar -xjvf 9hits-linux-x64.tar.bz2
    mv /root/9Hits/9hits-linux-x64 /root/9Hits/9HitsViewer_x64
    cd /root/9Hits/9HitsViewer_x64/
    settings="/root/9Hits/9HitsViewer_x64/settings.json"
cat > $settings <<EOFSS
    {"hiddenColumns":[],"token":"$token","browser":"hide","popups":"$pupups","adult":"$adultpages","coinMn":"$coinMn","autoStart":"yes"}
EOFSS


    cd /root/9Hits/9HitsViewer_x64/sessions/
    isproxy=system
    for i in `seq 1 $number`;
    do
        file="/root/9Hits/9HitsViewer_x64/sessions/ss$i.json"
cat > $file <<EOFSS
{
    "name": "ss$i",
    "note": "$note",
    "proxy": {
        "type": "$isproxy",
        "server": "",
        "user": "",
        "password": "",
        "exServer": "$exProxyServer"
    }
}
EOFSS
        isproxy=exproxy
    done
    cronfile="/root/9Hits/crontab"
cat > $cronfile <<EOFSS
* * * * * /root/9Hits/crashdetect.sh
$cronvar
58 23 * * * /root/9Hits/reboot.sh
$lookup
EOFSS
    cd /root
    mv 9Hits-AutoInstall/* /root/9Hits/
    rm -r 9Hits-AutoInstall/
    cd /root/9Hits/
    crontab crontab
    chmod 777 -R /root/9Hits/
    exit
fi
