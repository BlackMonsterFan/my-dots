#!/bin/bash

# Тепер --rescan no стоїть ПІСЛЯ команди list, де йому і місце
RAW_LIST=$(nmcli -t -f BARS,SSID,SECURITY,ACTIVE dev wifi list --rescan no)

echo "$RAW_LIST" | awk -F: '
BEGIN { printf "[\n" }
{
    # Пропускаємо порожні SSID (приховані мережі)
    if ($2 == "") next;
    
    # Екрануємо лапки для валідного JSON
    gsub(/"/, "\\\"", $2);
    
    # Визначаємо іконки та статус
    lock = ($3 ~ /WPA|WEP/ ? "󰌾" : "");
    active = ($4 ~ /yes/ ? "true" : "false");
    
    # Кома між елементами масиву
    if (c++) printf ",\n";
    
    printf "  {\"sig\":\"%s\", \"ssid\":\"%s\", \"lock\":\"%s\", \"active\":%s}", $1, $2, lock, active;
}
END { printf "\n]\n" }
'
