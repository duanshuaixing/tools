#!/bin/bash
NTP_SERVER=$(cat /etc/ntp.conf |grep prefer|awk '{print $2}')
if [ -z "$NTP_SERVER" ]; then
    NTP_SERVER="cn.pool.ntp.org"
    echo "Using default NTP server: $NTP_SERVER" >> /var/log/ntp/sync.log
fi


mkdir -p /var/log/ntp

ntpd -g -n -x &

sleep 5

if ! ntpq -p; then
    echo "ntpd failed to start" >> /var/log/ntp/error.log
    exit 1
fi

while true; do
    echo "$(date): Starting sync with $NTP_SERVER..." >> /var/log/ntp/sync.log
    if ! ntpdate -u $NTP_SERVER >> /var/log/ntp/sync.log 2>&1; then
        echo "$(date): Sync failed" >> /var/log/ntp/error.log
    else
        echo "$(date): Sync completed" >> /var/log/ntp/sync.log
    fi
    sleep 60
done
