#!/bin/sh
set -x
curl -I https://www.baidu.com >/dev/null  2>&1
if [ $? -eq 0 ]; then
    echo "Dingtalk messages can be pushed"
    # 保存环境变量，开启crontab服务
    env > /etc/default/locale
    /usr/sbin/crond -i
    crontab /etc/cron.d/crontab-list
    tail -f /dev/null
else
    echo "network unreachable, please check network configuration! "
    exit 1
fi
