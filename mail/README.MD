# Deabin8

## Install node.js
```
wget --no-check-certificate -qO 'node-v8.10.0.tar.xz' 'https://moeclub.github.io/mail/node-v8.10.0-linux-x64.tar.xz'
tar xvf 'node-v8.10.0.tar.xz'
cd /root/node-v8.10.0-*
chown -R root:root ./*
chmod -R a+x ./*
find ./ -maxdepth 1 -type f -exec rm -rf {} \;
cp -raf ./* /
npm install pm2 -g
pm2 install pm2-logrotate
```
## Install mail
```
wget --no-check-certificate -qO 'mail.tar.gz' 'https://moeclub.github.io/mail/mail.tar.gz'
tar -xvf 'mail.tar.gz'

```

## Start app.js
```
pm2 start app.js --name=mail --log-date-format="YYYY-MM-DD HH:mm Z"
pm2 save
```
