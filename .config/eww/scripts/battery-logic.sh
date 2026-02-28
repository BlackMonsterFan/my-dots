#!/bin/bash
# Твій точний шлях до контролера живлення Lenovo
FILE="/sys/devices/pci0000:00/0000:00:14.3/PNP0C09:00/VPC2004:00/conservation_mode"

if [ "$1" == "get" ]; then
    cat "$FILE"
elif [ "$1" == "toggle" ]; then
    CURRENT=$(cat "$FILE")
    # Якщо 1 (60%), ставимо 0 (100%) і навпаки
    if [ "$CURRENT" -eq 1 ]; then 
        echo 0 > "$FILE"
    else 
        echo 1 > "$FILE"
    fi
fi
