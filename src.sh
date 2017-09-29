#!/bin/bash
[ ! -f /etc/os-release ] && echo "Not Found Version! " && exit 1;
[ -f /etc/os-release ] && DEB_VER="$(awk -F'[= "]' '/VERSION_ID/{print $3}' /etc/os-release)"
[ -z $DEB_VER ] && echo "Error, Found Version! " && exit 1;
sed -i '/debian wheezy main/'d /etc/apt/sources.list
sed -i '/debian wheezy-backports main/'d /etc/apt/sources.list
sed -i '/debian wheezy-updates main/'d /etc/apt/sources.list
sed -i '/debian jessie main/'d /etc/apt/sources.list
sed -i '/debian jessie-backports main/'d /etc/apt/sources.list
sed -i '/debian jessie-updates main/'d /etc/apt/sources.list
echo "deb http://httpredir.debian.org/debian wheezy main" >>/etc/apt/sources.list
echo "deb-src http://httpredir.debian.org/debian wheezy main" >>/etc/apt/sources.list
[ "$DEB_VER" == '7' ] && echo "deb http://httpredir.debian.org/debian wheezy-backports main" >> /etc/apt/sources.list
[ "$DEB_VER" == '7' ] && echo "deb-src http://httpredir.debian.org/debian wheezy-backports main" >> /etc/apt/sources.list
[ "$DEB_VER" == '7' ] && echo "deb http://httpredir.debian.org/debian wheezy-updates main" >> /etc/apt/sources.list
[ "$DEB_VER" == '7' ] && echo "deb-src http://httpredir.debian.org/debian wheezy-updates main" >> /etc/apt/sources.list
echo "deb http://httpredir.debian.org/debian jessie main" >>/etc/apt/sources.list
echo "deb-src http://httpredir.debian.org/debian jessie main" >>/etc/apt/sources.list
[ "$DEB_VER" == '8' ] && echo "deb http://httpredir.debian.org/debian jessie-backports main" >> /etc/apt/sources.list
[ "$DEB_VER" == '8' ] && echo "deb-src http://httpredir.debian.org/debian jessie-backports main" >> /etc/apt/sources.list
[ "$DEB_VER" == '8' ] && echo "deb http://httpredir.debian.org/debian jessie-updates main" >> /etc/apt/sources.list
[ "$DEB_VER" == '8' ] && echo "deb-src http://httpredir.debian.org/debian jessie-updates main" >> /etc/apt/sources.list
sed -i '/deb cdrom/'d /etc/apt/sources.list
sed -i '/^$/'d /etc/apt/sources.list
[ "$DEB_VER" == '7' ] && {
[ -f /etc/apt/preferences ] && mv -f /etc/apt/preferences /etc/apt/preferences.bak
cat >/etc/apt/preferences<<EOFSRC
Package: *
Pin: release wheezy-backports
Pin-Priority: 70

Package: *
Pin: release jessie
Pin-Priority: 60

Package: *
Pin: release jessie-backports
Pin-Priority: 50
EOFSRC
}
[ "$DEB_VER" == '8' ] && {
[ -f /etc/apt/preferences ] && mv -f /etc/apt/preferences /etc/apt/preferences.bak
cat >/etc/apt/preferences<<EOFSRC
Package: *
Pin: release jessie-backports
Pin-Priority: 70

Package: *
Pin: release wheezy
Pin-Priority: 60
EOFSRC
}
apt-get update
