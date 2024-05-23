#!/bin/sh
set -x
curl -I www.baidu.com >/dev/null  2>&1
if [ $? -eq 0 ]; then
    echo "The network is available"
    # 保存环境变量，开启crontab服务
    env > /etc/default/locale
    /usr/sbin/crond -i
    crontab /etc/cron.d/crontab-list
    tail -f /dev/null
else
    echo "The network is unreachable, please check network configuration! "
    exit 1
fi
