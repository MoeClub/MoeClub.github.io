#!/bin/bash

ARCH="$(dpkg --print-architecture)"
[ -n "$ARCH" ] || exit 1
apt-get update
apt-get install -y libglib2.0-0
wget -qO '/tmp/libssl1.1.deb' "http://ftp.debian.org/debian/pool/main/o/openssl/libssl1.1_1.1.0f-3+deb9u1_$ARCH.deb"
wget -qO '/tmp/megatools.deb' "http://ftp.debian.org/debian/pool/main/m/megatools/megatools_1.9.98-1_$ARCH.deb"
[ -f '/tmp/libssl1.1.deb' ] && dpkg -i '/tmp/libssl1.1.deb'
[ -f '/tmp/megatools.deb' ] && dpkg -i '/tmp/megatools.deb'


