#!/bin/sh
install_crontab(){
    yum clean all && yum -y makecache && yum -y update
    yum -y install openssl crontabs
    yum -y install gcc gcc-c++ autoconf automake zlib zlib-devel pcre-devel
    curl -LO https://www.openssl.org/source/openssl-1.1.1i.tar.gz
    tar -xf openssl-1.1.1i.tar.gz && rm -rf openssl-1.1.1i.tar.gz
    cd openssl-1.1.1i
    ./config shared --openssldir=/usr/local/openssl --prefix=/usr/local/openssl
    make -j 8
    make install
    rm -rf /usr/bin/openssl
    ln -s /usr/local/openssl/bin/openssl /usr/bin/openssl
    echo "/usr/local/openssl/lib/" >> /etc/ld.so.conf
    ldconfig
    openssl version
    cd ..
    rm -rf openssl-1.1.1i
}

config_crontab(){

    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
    sed -i 's/required/sufficient/g' /etc/pam.d/crond
    chmod a+x /opt/*.sh
}

clean_env(){

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

install_crontab
config_crontab
clean_env
