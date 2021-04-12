#!/bin/bash
# 加载环境变量
. /etc/default/locale

#发送钉钉消息
send_message(){
    curl "$dingtalk_token" -H 'Content-Type: application/json' -d "{\"actionCard\": {\"text\": \"$context\",},\"msgtype\": \"actionCard\"}"
}

if [ $# -ne 1 ]; then
  echo "usage: /ssl-alert.sh www.baidu.com:443"
else
    #计算SSL正式到期时间和当前时间的差值
    host=$1
    end_data=`date +%s -d "$(echo |openssl s_client -servername $host  -connect $host 2>/dev/null | openssl x509 -noout -dates|awk -F '=' '/notAfter/{print $2}')"`
    new_date=$(date +%s)
    days=$(expr $(expr $end_data - $new_date) / 86400)
   
   if [ $days -lt 15 ]; then
      context="您的$host 证书 还有${days}天到期  请及时处理"
      send_message
   fi
fi
