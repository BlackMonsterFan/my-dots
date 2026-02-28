#!/bin/bash
FILE="/sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode"
STATUS=$(cat "$FILE")

# Закриваємо меню після кліку
eww close powermenu

if [ "$STATUS" -eq 1 ]; then
    echo 0 > "$FILE"
    notify-send "Battery" "󰂄 Charging to 100%" -u normal
else
    echo 1 > "$FILE"
    notify-send "Battery" "󰒃 Conservation Mode (60%)" -u normal
fi
