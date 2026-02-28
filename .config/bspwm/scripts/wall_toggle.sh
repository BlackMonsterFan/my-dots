#!/bin/bash

# Папка зі статичними шпалерами
STATIC_DIR=~/wallpapers/static

# Вибираємо випадковий файл
WALL=$(ls "$STATIC_DIR"/* | shuf -n1)

# Встановлюємо шпалери
feh --bg-fill "$WALL"
