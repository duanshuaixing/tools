## **证书监控告警工具**

#### 简介：ssl-alert功能和使用注意事项

功能：定时检查SSL到期时间，通过钉钉webhook通知。

注意事项:

- 告警需要联网,网络不通服务会启动失败

- 可以通过修改configmap修改告警时间

- yaml部署和helm部署需要填写钉钉webhook地址

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

2. ##### 部署ssl-alert服务，下载yaml并修改钉钉webhook的值

   ```
   wget https://raw.githubusercontent.com/duanshuaixing/tools/master/ssl-alert/yaml/ssl-alert-k8s.yaml
   #修改dingtalk_token的值，值是钉钉webhook经过base64编码后的字符串
   kubectl apply -f ssl-alert-k8s.yaml
   ```
   

#### 三、通过helm3部署

1. ##### 添加repo

   ```
   helm repo add github https://duanshuaixing.github.io/tools/charts/
   helm repo update
   ```

2. ##### 部署通过helm部署ssl-alert

   ```
   helm install ssl-alert github/ssl-alert --set reloader.enabled=false --set secret.dingtalk_token="Please use the dingtalk webhook"
   ```

#### 四、更新监控主机、告警时间、webhook、开启或者关闭reloader

1. ##### 更新监控主机、告警时间

   ```
   导出ssl-alert-configmap到yaml文件
   kubectl  get cm |grep ssl-alert|awk '{print $1}'|xargs kubectl get cm -o yaml >> ssl-alert-configmap.yaml
   
   修改ssl-alert-configmap.yaml后apply这个yaml
   kubectl apply -f ssl-alert-configmap.yaml
   
   重启pod(开启reloader配置后不需要手动重启pod)
   kubectl get pod|grep ssl-alert|awk '{print $1}'|xargs kubectl delete pod
   ```

2. ##### 修改告警webhook
   ###### 1>通过secret修改

   ```	
   kubectl get secrets |grep ssl-alert|grep Opaque|awk '{print $1}'|xargs kubectl get secrets -o yaml >>ssl-alert.yaml
   
   重启pod(开启reloader配置后不需要手动重启pod)
   kubectl get pod|grep ssl-alert|awk '{print $1}'|xargs kubectl delete pod
   ```

   ###### 2> 通过helm更新

   ```
   helm upgrade ssl-alert github/ssl-alert --set reloader.enabled=false --set secret.dingtalk_token=新的webhook地址字符串
   
   重启pod(开启reloader配置后不需要手动重启pod)
   kubectl get pod|grep ssl-alert|awk '{print $1}'|xargs kubectl delete pod
   ```

3. ##### 开启和关闭reloader

   ###### 1>开启reloader

   ```
   helm upgrade ssl-alert github/ssl-alert --set reloader.enabled=true
   ```

   ###### 2>关闭reloader

   ```
   helm upgrade ssl-alert github/ssl-alert --set reloader.enabled=false
   ```

#### 五、卸载ssl-alert

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
