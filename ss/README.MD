shadowsocks-libev 3.0.8 with obfs
```
#!/bin/bash
## shadowsocks-libev 3.0.8 with obfs for AMD64

wget --no-check-certificate -q 'https://moeclub.github.io/ss/amd64/libudns0_0.4-1+b1_amd64.deb'
wget --no-check-certificate -q 'https://moeclub.github.io/ss/amd64/libc-ares-dev_1.12.0-1~bpo8+1_amd64.deb'
wget --no-check-certificate -q 'https://moeclub.github.io/ss/amd64/libc-ares2_1.12.0-1~bpo8+1_amd64.deb'
wget --no-check-certificate -q 'https://moeclub.github.io/ss/amd64/libsodium18_1.0.13-1~bpo8+1_amd64.deb'
wget --no-check-certificate -q 'https://moeclub.github.io/ss/amd64/libsodium-dev_1.0.13-1~bpo8+1_amd64.deb'
wget --no-check-certificate -q 'https://moeclub.github.io/ss/amd64/libcorkipset1_1.1.1+20150311-7~bpo8+1_amd64.deb'
wget --no-check-certificate -q 'https://moeclub.github.io/ss/amd64/libcorkipset-dev_1.1.1+20150311-7~bpo8+1_amd64.deb'
wget --no-check-certificate -q 'https://moeclub.github.io/ss/amd64/libcork16_0.15.0+ds-11~bpo8+1_amd64.deb'
wget --no-check-certificate -q 'https://moeclub.github.io/ss/amd64/libcork-dev_0.15.0+ds-11~bpo8+1_amd64.deb'
wget --no-check-certificate -q 'https://moeclub.github.io/ss/amd64/libbloom1_1.5-1~bpo8+1_amd64.deb'
wget --no-check-certificate -q 'https://moeclub.github.io/ss/amd64/libbloom-dev_1.5-1~bpo8+1_amd64.deb'
wget --no-check-certificate -q 'https://moeclub.github.io/ss/amd64/libmbedcrypto0_2.4.2-1+deb9u1~bpo8+1_amd64.deb'
wget --no-check-certificate -q 'https://moeclub.github.io/ss/amd64/libmbedtls10_2.4.2-1+deb9u1~bpo8+1_amd64.deb'
wget --no-check-certificate -q 'https://moeclub.github.io/ss/amd64/libmbedtls-dev_2.4.2-1+deb9u1~bpo8+1_amd64.deb'
wget --no-check-certificate -q 'https://moeclub.github.io/ss/amd64/libmbedx509-0_2.4.2-1+deb9u1~bpo8+1_amd64.deb'
wget --no-check-certificate -q 'https://moeclub.github.io/ss/amd64/simple-obfs_0.0.3-5~bpo8+1_amd64.deb'
wget --no-check-certificate -q 'https://moeclub.github.io/ss/amd64/shadowsocks-libev_3.0.8+ds-2~bpo8+1_amd64.deb'

dpkg -i libudns0_0.4-1+b1_amd64.deb libc-ares-dev_1.12.0-1~bpo8+1_amd64.deb libc-ares2_1.12.0-1~bpo8+1_amd64.deb libsodium18_1.0.13-1~bpo8+1_amd64.deb libsodium-dev_1.0.13-1~bpo8+1_amd64.deb libcorkipset1_1.1.1+20150311-7~bpo8+1_amd64.deb libcorkipset-dev_1.1.1+20150311-7~bpo8+1_amd64.deb libcork16_0.15.0+ds-11~bpo8+1_amd64.deb libcork-dev_0.15.0+ds-11~bpo8+1_amd64.deb libbloom1_1.5-1~bpo8+1_amd64.deb libbloom-dev_1.5-1~bpo8+1_amd64.deb libmbedcrypto0_2.4.2-1+deb9u1~bpo8+1_amd64.deb libmbedtls10_2.4.2-1+deb9u1~bpo8+1_amd64.deb libmbedtls-dev_2.4.2-1+deb9u1~bpo8+1_amd64.deb libmbedx509-0_2.4.2-1+deb9u1~bpo8+1_amd64.deb

apt-get install -y apg asciidoc debhelper po-debconf intltool-debian libev-dev libpcre3-dev pkg-config xmlto

dpkg -i shadowsocks-libev_3.0.8+ds-2~bpo8+1_amd64.deb simple-obfs_0.0.3-5~bpo8+1_amd64.deb

```


/etc/shadowsocks-libev/config.json
```
{
    "server":"0.0.0.0",
    "server_port":80,
    "local_port":1080,
    "password":"password",
    "timeout":60,
    "method":"chacha20-ietf-poly1305",
    "plugin":"obfs-server",
    "plugin_opts":"obfs=http"
}
```
