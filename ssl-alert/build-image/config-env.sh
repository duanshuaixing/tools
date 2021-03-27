#!/bin/sh
install_crontab(){

    yum -y install openssl crontabs
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
