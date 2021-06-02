FROM alpine:latest as mongo-shake
MAINTAINER duanshuaixing "duanshuaixing@gmail.com"
RUN  wget https://github.com/alibaba/MongoShake/releases/download/release-v2.6.4-20210414/mongo-shake-v2.6.4_2.tar.gz -P /opt/ && \
     tar -xf /opt/mongo-shake-v2.6.4_2.tar.gz -C /opt/

FROM centos:centos7.8.2003
COPY --from=mongo-shake /opt/mongo-shake-v2.6.4 /opt/mongo-shake-v2.6.4
RUN yum -y install kde-l10n-Chinese glibc-common && yum clean all &&localedef -c -f UTF-8 -i zh_CN zh_CN.utf8
ENV LC_ALL zh_CN.UTF-8
WORKDIR /opt/mongo-shake-v2.6.4 
CMD ["/bin/sleep","3650d"]
