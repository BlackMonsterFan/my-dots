#!/bin/bash

# Перевіряємо, чи є активне з'єднання типу 'wifi'
if nmcli -t -f TYPE,STATE dev | grep -q '^wifi:connected'; then
    # ПІДКЛЮЧЕНО: Твій помаранчевий
    echo "%{F#ff9e64}󰤨 %{F-}"
else
    # ВІДКЛЮЧЕНО: Темно-сірий
    echo "%{F#565f89}󰤭 %{F-}"
fi
