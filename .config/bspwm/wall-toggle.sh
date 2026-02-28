#!/bin/bash

STATIC_WALL="$HOME/Wallpapers/Static/test.jpg"
ANIMATED_WALL="$HOME/Wallpapers/Animated/test.mp4"

if pgrep -f "mpv --wid=0" > /dev/null
then
    pkill -f "mpv --wid=0"
    feh --bg-fill "$STATIC_WALL"
else
    # Додані параметри для миттєвого старту та апаратного прискорення
    mpv --wid=0 --loop=inf --no-audio --hwdec=auto --vo=xv --x11-bypass-compositor=yes --wid=0 "$ANIMATED_WALL" &
fi
