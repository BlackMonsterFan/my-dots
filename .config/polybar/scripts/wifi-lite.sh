#!/bin/bash

# Отримуємо список
RAW_LIST=$(nmcli --rescan no -t -f BARS,SSID,SECURITY,ACTIVE dev wifi list | tail -n +2)

# Форматуємо: Scan + Мережі
MENU_LIST=$(echo "$RAW_LIST" | awk -F: '
    BEGIN { print "󰑐  Scan for networks" }
    {
        lock = ($3 ~ /WPA|WEP/ ? "󰌾" : " ")
        active = ($4 ~ /yes/ ? "󰄬" : " ")
        printf "%s  %s  %s  %s\n", active, $1, $2, lock
    }
')

# Знаходимо номер активного рядка
ACTIVE_ROW=$(echo "$MENU_LIST" | grep -n "󰄬" | cut -d: -f1)
[[ -n "$ACTIVE_ROW" ]] && ROW_IDX=$((ACTIVE_ROW - 1)) || ROW_IDX=-1

# Запуск Rofi з посиланням на файл теми
SELECTED=$(echo "$MENU_LIST" | rofi -dmenu -i \
    -theme ~/.config/polybar/scripts/wifi-theme.rasi \
    -p "Wi-Fi" \
    $( [[ $ROW_IDX -ge 0 ]] && echo "-a $ROW_IDX" ))

# ОБРОБКА ВИБОРУ
if [ -n "$SELECTED" ]; then
    if [[ "$SELECTED" == *"Scan"* ]]; then
        nmcli device wifi rescan
        notify-send "Wi-Fi" "Scanning..."
        sleep 2
        exec "$0"
        exit
    fi

    [[ "$SELECTED" == "󰄬"* ]] && exit 0

    # Витягуємо SSID (все між подвійними пробілами)
    SSID=$(echo "$SELECTED" | sed 's/^..  ..  //' | sed 's/  .$//' | xargs)
    nmcli device wifi connect "$SSID"
fi
