FROM ubuntu:latest
WORKDIR /opt/goland-image
COPY ./Dockerfile /opt/goland-image
COPY ./READEME /opt/goland-image
COPY ./bash_profile /opt/goland-image
COPY ./vimrc /opt/goland-image
COPY ./env-config.sh /opt/goland-image
COPY ./entrypoint.sh /opt/goland-image

RUN /opt/goland-image/env-config.sh
WORKDIR /opt/go-code
CMD ["sh","/opt/goland-image/entrypoint.sh"]
