#!/bin/sh
init_config(){

    yum -y update
    yum -y install make gcc gcc-c++ pcre pcre-devel zlib zlib-devel openssl openssl-devel autoconf automake patch net-tools
}

install_sf(){

    cd /opt/nginx-proxy/nginx-1.18.0
    patch -p1 < /opt/nginx-proxy/ngx_http_proxy_connect_module/patch/proxy_connect_rewrite_101504.patch
    ./configure --add-module=/opt/nginx-proxy/ngx_http_proxy_connect_module
    make -j 8
    make install
    wait
    rm -rf /usr/local/nginx/conf/nginx.conf
    mv /opt/nginx-proxy/nginx.conf /usr/local/nginx/conf/nginx.conf
    /usr/local/nginx/sbin/nginx -c /usr/local/nginx/conf/nginx.conf
    /usr/local/nginx/sbin/nginx -t
    /usr/local/nginx/sbin/nginx -s reload
}

clean_env(){

    rm -rf /opt/nginx-proxy/nginx-1.18.0
    rm -rf /opt/nginx-proxy/ngx_http_proxy_connect_module
    rm -rf /tmp/
    rm -rf /root/anaconda-ks.cfg
    echo > /var/log/wtmp
    echo > /var/log/btmp
    echo>/var/log/lastlog
    echo > /var/log/secure
    echo > /var/log/messages
    echo>/var/log/syslog
    echo>/var/log/yum.log
    echo > ~/.bash_history
    yum clean all
}

main(){

    init_config && \
    install_sf && \
    clean_env

}

main
