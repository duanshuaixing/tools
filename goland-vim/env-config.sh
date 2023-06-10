#!/bin/bash
install_sf(){

    mkdir /opt/go-code

    base_sf(){
        apt-get update
        apt-get -y install git wget vim net-tools  bash-completion exuberant-ctags
        apt-get -y install htop iftop sysstat tree curl inetutils-ping iproute2 iperf iperf3 
        apt-get -y install jq sync build-essential
        echo "source /etc/bash_completion" >>~/.bashrc
        cat /opt/goland-image/bash_profile >~/.bash_profile
    }

    base_webterminal(){
        wget https://github.com/tsl0922/ttyd/releases/download/1.7.3/ttyd.x86_64 -P /opt/
        wait
        chmod a+x /opt/ttyd.x86_64
        #./ttyd.x86_64 -p 80 bash
    }


    install_golang(){
        #wget https://golang.google.cn/dl/go1.20.3.linux-amd64.tar.gz -P /opt/
        wget https://golang.org/dl/go1.20.3.linux-amd64.tar.gz -P /opt/
        wait
        tar -xvf /opt/go1.20.3.linux-amd64.tar.gz -C /usr/local/
        wait
        rm -rf /opt/go1.20.3.linux-amd64.tar.gz
        echo "export PATH=\$PATH:/usr/local/go/bin" >>/etc/profile
        echo "source /etc/profile" >>~/.bashrc
        echo "export  LANG=C.UTF-8" >>~/.bashrc
    }

    config_vim(){

        /usr/local/go/bin/go env -w GO111MODULE=on
        /usr/local/go/bin/go env -w GOPROXY=https://goproxy.cn,direct
        /usr/local/go/bin/go env -w GOROOT=/usr/local/go
        /usr/local/go/bin/go env -w GOBIN=/usr/local/go/bin
        /usr/local/go/bin/go env -w GOPATH=/opt/go-code
 
        /usr/local/go/bin/go install mvdan.cc/gofumpt@latest
        /usr/local/go/bin/go install github.com/ofabry/go-callvis@latest
        /usr/local/go/bin/go install github.com/google/gops@latest
        /usr/local/go/bin/go install github.com/mdempsky/gocode@latest
        /usr/local/go/bin/go install golang.org/x/tools/gopls@latest
        /usr/local/go/bin/go install github.com/uudashr/gopkgs/v2/cmd/gopkgs@latest
        /usr/local/go/bin/go install github.com/ramya-rao-a/go-outline@latest
        /usr/local/go/bin/go install github.com/acroca/go-symbols@latest
        /usr/local/go/bin/go install golang.org/x/tools/cmd/guru@latest
        /usr/local/go/bin/go install golang.org/x/tools/cmd/gorename@latest
        /usr/local/go/bin/go install github.com/go-delve/delve/cmd/dlv@latest
        /usr/local/go/bin/go install github.com/rogpeppe/godef@latest
        /usr/local/go/bin/go install github.com/sqs/goreturns@latest
        /usr/local/go/bin/go install golang.org/x/lint/golint@latest
        /usr/local/go/bin/go get -u -v github.com/cweill/gotests/...
        /usr/local/go/bin/go install github.com/fatih/gomodifytags@latest
        /usr/local/go/bin/go install github.com/josharian/impl@latest
        /usr/local/go/bin/go install github.com/davidrjenni/reftools/cmd/fillstruct@latest
        /usr/local/go/bin/go install github.com/haya14busa/goplay/cmd/goplay@latest
        /usr/local/go/bin/go install github.com/godoctor/godoctor@latest
        /usr/local/go/bin/go install github.com/smartystreets/goconvey@latest  
        /usr/local/go/bin/go install github.com/jstemmer/gotags@latest
        /usr/local/go/bin/go install golang.org/x/tools/cmd/goimports@latest 
        /usr/local/go/bin/go install golang.org/x/tools/cmd/godoc@latest
        /usr/local/go/bin/go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
        /usr/local/go/bin/go install github.com/xxjwxc/gormt@latest（gormt -g=true）
        /usr/local/go/bin/go install google.golang.org/protobuf/cmd/protoc-gen-go@latest 
        /usr/local/go/bin/go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
        /usr/local/go/bin/go install github.com/envoyproxy/protoc-gen-validate@latest
        /usr/local/go/bin/go install github.com/goreleaser/goreleaser@latest
 
 
        
        mkdir -p ~/.vim/bundle
        cd ~/.vim/bundle
 
        git clone https://github.com/VundleVim/Vundle.vim.git
        git clone https://github.com/fatih/vim-go.git
        git clone https://github.com/dgryski/vim-godef
        git clone https://github.com/Blackrush/vim-gocode.git
        git clone https://github.com/mattn/vim-goimports.git
        git clone https://github.com/jstemmer/gotags.git
 
 
        cat /opt/goland-image/vimrc >~/.vimrc
        mkdir -p ~/.vim/colors 
        cd ~/.vim/colors
        git clone https://github.com/tomasr/molokai.git
        cp ~/.vim/colors/molokai/colors/molokai.vim  ~/.vim/colors
 
        vim +GoInstallBinaries +qall
        vim +PluginInstall +qall
 
    }

    base_sf
    base_webterminal
    install_golang
    config_vim
}

install_sf
