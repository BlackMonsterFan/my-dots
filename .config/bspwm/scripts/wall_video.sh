#!/bin/bash

# зупиняємо все старе
killall mpv 2>/dev/null
killall xwinwrap 2>/dev/null
killall feh 2>/dev/null

# вибираємо випадкове відео
video=$(ls ~/wallpapers/animated/* | shuf -n1)

# запускаємо відео через xwinwrap на фоні
xwinwrap -fs -ni -s -st -sp -b -nf -- mpv --loop --no-audio --wid WID "$video" &
