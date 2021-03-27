## **功能：每天上午十点半检查定义的证书到期时间，并通过钉钉通知。告警需要联网,网络不通服务会启动失败**

#### 一、通过docker 方式部署

1. ##### 准备需要监控的域名和ip，修改/opt/ssl-alert/hosts后需要重启ssl-alert容器

   ```bash
   mkdir /opt/ssl-alert
   cat <<EOF >/opt/ssl-alert/hosts
   www.baidu.com:443
   www.taobao.com:443
   192.168.86.22:6443
   EOF
   
   ```

   

2. ##### 准备crontab文件ssl-alert-cron，修改ssl-alert-cron需要重启容器

   ```bash
   echo '30 10 * * * for i in `cat /opt/hosts`; do bash /opt/ssl-alert.sh $i; done' >/opt/ssl-alert/ssl-alert-cron
   ```

3. ##### 挂载需要监控的域名或者ip，指定钉钉的webhook通过docker方式启动

   ```bash
   docker run -itd --restart=always --env dingtalk_token="https://oapi.dingtalk.com/robot/send?access_token=钉钉群组添加自定义机器人获取token值"  -v /opt/ssl-alert/hosts:/opt/hosts -v /opt/ssl-alert/ssl-alert-cron:/etc/cron.d/ssl-alert-cron --name ssl-alert registry.baidubce.com/tools/ssl-alert:latest
   ```

#### 二、通过kubernetes部署



```bash
#不指定namespace默认是default。需要修改dingtalk_token的值经过base64编码
kubectl -n xxx apply -f ssl-alert-k8s.yaml
```

#### 三、通过helm3部署
