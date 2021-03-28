FROM centos:centos7.8.2003
MAINTAINER duanshuaixing "duanshuaixing@gmail.com"
WORKDIR /opt/nginx-proxy
ADD ./src/nginx-1.18.0.tar.gz /opt/nginx-proxy/
ADD ./src/ngx_http_proxy_connect_module.tar.gz /opt/nginx-proxy/
ADD ./src/nginx.conf /opt/nginx-proxy/
ADD ./config-env.sh /opt/nginx-proxy/
RUN /opt/nginx-proxy/config-env.sh
WORKDIR /opt/nginx-proxy
EXPOSE 8080
EXPOSE 8443
CMD ["/usr/local/nginx/sbin/nginx","-g","daemon off;"]
