#!/bin/bash
cd /root/9Hits/
/root/kill.sh
wget http://f.9hits.com/9hviewer/9h-patch-linux-x64.zip
cd /root/9Hits/9HitsViewer_x64/
unzip 9h-patch-linux-x64.zip
cd /root/9Hits/
rm 9h-patch-linux-x64.zip