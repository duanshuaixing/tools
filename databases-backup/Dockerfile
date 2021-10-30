FROM centos:centos7.8.2003
MAINTAINER duanshuaixing "duanshuaixing@gmail.com"
WORKDIR /opt/
ADD ./Dockerfile /opt/
ADD ./config-env.sh /opt/
ADD ./READEME /opt/
RUN /opt/config-env.sh
WORKDIR /opt/
ENTRYPOINT ["tail","-f","/dev/null"]
