<<!
 **********************************************************
 * Author        : duanshuaixing
 * Email         : duanshuaixing@gmail.com
 * Last modified : 2021-10-30 12:08
 * Filename      : config-env.sh
 * Description   : databases backup client 
 * *******************************************************
!
#!/usr/bin/bash

yum_config(){

    yum makecache
    yum -y --nogpgcheck install epel-release
    yum -y --nogpgcheck update
    yum -y --nogpgcheck install tmux wget lrzsz openssl crontabs jq s3fs-fuse
    yum -y --nogpgcheck install tcpdump tcping figlet nmap bind-utils mtr traceroute hping3 fping stress iperf iftop htop nethogs
    
}

config_crontab(){

    echo "* * * * * date >/root/crontab-date" >/etc/cron.d/crontab-list
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
    sed -i 's/required/sufficient/g' /etc/pam.d/crond
    chmod 0644 /etc/cron.d/crontab-list
    crontab /etc/cron.d/crontab-list
    
}

install_sf(){

    storage_cli(){

        #install aws-cli
        curl -LO https://bootstrap.pypa.io/pip/2.7/get-pip.py
        python get-pip.py
        pip install --user awscli boto3
        rm -rf get-pip.py
        #export PATH=~/.local/bin:$PATH

        #install rbd client
        yum -y --nogpgcheck install ceph-common fio smartmontools s3cmd
    }

    databases_cli(){

        # install mongodump client
        yum -y --nogpgcheck install https://repo.mongodb.org/yum/redhat/7/mongodb-org/5.0/x86_64/RPMS/mongodb-org-server-5.0.1-1.el7.x86_64.rpm
        yum -y --nogpgcheck install https://repo.mongodb.org/yum/redhat/7/mongodb-org/5.0/x86_64/RPMS/mongodb-org-mongos-5.0.1-1.el7.x86_64.rpm
        yum -y --nogpgcheck install https://repo.mongodb.org/yum/redhat/7/mongodb-org/5.0/x86_64/RPMS/mongodb-database-tools-100.5.0.x86_64.rpm
        yum -y --nogpgcheck install https://repo.mongodb.org/yum/redhat/7/mongodb-org/5.0/x86_64/RPMS/mongodb-org-shell-5.0.1-1.el7.x86_64.rpm

        #install mongo-shake-v2.6.4_2
        wget https://github.com/alibaba/MongoShake/releases/download/release-v2.6.4-20210414/mongo-shake-v2.6.4_2.tar.gz -P /opt/
        tar -xf /opt/mongo-shake-v2.6.4_2.tar.gz -C /opt/
        rm -rf /opt/mongo-shake-v2.6.4_2.tar.gz

        # install ysbc https://github.com/brianfrankcooper/YCSB/

        # java
        yum -y --nogpgcheck install java-devel

        # maven
        wget https://archive.apache.org/dist/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz -P /opt/
        tar -xf /opt/apache-maven-3.6.3-bin.tar.gz -C /opt/
        rm -rf /opt/apache-maven-3.6.3-bin.tar.gz

        #ycsb
        wget https://github.com/brianfrankcooper/YCSB/releases/download/0.17.0/ycsb-mongodb-binding-0.17.0.tar.gz -P /opt/
        tar -xf /opt/ycsb-mongodb-binding-0.17.0.tar.gz -C /opt/
        rm -rf /opt/ycsb-mongodb-binding-0.17.0.tar.gz

        # install etcdctl client
        curl -LO https://github.com/coreos/etcd/releases/download/v3.4.13/etcd-v3.4.13-linux-amd64.tar.gz
        tar -xf etcd-v3.4.13-linux-amd64.tar.gz
        mv etcd-v3.4.13-linux-amd64/etcdctl /usr/local/bin/
        rm -rf etcd-v3.4.13*

        # install mysqldump client
        yum -y --nogpgcheck install holland-mysqldump.noarch

        #install pg_dump
        yum -y --nogpgcheck install https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm
        yum -y --nogpgcheck install postgresql
 
    }

    config_crontab
    storage_cli
    databases_cli
}

clean_env(){

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

    yum_config && \
    install_sf && \
    clean_env

}

main
