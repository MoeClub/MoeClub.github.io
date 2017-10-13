#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
#Check Root
[ $(id -u) != "0" ] && { echo "Error: You must be root to run this script"; exit 1; }
apt-get update
apt-get -y install lsb-release
apt-get install -y python screen curl
apt-get install -y python-pip
apt-get install -y git unzip wget
apt-get install -y build-essential

#Pre
[ ! -f ./shadowsocksr.zip ] && wget --no-check-certificate -qO ./shadowsocksr.zip 'https://moeclub.github.io/ssr/shadowsocksr.zip'
[ ! -f ./libsodium-1.0.11.tar.gz ] && wget --no-check-certificate -qO ./libsodium-1.0.11.tar.gz 'https://moeclub.github.io/ssr/libsodium-1.0.11.tar.gz'

#Install shadowsocksr
INSDIR='/usr/local/etc/SSR'
mkdir -p $INSDIR
unzip -o ./shadowsocksr.zip -d $INSDIR
rm -rf ./shadowsocksr*

#Install Libsodium
tar xvf libsodium-*.tar.gz
cd ./libsodium-*
./configure --prefix=/usr
make && make install
ldconfig
cd ..
rm -rf libsodium-*


#Auto boot
cat >$INSDIR/ssr<<EOF
#!/bin/bash
### BEGIN INIT INFO
# Provides:          ssr
# Required-Start: 	\$all
# Required-Stop: 	\$all
# Default-Start:        2 3 4 5
# Default-Stop:         0 1 6
# Short-Description: ssr
# Description: ssr
### END INIT INFO

INSDIR='$INSDIR'
python_ver="\$(ls /usr/bin|grep -e "^python[23]\.[1-9]\+\$"|tail -n1)"
[ -d \$INSDIR/shadowsocksr ] && cd \$INSDIR/shadowsocksr
ulimit -n 512000

case "\$1" in
  start|restart|"")
    kill -9 \$(ps -C "\$python_ver \$INSDIR/shadowsocksr/server.py m" -o pid=) >>/dev/null 2>&1
    \${python_ver} \$INSDIR/shadowsocksr/mujson_mgr.py -c >>/dev/null 2>&1
    PortList="\$(cat \$INSDIR/shadowsocksr/mudb.json |grep '"port":.*' |grep -o '[0-9]\{1,\}')"
    for uPORT in \`echo \$PortList\`
      do
        for NumTMP in \`iptables -L INPUT -n --line-numbers |grep 'dpt:'\$uPORT\$'' |cut -d' ' -f1\`
          do
            iptables -D INPUT "\$(iptables -L INPUT -n --line-numbers |grep 'dpt:'\$uPORT\$'' |cut -d' ' -f1 |head -n1)"
          done
        iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport \$uPORT -j ACCEPT
        iptables -I INPUT -m state --state NEW -m udp -p udp --dport \$uPORT -j ACCEPT
    done
    nohup \${python_ver} \$INSDIR/shadowsocksr/server.py m >>/dev/null 2>&1 &
    ;;
  stop)
    kill -9 \$(ps -C "\$python_ver \$INSDIR/shadowsocksr/server.py m" -o pid=) >>/dev/null 2>&1
    ;;
  add)
    SetList='UserName\nUserPort\nPassword\nMethod\nprotocol\nobfs\nobfs_param'
    UserName="MoeClub"
    UserPort="80"
    Password="Vicer"
    Method="chacha20"
    protocol="auth_sha1_v4"
    obfs="http_simple_compatible"
    obfs_param="wt.sinaimg.cn"
    for item in \`echo -e \$SetList\`
      do
        intmp=''
        eval 'read -p "\$item [exp:'\\$\$item']: " intmp'
        [ -z \$intmp ] && eval "\$item=\\$\$item" || eval "\$item=\$intmp"
      done
    UserPort="\$(echo \$UserPort |grep -o '[0-9]\{1,\}')"
    if [ -z \$UserName ] || [ -z \$UserPort ] || [ -z \$Password ] || [ -z \$Method ] || [ -z \$protocol ] || [ -z \$obfs ]; then
       echo -e "  Either one of 'UserName,UserPort,Password,\nMethod,protocol,obfs,obfs_param' is invaild! "
       exit 1
    fi
    echo
    [ -n \$obfs_param ] && {
      \${python_ver} \$INSDIR/shadowsocksr/mujson_mgr.py -a -u \$UserName -p \$UserPort -k \$Password -m \$Method -O \$protocol -o \$obfs -g \$obfs_param 
    } || {
      \${python_ver} \$INSDIR/shadowsocksr/mujson_mgr.py -a -u \$UserName -p \$UserPort -k \$Password -m \$Method -O \$protocol -o \$obfs
    }
    ;;
  del)
    UserName="MoeClub"
    item='UserName'
    intmp=''
    eval 'read -p "\$item [exp:'\\$\$item']: " intmp'
    [ -z \$intmp ] && echo "Please input username! " && exit 1
    eval "\$item=\$intmp"
    \${python_ver} \$INSDIR/shadowsocksr/mujson_mgr.py -d -u \$UserName
  ;;
  ls)
    [[ -z \$2 ]] && {
      \${python_ver} \$INSDIR/shadowsocksr/mujson_mgr.py -l
    } || {
      \${python_ver} \$INSDIR/shadowsocksr/mujson_mgr.py -l -u \$2
    }
  ;;
  unstall)
    update-rc.d -f ssr remove
    ssr stop
    rm -rf /usr/local/bin/ssr
    rm -rf /etc/init.d/ssr
  ;;
  *)
    echo "Usage: \$0 [start|stop]"
    exit 1
    ;;
esac

EOF

chmod -R a+x $INSDIR
chown -R root:root $INSDIR
ln -sf $INSDIR/ssr /etc/init.d/ssr
ln -sf $INSDIR/ssr /usr/local/bin/ssr
update-rc.d -f ssr remove
update-rc.d -f ssr defaults

#Modify ShadowsocksR
sed -i "s/SERVER_PUB_ADDR =.*/SERVER_PUB_ADDR = '$(wget -qO- checkip.amazonaws.com)'/" $INSDIR/shadowsocksr/apiconfig.py

# Initcfg
bash $INSDIR/shadowsocksr/initcfg.sh >>/dev/null 2>&1


