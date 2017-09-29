#!/bin/bash

[ -z "$1" ] && [ $# -ne '1' ] && echo "Please input your domain" && exit 1
[ -n "$1" ] && DOMAIN="$1"

[ ! -f /etc/os-release ] && echo "Not Found Version! " && exit 1;
[ -f /etc/os-release ] && DEB_VER="$(awk -F'[= "]' '/VERSION_ID/{print $3}' /etc/os-release)"
[ -z $DEB_VER ] && echo "Error, Found Version! " && exit 1;
sed -i '/debian wheezy main/'d /etc/apt/sources.list
sed -i '/debian wheezy-backports main/'d /etc/apt/sources.list
sed -i '/debian wheezy-updates main/'d /etc/apt/sources.list
sed -i '/debian jessie main/'d /etc/apt/sources.list
sed -i '/debian jessie-backports main/'d /etc/apt/sources.list
sed -i '/debian jessie-updates main/'d /etc/apt/sources.list
echo "deb http://www.deb-multimedia.org wheezy main" >>/etc/apt/sources.list
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
echo >> /etc/apt/sources.list
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

apt-get update;
DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes deb-multimedia-keyring;
apt-get update;
DEBIAN_FRONTEND=noninteractive apt-get install -y lsb-release openssl autogen autoconf automake gettext pkg-config make gcc m4 libtool zlib1g-dev libpcre3 libpcre3-dev gawk sed grep curl;
DEBIAN_FRONTEND=noninteractive apt-get install -y nginx nginx-common spawn-fcgi libfcgi0ldbl fcgiwrap p7zip-full unzip mysql-server mysql-client vnstat ffmpeg nload;
DEBIAN_FRONTEND=noninteractive apt-get install -y perl coreutils libnet-xwhois-perl libgeo-ipfree-perl libnet-ip-perl liburi-perl libwww-perl libnet-dns-perl;
apt-get update;
DEBIAN_FRONTEND=noninteractive apt-get install -y -t jessie php5 php5-mysql php5-cgi php5-gd php-apc php5-memcached memcached;

mkdir -p /home/status
wget --no-check-certificate -qO '/home/status/index.php' 'https://moeclub.org/attachment/LinuxSoftware/nginx/info.php.deb'
chown -R www-data:www-data /home/status
chmod -R a+x /home/status

rm -rf /etc/nginx
mkdir -p /etc/nginx/sites-available
mkdir -p /etc/nginx/conf.d

wget --no-check-certificate -qO '/etc/nginx/fcgiwrap.conf' 'https://moeclub.org/attachment/LinuxSoftware/nginx/config/fcgiwrap.conf'
wget --no-check-certificate -qO '/etc/nginx/nginx.conf' 'https://moeclub.org/attachment/LinuxSoftware/nginx/config/nginx.conf'
wget --no-check-certificate -qO '/etc/nginx/fcgiwrap-php' 'https://moeclub.org/attachment/LinuxSoftware/nginx/config/fcgiwrap-php'
wget --no-check-certificate -qO '/etc/nginx/fastcgi_params' 'https://moeclub.org/attachment/LinuxSoftware/nginx/config/fastcgi_params'

cat >/etc/nginx/sites-available/default<<EOF
server {
    listen 80 default_server;
    gzip on;
    server_name $DOMAIN;
    root /home/www;
    include /etc/nginx/fcgiwrap.conf;
    location ^~ /status {
        root /home;
        include /etc/nginx/fcgiwrap.conf;
        index index.php;
    }
    location / {
        index index.html index.php /files/_h5ai/public/index.php;
        try_files \$uri \$uri/ /index.php?\$args;
    }
}
EOF
chmod -R a+x /etc/nginx;
mkdir -p /home/www/files;
wget --no-check-certificate -qO /tmp/h5ai.zip 'https://moeclub.org/attachment/LinuxSoftware/directory/h5ai.zip.deb'
7z x /tmp/h5ai.zip -o/home/www/files;
[ -f /home/www/files/_h5ai/public/js/scripts.js ] && sed -i 's|http://moeclub.org|http://'$DOMAIN'|' /home/www/files/_h5ai/public/js/scripts.js
[ -f /home/www/files/_h5ai/public/js/scripts.js ] && sed -i 's|Operation|WEB|g' /home/www/files/_h5ai/public/js/scripts.js
[ -f /home/www/files/_h5ai/public/js/scripts.js ] && sed -i 's|Panel|HOME|g' /home/www/files/_h5ai/public/js/scripts.js
chown -R www-data:www-data /home/www;
chmod -R 754 /home/www;

bash /etc/init.d/mysql stop
sed -i 's/\/var\/lib\/mysql/\/home\/mysql/g' /etc/mysql/my.cnf
cp -prf /var/lib/mysql /home
rm -rf /var/lib/mysql
bash /etc/init.d/mysql start
mysql -u root <<EOFSQL
flush privileges;
EOFSQL

chmod -R a+x /etc/init.d
ln -sf /etc/nginx/fcgiwrap-php /etc/init.d/fcgiwrap
update-rc.d -f fcgiwrap remove
update-rc.d fcgiwrap defaults
bash /etc/init.d/fcgiwrap restart
bash /etc/init.d/nginx restart

mysql_secure_installation

