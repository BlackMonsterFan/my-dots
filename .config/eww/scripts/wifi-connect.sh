#!/bin/bash

SSID="$1"

# Закриваємо Eww меню одразу
eww close wifi-pop

# Дізнаємось активну мережу
ACTIVE_SSID=$(nmcli -t -f ACTIVE,SSID dev wifi | grep '^yes' | cut -d':' -f2)

# 1. ЛОГІКА ВІДКЛЮЧЕННЯ
if [ "$SSID" == "$ACTIVE_SSID" ]; then
    notify-send "Wi-Fi" "Відключаюсь від $SSID..." -u normal
    nmcli connection down id "$SSID"
    exit 0
fi

notify-send "Wi-Fi" "Обробка мережі $SSID..." -u low

# 2. ПЕРЕВІРКА ВІДОМОЇ МЕРЕЖІ
if nmcli -t -f NAME connection show | grep -Fxq "$SSID"; then
    # Пробуємо підключитися. Якщо не вийде (наприклад, змінився пароль) - йдемо далі
    if nmcli connection up id "$SSID"; then
        notify-send "Wi-Fi" "✅ Підключено до $SSID!" -u normal
        exit 0
    else
        # Видаляємо зламаний профіль, щоб запросити пароль наново
        nmcli connection delete "$SSID"
    fi
fi

# 3. НОВА МЕРЕЖА АБО ЗЛАМАНИЙ ПРОФІЛЬ (запит пароля)
PASS=$(rofi -dmenu -password -p "🔑 Пароль $SSID:" -theme-str 'window {width: 320px; border: 2px; border-color: #ff9e64;}')

if [ -n "$PASS" ]; then
    notify-send "Wi-Fi" "Підключаюсь..." -u low
    if nmcli dev wifi connect "$SSID" password "$PASS"; then
        notify-send "Wi-Fi" "✅ Підключено до $SSID!" -u normal
    else
        notify-send "Wi-Fi" "❌ Помилка: неправильний пароль." -u critical
    fi
fi
