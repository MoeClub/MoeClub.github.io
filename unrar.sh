#!/bin/bash

Bit=$(getconf LONG_BIT)
[ -z "$Bit" ] && echo "Error! " && exit 1;
Ver="$(wget --no-check-certificate -qO- 'https://rarlab.com/download.htm' |grep -o '/rar/rarlinux-\(x64-\)\?[.0-9]\{1,\}.tar.gz')"
[ $Bit == '32' ] && URL="$(echo "$Ver" |sed '/x64-/d')"
[ $Bit == '64' ] && URL="$(echo "$Ver" |grep 'x64-')"
mkdir -p /usr/local/bin
wget --no-check-certificate -qO- "https://rarlab.com/$URL" |tar -Ozx rar/unrar >/usr/local/bin/unrar
[ -f /usr/local/bin/unrar ] && {
chown root:root /usr/local/bin/unrar
chmod a+x /usr/local/bin/unrar
echo 'Install success! '
exit 0
} || {
echo 'Install fail! '
exit 1
}