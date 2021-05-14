#!/bin/bash
source parameters
source parametersBack

if [ ! -f "parametersBack" ] || [ "$token" != "$tokenBack" ] || [ "$sessions" != "$sessionsBack" ] || [ "$maxcpu" != "$maxcpuBack" ] || [ "$exProxyServer" != "$exProxyServerBack" ] || [ "$restart" != "$restartBack" ] || [ "$name" != "$nameBack" ] || [ "$url" != "$urlBack" ] || [ "$allowAdult" != "$allowAdultBack" ] || [ "$allowPopups" != "$allowPopupsBack" ] || [ "$allowMining" != "$allowMiningBack" ]; then
if [ "$url" != "$urlBack" ]; then
    cd /root/9Hits/
    rm -rf 9HitsViewer_x64 9hits-linux-x64.tar.bz2
    wget -O 9hits-linux-x64.tar.bz2 $url
    tar -xjvf 9hits-linux-x64.tar.bz2
    mv /root/9Hits/9hits-linux-x64 /root/9Hits/9HitsViewer_x64
fi
cd /root/9Hits/
echo tokenBack=$token > parametersBack && echo sessionsBack=$sessions >> parametersBack && echo maxcpuBack=$maxcpu >> parametersBack && echo exProxyServerBack=$exProxyServer >> parametersBack && echo restartBack=$restart >> parametersBack && echo nameBack=$name >> parametersBack && echo urlBack=$url >> parametersBack && echo allowAdultBack=$allowAdult >> parametersBack && echo allowPopupsBack=$allowPopups >> parametersBack && echo allowMiningBack=$allowMining >> parametersBack
cd /root/9Hits/9HitsViewer_x64/
a=$((1 + RANDOM % 28))
case $restart in
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
settings="/root/9Hits/9HitsViewer_x64/settings.json"
cat > $settings <<EOFSS
    {"hiddenColumns":[],"token":"$token","browser":"hide","popups":"$allowPopups","adult":"$allowAdult","coinMn":"$allowMining","autoStart":"yes"}
EOFSS
cd /root/9Hits/9HitsViewer_x64/sessions/
rm -f ss*
isproxy=system
for i in `seq 1 $sessions`;
do
    file="/root/9Hits/9HitsViewer_x64/sessions/ss$i.json"
cat > $file <<EOFSS
{
    "name": "ss$i",
    "note": "$name",
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
EOFSS
cd /root/9Hits/
crontab crontab
fi

