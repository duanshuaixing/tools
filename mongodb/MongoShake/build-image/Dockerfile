FROM alpine:latest as mongo-shake
MAINTAINER duanshuaixing "duanshuaixing@gmail.com"
RUN wget https://github.com/alibaba/MongoShake/releases/download/release-v2.8.2-20221215/mongo-shake-v2.8.2.tgz  -P /opt/ && tar -xf /opt/mongo-shake-v2.8.2.tgz -C /opt/

FROM centos:centos7.8.2003
COPY --from=mongo-shake /opt/mongo-shake-v2.8.2 /opt/mongo-shake-v2.8.2
RUN yum -y install kde-l10n-Chinese glibc-common && yum clean all &&localedef -c -f UTF-8 -i zh_CN zh_CN.utf8
ENV LC_ALL zh_CN.UTF-8
WORKDIR /opt/mongo-shake-v2.8.2
CMD ["/bin/sleep","3650d"]
