#!/bin/bash

OBFS='http'
PORT='80'
PASSWORD='MoeClub.org'

Bit='amd64'
DateURL='https://moeclub.github.io/ss'

apt-get -q update
apt-get install -y apg asciidoc debhelper po-debconf intltool-debian libev-dev libpcre3-dev pkg-config xmlto libcap2-bin libpam-cap

DebList="libc6_2.19-18+deb8u10_amd64.deb libc-bin_2.19-18+deb8u10_amd64.deb locales-all_2.19-18+deb8u10_amd64.deb libudns0_0.4-1+b1_amd64.deb libc-ares2_1.12.0-1~bpo8+1_amd64.deb libc-ares-dev_1.12.0-1~bpo8+1_amd64.deb libsodium18_1.0.13-1~bpo8+1_amd64.deb libsodium-dev_1.0.13-1~bpo8+1_amd64.deb libcork16_0.15.0+ds-11~bpo8+1_amd64.deb libcork-dev_0.15.0+ds-11~bpo8+1_amd64.deb libcorkipset1_1.1.1+20150311-7~bpo8+1_amd64.deb libcorkipset-dev_1.1.1+20150311-7~bpo8+1_amd64.deb libbloom1_1.5-1~bpo8+1_amd64.deb libbloom-dev_1.5-1~bpo8+1_amd64.deb libmbedcrypto0_2.4.2-1+deb9u1~bpo8+1_amd64.deb libmbedx509-0_2.4.2-1+deb9u1~bpo8+1_amd64.deb libmbedtls10_2.4.2-1+deb9u1~bpo8+1_amd64.deb libmbedtls-dev_2.4.2-1+deb9u1~bpo8+1_amd64.deb shadowsocks-libev_3.0.8+ds-2~bpo8+1_amd64.deb simple-obfs_0.0.3-5~bpo8+1_amd64.deb"

for DebINS in `echo $DebList`
do
  echo -ne '\033[33m'${DebINS}'\033[0m\t'
  wget --no-check-certificate -q ''${DateURL}'/'${Bit}'/'${DebINS}''
  DEBIAN_FRONTEND=noninteractive dpkg -i --ignore-depends=libc6,locales,libpcre3,init-system-helpers ''${DebINS}'' >>/dev/null 2>&1
  [ $? == '0' ] && echo -e '\033[33m[\033[32mok\033[33m] \033[0m' || echo -e '\033[33m[\033[31mfail\033[33m] \033[0m'
done 

mkdir -p /etc/shadowsocks-libev
cat>/etc/shadowsocks-libev/config.json<<EOF
{
    "server":"0.0.0.0",
    "server_port":$PORT,
    "local_port":1080,
    "password":"$PASSWORD",
    "timeout":60,
    "method":"chacha20-ietf-poly1305",
    "plugin":"obfs-server",
    "plugin_opts":"obfs=$OBFS"
}

EOF
[ -f /etc/init.d/shadowsocks-libev ] && bash /etc/init.d/shadowsocks-libev restart


