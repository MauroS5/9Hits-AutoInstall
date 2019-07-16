#!/bin/bash
while [ ! $(pidof 9hmultiss) ]; do
        killall 9htl 9hviewer 9hbrowser 9hmultiss
        Xvfb :1 &
        export DISPLAY=:1 && /root/9HitsViewer_x64/9h_start.sh > /dev/null
        exit
done
