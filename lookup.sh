#!/bin/bash
sleep 10
cd /root/9Hits/
source parameters
y=$(cat /proc/loadavg | awk '{print $3}')
case $color in
	"1")
        if (( $(echo "$y >= 1.6" | bc -l) && $(echo "$y <= 2.3" | bc -l) )); then
        	exit
        elif (( $(echo "$y < 1.6" | bc -l) )); then
        	echo add one
            let newnumber=$number+1
            sed -i "s|number=$number|number=$newnumber|" parameters
            /root/9Hits/kill.sh
            file="/root/9Hits/9HitsViewer_x64/sessions/$newnumber.json"
cat > $file <<EOFSS
{
    "name": "$newnumber",
    "note": "$note",
    "proxy": {
        "type": "exproxy",
        "server": "",
        "user": "",
        "password": "",
        "exServer": "$exProxyServer"
    }
}
EOFSS
        elif (( $(echo "$y > 2.3" | bc -l) )); then
        	echo delete one
            let newnumber=$number-1
            sed -i "s|number=$number|number=$newnumber|" parameters
            /root/9Hits/kill.sh
            rm /root/9Hits/9HitsViewer_x64/sessions/$number.json
        fi
    ;;
    "2")
        if (( $(echo "$y >= 3" | bc -l) && $(echo "$y <= 3.8" | bc -l) )); then
        	exit
        elif (( $(echo "$y < 3" | bc -l) )); then
        	echo add one
            let newnumber=$number+1
            sed -i "s|number=$number|number=$newnumber|" parameters
            /root/9Hits/kill.sh
            file="/root/9Hits/9HitsViewer_x64/sessions/$newnumber.json"
cat > $file <<EOFSS
{
    "name": "$newnumber",
    "note": "$note",
    "proxy": {
        "type": "exproxy",
        "server": "",
        "user": "",
        "password": "",
        "exServer": "$exProxyServer"
    }
}
EOFSS
        elif (( $(echo "$y > 3.9" | bc -l) )); then
            echo delete one
            let newnumber=$number-1
            sed -i "s|number=$number|number=$newnumber|" parameters
            /root/9Hits/kill.sh
            rm /root/9Hits/9HitsViewer_x64/sessions/$number.json
        fi
    ;;
    "3")
        if (( $(echo "$y >= 5" | bc -l) && $(echo "$y <= 6" | bc -l) )); then
            exit
        elif (( $(echo "$y < 5" | bc -l) )); then
            echo add one
            let newnumber=$number-1
            sed -i "s|number=$number|number=$newnumber|" parameters
            /root/9Hits/kill.sh
            file="/root/9Hits/9HitsViewer_x64/sessions/$newnumber.json"
cat > $file <<EOFSS
{
    "name": "$newnumber",
    "note": "$note",
    "proxy": {
        "type": "exproxy",
        "server": "",
        "user": "",
        "password": "",
        "exServer": "$exProxyServer"
    }
}
EOFSS
        elif (( $(echo "$y > 6" | bc -l) )); then
            echo delete one
            let newnumber=$number-1
            sed -i "s|number=$number|number=$newnumber|" parameters
            /root/9Hits/kill.sh
            rm /root/9Hits/9HitsViewer_x64/sessions/$number.json
        fi
    ;;
    "4")
        if (( $(echo "$y >= 8" | bc -l) && $(echo "$y <= 9" | bc -l) )); then
        	exit
        elif (( $(echo "$y < 8" | bc -l) )); then
        	echo add one
            let newnumber=$number+1
            sed -i "s|number=$number|number=$newnumber|" parameters
            /root/9Hits/kill.sh
            file="/root/9Hits/9HitsViewer_x64/sessions/$newnumber.json"
cat > $file <<EOFSS
{
    "name": "$newnumber",
    "note": "$note",
    "proxy": {
        "type": "exproxy",
        "server": "",
        "user": "",
        "password": "",
        "exServer": "$exProxyServer"
    }
}
EOFSS
        elif (( $(echo "$y > 9" | bc -l) )); then
        	echo delete one
            let newnumber=$number-1
            sed -i "s|number=$number|number=$newnumber|" parameters
            /root/9Hits/kill.sh
            rm /root/9Hits/9HitsViewer_x64/sessions/$number.json
        fi
    ;;
esac
