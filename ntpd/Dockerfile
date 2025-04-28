FROM ubuntu:22.04
LABEL maintainer="duanshuaixing@gmail.com"
ENV TZ=Asia/Shanghai
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get -y install ntp ntpdate tzdata \
    && ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo Asia/Shanghai > /etc/timezone \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /var/lib/ntp
COPY ntp.conf    /etc/ntp.conf
COPY ntp.conf    /opt/ntp.conf
COPY entrypoint.sh /opt/entrypoint.sh
COPY Dockerfile  /opt/Dockerfile
COPY ntpd.yaml   /opt/ntpd.yaml
COPY READEME.txt /opt/READEME.txt
WORKDIR /opt/
EXPOSE 123
ENTRYPOINT ["/usr/bin/bash /opt/entrypoint.sh"]
