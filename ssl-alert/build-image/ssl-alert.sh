#!/bin/bash
# 加载环境变量
. /etc/default/locale
# 检测https证书有效期
if [ $# -ne 1 ]; then
  echo "请输入需要的检查域名： 例如 ./ssl-alert.sh  www.baidu.com:443"
else
   #参数设置为host
   host=$1
   #最后到期时间转换为时间戳
   end_data=`date +%s -d "$(echo |openssl s_client -servername $host  -connect $host 2>/dev/null | openssl x509 -noout -dates|awk -F '=' '/notAfter/{print $2}')"`
   #当前时间戳
   new_date=$(date +%s)
   #计算SSL证书截止到现在的过期天数
   #计算SSL正式到期时间和当前时间的差值
   days=$(expr $(expr $end_data - $new_date) / 86400)
   if [ $days -gt 15 ]; then
      context="您的$host 证书 状态正常" 
      curl "$dingtalk_token" \
          -H 'Content-Type: application/json' \
          -d "{\"actionCard\": {\"text\": \"$context\",},\"msgtype\": \"actionCard\"}"
   fi
   if [ $days -lt 15 ]; then
      context="您的$host 证书 还有${days}天到期  请及时处理" 
      curl "$dingtalk_token" \
          -H 'Content-Type: application/json' \
          -d "{\"actionCard\": {\"text\": \"$context\",},\"msgtype\": \"actionCard\"}"
   fi
fi
