shadowsocks-libev 3.0.8 with obfs
```
wget --no-check-certificate -qO- 'https://moeclub.github.io/ss/install.sh' |bash 

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
