#!/bin/bash
FILE="/sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode"

# Перевіряємо поточний стан
STATUS=$(cat "$FILE")

if [ "$STATUS" -eq 1 ]; then
    # Вимикаємо режим збереження (заряджаємо до 100%)
    echo 0 > "$FILE"
    notify-send "Battery" "󰂄 Charging to 100%" -u normal
else
    # Вмикаємо режим збереження (тримати 60%)
    echo 1 > "$FILE"
    notify-send "Battery" "󰒃 Conservation Mode (60%)" -u normal
fi

# Оновлюємо віджет (якщо в тебе є змінна для статусу)
eww update battery_status=$(cat "$FILE")
