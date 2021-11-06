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

cat >>/etc/yum.repos.d/ceph.repo<<EOF
[Ceph]
name=Ceph packages for x86_64
baseurl=http://mirrors.aliyun.com/ceph/rpm-nautilus/el7/x86_64/
gpgcheck=0
priority=1

[Ceph-noarch]
name=Ceph noarch packages
baseurl=http://mirrors.aliyun.com/ceph/rpm-nautilus/el7/noarch
gpgcheck=0
priority=1

[ceph-source]
name=Ceph source packages
baseurl=http://mirrors.aliyun.com/ceph/rpm-nautilus/el7/SRPMS
gpgcheck=0
priority=1
EOF


    yum makecache
    yum -y install epel-release
    yum -y update
    yum -y install wget lrzsz openssl crontabs jq s3fs-fuse

}

install_sf(){

    #install aws-cli
    curl -LO https://bootstrap.pypa.io/pip/2.7/get-pip.py
    python get-pip.py
    pip install --user awscli boto3
    rm -rf get-pip.py
    export PATH=~/.local/bin:$PATH

    #install rbd client
    yum -y install ceph-common fio smartmontools s3cmd

    # install mongodump client
    yum -y install https://repo.mongodb.org/yum/redhat/7/mongodb-org/5.0/x86_64/RPMS/mongodb-org-server-5.0.1-1.el7.x86_64.rpm
    yum -y install https://repo.mongodb.org/yum/redhat/7/mongodb-org/5.0/x86_64/RPMS/mongodb-org-mongos-5.0.1-1.el7.x86_64.rpm
    yum -y install https://repo.mongodb.org/yum/redhat/7/mongodb-org/5.0/x86_64/RPMS/mongodb-database-tools-100.5.0.x86_64.rpm
    yum -y install https://repo.mongodb.org/yum/redhat/7/mongodb-org/5.0/x86_64/RPMS/mongodb-org-shell-5.0.1-1.el7.x86_64.rpm

    #install registry.baidubce.com/tools/mongo-shake-v2.6.4_2:latest
    wget https://github.com/alibaba/MongoShake/releases/download/release-v2.6.4-20210414/mongo-shake-v2.6.4_2.tar.gz -P /opt/
    tar -xf /opt/mongo-shake-v2.6.4_2.tar.gz -C /opt/
    rm -rf /opt/mongo-shake-v2.6.4_2.tar.gz

    # install ysbc https://github.com/brianfrankcooper/YCSB/
    curl -O --location https://github.com/brianfrankcooper/YCSB/releases/download/0.17.0/ycsb-0.17.0.tar.gz
    tar -xf ycsb-0.17.0.tar.gz -C /opt/
    rm -rf ycsb-0.17.0.tar.gz

    # install etcdctl client
    curl -LO https://github.com/coreos/etcd/releases/download/v3.4.13/etcd-v3.4.13-linux-amd64.tar.gz
    tar -xf etcd-v3.4.13-linux-amd64.tar.gz
    mv etcd-v3.4.13-linux-amd64/etcdctl /usr/local/bin/
    rm -rf etcd-v3.4.13*

    # install mysqldump client
    yum -y install holland-mysqldump.noarch

    #install pg_dump
    yum -y install https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm
    yum -y install postgresql96
 
    
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
