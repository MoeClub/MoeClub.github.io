#!/bin/bash

while [[ $# -ge 1 ]]; do
  case $1 in
    -p|--port)
      shift
      Ptmp="$1"
      shift
      ;;
    -w|--password)
      shift
      Wtmp="$1"
      shift
      ;;
    -m|--method)
      shift
      Mtmp="$1"
      shift
      ;;
    *)
      echo "Invail args! "
      exit 1;
      ;;
    esac
  done

[ -n $Ptmp ] && Port="$Ptmp"
[ -n $Wtmp ] && PassWord="$Wtmp"
[ -n $Wtmp ] && Method="$Mtmp"

arch="$(dpkg --print-architecture)"
[ -n "$arch" ] || exit 1
[ "$arch" == 'amd64' -o "$arch" == 'i386' ] || exit 1
wget --no-check-certificate -qO "/tmp/shadowsocks-libev_2.4.6-1_${arch}.deb" "https://moeclub.github.io/ss/simple/shadowsocks-libev_2.4.6-1_${arch}.deb"
dpkg -i "/tmp/shadowsocks-libev_2.4.6-1_${arch}.deb"
[ -f /etc/shadowsocks-libev/config.json ] && {
[ -z $Port ] && Port='8080'
[ -z $PassWord ] && PassWord='Vicer'
[ -z $Method ] && Method='aes-192-cfb'
cat >/etc/shadowsocks-libev/config.json<<EOF
{
          "server":"0.0.0.0",
          "server_port":$Port,
          "local_port":1080,
          "password":"$PassWord",
          "timeout":60,
          "method":"$Method"
}
EOF
}
[ -f /etc/init.d/shadowsocks-libev ] && bash /etc/init.d/shadowsocks-libev restart

