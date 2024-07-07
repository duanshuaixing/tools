FROM centos:centos7.8.2003
MAINTAINER duanshuaixing "duanshuaixing@gmail.com"
WORKDIR /opt/
ENV PATH=~/.local/bin:$PATH
ENV PATH=/opt/apache-maven-3.6.3/bin:$PATH
ADD ./Dockerfile /opt/
ADD ./entrypoint.sh /opt/
ADD ./config/ceph.repo /etc/yum.repos.d/
ADD ./config/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo
ADD ./config-env.sh /opt/
ADD ./READEME /opt/
RUN /opt/config-env.sh
ADD ./config-examples/rclone.conf /root/.config/rclone/
WORKDIR /opt/
CMD ["sh","/opt/entrypoint.sh"]
