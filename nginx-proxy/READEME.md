## nginx正向代理部署

#### 一、docker部署

##### 1、部署

```
docker run -itd --restart=always --name=nginx-proxy -p8080:8080 -p8433:8443 registry.baidubce.com/tools/nginx-proxy:latest
```

##### 2、使用

```
curl --proxy ipaddress:8080 http://www.baidu.com
curl --proxy ipaddress:8443 https://www.baidu.com
```

##### 3、卸载

```
docker rm -f nginx-proxy
```

#### 二、k8s yaml 部署

##### 1、部署

```
kubectl apply -f https://raw.githubusercontent.com/duanshuaixing/tools/master/nginx-proxy/yaml/external-network-nginx-proxy.yaml
```

##### 2、使用

```
curl --proxy ipaddress:30808 http://www.baidu.com
curl --proxy ipaddress:30809 https://www.baidu.com
```

##### 3、卸载

```
kubectl delete -f https://raw.githubusercontent.com/duanshuaixing/tools/master/nginx-proxy/yaml/external-network-nginx-proxy.yaml
```

#### 三、helm部署

##### 1、部署

```
helm repo add external-network https://duanshuaixing.github.io/tools/charts/
helm repo update
helm install external-network github/nginx-proxy
```

##### 2、使用

```
curl --proxy ipaddress:30808 http://www.baidu.com
curl --proxy ipaddress:30809 https://www.baidu.com
```

##### 3、卸载

```
helm delete external-network
helm repo remove external-network
```
