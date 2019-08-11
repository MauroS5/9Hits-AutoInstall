#!/bin/bash
cd /root
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
    else
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
        esac
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
    fi
    if [ $os == "1" ] || [ $os == "2" ]; then
        apt-get update
        apt-get upgrade -y
        apt-get install -y unzip libcanberra-gtk-module curl libxss1 xvfb htop sed tar libxtst6 libnss3 wget
    else
        yum -y update
        yum install -y unzip curl xorg-x11-server-Xvfb sed tar Xvfb wget bzip2 libXcomposite-0.4.4-4.1.el7.x86_64 libXScrnSaver libXcursor-1.1.15-1.el7.x86_64 libXi-1.7.9-1.el7.x86_64 libXtst-1.2.3-1.el7.x86_64 fontconfig-2.13.0-4.3.el7.x86_64 libXrandr-1.5.1-2.el7.x86_64 alsa-lib-1.1.6-2.el7.x86_64 pango-1.42.4-1.el7.x86_64 atk-2.28.1-1.el7.x86_64 psmisc
    fi
    wget http://f.9hits.com/9hviewer/9hviewer-linux-x64.tar.bz2
    tar -xjvf 9hviewer-linux-x64.tar.bz2
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
    exit
fi