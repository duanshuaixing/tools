FROM centos:centos7.8.2003
MAINTAINER duanshuaixing "duanshuaixing@gmail.com"
ADD ./ssl-alert.sh /opt/ssl-alert.sh
ADD ./config-env.sh /opt/config-env.sh
ADD ./entrypoint.sh /opt/entrypoint.sh
ADD ./Dockerfile /opt/Dockerfile
ADD ./ssl-alert-k8s.yaml /opt/ssl-alert-k8s.yaml
ADD ./build.sh /opt/build.sh
RUN /opt/config-env.sh
WORKDIR /opt/
CMD ["sh","/opt/entrypoint.sh"]
