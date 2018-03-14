Deabin8

# Install node.js
```
wget -qO 'node-v8.10.0.tar.xz' 'https://nodejs.org/dist/v8.10.0/node-v8.10.0-linux-x64.tar.xz'
tar xvf 'node-v8.10.0.tar.xz'
cd /root/node-v8.10.0-*
chown -R root:root ./*
chmod -R a+x ./*
find ./ -maxdepth 1 -type f -exec rm -rf {} \;
cp -raf ./* /
```

