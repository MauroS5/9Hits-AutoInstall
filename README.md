# 9Hits-AutoInstall
AutoInstall for Linux

You have 3 types of install

0. Simple version, you dont need do nothing, you will get only 1 sessions (System)

Example command:

yum -y update || apt update && yum -y install git whiptail || apt install -y git whiptail && cd /root && git clone https://github.com/MauroS5/9Hits-AutoInstall.git && chmod -R 777 9Hits-AutoInstall && 9Hits-AutoInstall/install.sh "0" "d2lpb0dc88554721ca9c3a6a1ef710b3" && rm install.sh

1. Advanced version, code will ask you some questions to make it more custom

Example command:

yum -y update || apt update && yum -y install git whiptail || apt install -y git whiptail && cd /root && git clone https://github.com/MauroS5/9Hits-AutoInstall.git && chmod -R 777 9Hits-AutoInstall && 9Hits-AutoInstall/install.sh "1" "d2lpb0dc88554721ca9c3a6a1ef710b3" && rm install.sh

2. Script version, all in one code by arguments ( You need set it on this order: "Version (0,1,2)" "Token" "Number of sessions" "MaxCpu ussage (Dont use %, just number)

Example command:

yum -y update || apt update && yum -y install git whiptail || apt install -y git whiptail && cd /root && git clone https://github.com/MauroS5/9Hits-AutoInstall.git && chmod -R 777 9Hits-AutoInstall && 9Hits-AutoInstall/install.sh "2" "d2lpb0dc88554721ca9c3a6a1ef710b3" "15" "10" && rm install.sh
