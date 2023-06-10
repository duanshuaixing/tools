1、获取代码
```bash
git clone -b v1.26.5 https://github.com/kubernetes/kubernetes.git
```
2、修改CA证书为100年, 默认10年
```bash
sed -i 's/10)/100)/g' ./kubernetes/staging/src/k8s.io/client-go/util/cert/cert.go
```
3、修改
```bash
sed -i 's/365/365 * 100/g' ./kubernetes/cmd/kubeadm/app/constants/constants.go
```
4、检查修改
```bash
cd kubernetes
git diff
```
5、、 
```bash
kubeadm certs check-expiration
```
6、、
```bash
./kubeadm-v1.26.5-tls-100y certs renew all
kubeadm certs check-expiration 
```
