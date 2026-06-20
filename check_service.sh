#!/bin/bash

# Проверка аргумента
if [ -z "$1" ]; then
    echo "Использование: $0 <имя_сервиса>"
    exit 1
fi

SERVICE=$1
LOGFILE="/tmp/check_service.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

echo "$TIMESTAMP - Проверка сервиса: $SERVICE" >> "$LOGFILE"

if systemctl list-unit-files | grep -q "^$SERVICE.service"; then
    STATUS=$(systemctl is-active "$SERVICE" 2>/dev/null)
    if [ "$STATUS" = "active" ]; then
        echo "$TIMESTAMP - Сервис $SERVICE запущен" >> "$LOGFILE"
        echo "Сервис $SERVICE уже запущен."
    else
        echo "$TIMESTAMP - Сервис $SERVICE не запущен. Пытаюсь запустить..." >> "$LOGFILE"
        echo "Сервис $SERVICE не запущен. Пытаюсь запустить..."
        systemctl start "$SERVICE"
        sleep 2
        NEW_STATUS=$(systemctl is-active "$SERVICE" 2>/dev/null)
        if [ "$NEW_STATUS" = "active" ]; then
            echo "$TIMESTAMP - Сервис $SERVICE успешно запущен" >> "$LOGFILE"
            echo "Сервис $SERVICE успешно запущен."
        else
            echo "$TIMESTAMP - Не удалось запустить $SERVICE" >> "$LOGFILE"
            echo "Не удалось запустить $SERVICE."
        fi
    fi
else
    echo "$TIMESTAMP - Сервис $SERVICE не найден" >> "$LOGFILE"
    echo "Сервис $SERVICE не найден в системе."
fi
