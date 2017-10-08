#shadowsocks-libev 3.0.8 with simple-obfs  (Debian7+)
```
wget --no-check-certificate -qO- 'https://moeclub.github.io/ss/install.sh' |bash 

```

#shadowsocks client     
Android:     
[shadowsocks_v4.2.5.apk](https://moeclub.github.io/ss/shadowsocks_v4.2.5.apk)     
[shadowsocks_plugin_simple-obfs.apk](https://moeclub.github.io/ss/shadowsocks_plugin_simple-obfs.apk)     


#/etc/shadowsocks-libev/config.json     
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
