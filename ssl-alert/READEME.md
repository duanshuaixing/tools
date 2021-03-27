## **证书监控告警工具**

#### 简介：ssl-alert功能和使用注意事项

功能：定时检查SSL到期时间，通过钉钉webhook通知。

注意事项:

- 告警需要联网,网络不通服务会启动失败

- 可以通过修改configmap修改告警时间

- yaml部署和helm部署钉钉webhook地址需要经过base64编码

- yaml部署需要开启reloader滚动更新功能，需要单独部署reloader服务，

- helm部署需要开启reloader滚动更新功能，设置reloader下enable为true

  

#### 一、通过docker 方式部署

1. ##### 准备需要监控的域名和ip，修改/opt/ssl-alert/hosts后需要重启ssl-alert容器

   ```
   mkdir /opt/ssl-alert
   cat <<EOF >/opt/ssl-alert/hosts
   www.baidu.com:443
   www.taobao.com:443
   192.168.86.22:6443
   EOF
   ```
   

   
2. ##### 准备crontab文件ssl-alert-cron，修改ssl-alert-cron需要重启容器

   ```
   echo '30 10 * * * for i in `cat /opt/hosts`; do bash /opt/ssl-alert.sh $i; done' >/opt/ssl-alert/ssl-alert-cron
   ```

3. ##### 挂载需要监控的域名或者ip，指定钉钉的webhook通过docker方式启动

   ```
   docker run -itd --restart=always --env dingtalk_token="https://oapi.dingtalk.com/robot/send?access_token=钉钉群组添加自定义机器人获取token值"  -v /opt/ssl-alert/hosts:/opt/hosts -v /opt/ssl-alert/ssl-alert-cron:/etc/cron.d/ssl-alert-cron --name ssl-alert registry.baidubce.com/tools/ssl-alert:latest
   ```

#### 二、通过yaml部署在k8s中

1. ##### 部署reloader服务,作用是更新secret或者configmap后pod自动重启。reloader服务默认部署在default这个namespace，监听全局，如果已经部署请跳过这一步。

   ```
   kubectl apply -f https://raw.githubusercontent.com/duanshuaixing/tools/master/ssl-alert/yaml/reloader.yaml 
   ```

2. ##### 部署ssl-alert服务，下载yaml并修改钉钉webhook经过base64编码后的值

   ```
   wget https://raw.githubusercontent.com/duanshuaixing/tools/master/ssl-alert/yaml/ssl-alert-k8s.yaml
   #修改dingtalk_token的值，值是钉钉webhook经过base64编码后的字符串
   kubectl apply -f ssl-alert-k8s.yaml
   ```

#### 三、通过helm3部署

1. ##### 克隆helm chart

   ```
   git clone https://github.com/duanshuaixing/tools.git
   ```

2. ##### 部署通过helm部署ssl-alert

   ```
   helm install ssl-alert . --set reloader.enabled=true --set secret.dingtalk_token="Please use the base64 encoded string of dingtalk webhook"
   ```

#### 四、卸载ssl-alert

1. ##### 卸载通过docker方式部署的ssl-alert

   ```
   rm -rf /opt/ssl-alert
   docker rm -f ssl-alert
   docker rmi registry.baidubce.com/tools/ssl-alert:latest
   ```

2. ##### 卸载通过yaml方式部署的ssl-alert

   ```
   kubectl delete -f https://raw.githubusercontent.com/duanshuaixing/tools/master/ssl-alert/yaml/ssl-alert-k8s.yaml
   
   docker rmi registry.baidubce.com/tools/ssl-alert:latest
   
   #其他服务如果依赖reloader请勿指定此操作
   kubectl delete -f https://raw.githubusercontent.com/duanshuaixing/tools/master/ssl-alert/yaml/reloader.yaml
   ```

3. ##### 卸载通过helm方式部署的ssl-alert

   ```
   helm delete ssl-alert
   docker rmi registry.baidubce.com/tools/ssl-alert:latest
   ```
