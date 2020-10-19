#!/bin/bash
while [[ ! $(pidof 9hits) ]]; do
        killall 9htl 9hviewer 9hbrowser 9hmultiss
        Xvfb :1 &
        export DISPLAY=:1 && /root/9Hits/9HitsViewer_x64/9hits > /dev/null
        exit
done
