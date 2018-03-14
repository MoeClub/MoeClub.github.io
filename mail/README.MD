# Deabin8

## Install node.js
```
wget --no-check-certificate -qO 'node-v8.10.0.tar.gz' 'https://moeclub.github.io/mail/node-v8.10.0-linux-x64.tar.gz'
#wget --no-check-certificate -qO 'node-v8.10.0.tar.gz' 'https://nodejs.org/dist/v8.10.0/node-v8.10.0-linux-x64.tar.gz'
tar xvf 'node-v8.10.0.tar.gz'
cd ./node-v8.10.0*
chown -R root:root ./*
chmod -R a+x ./*
find . -maxdepth 1 -type f -exec rm -rf {} \;
cp -raf ./* /
```
## Install mail
```
wget --no-check-certificate -qO 'mail.tar.gz' 'https://moeclub.github.io/mail/mail.tar.gz'
tar -xvf 'mail.tar.gz'
cd ./mail
npm install
```

## Start app.js
```
cd ./mail && npm start
```
