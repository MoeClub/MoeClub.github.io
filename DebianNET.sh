#!/bin/bash

while [[ $# -ge 1 ]]; do
  case $1 in
    -v|--ver)
      shift
      VERtmp="$1"
      shift
      ;;
    -d|--debian|--ubuntu)
      shift
      vDEBtmp="$1"
      shift
      ;;
    -p|--password)
      shift
      WDtmp="$1"
      shift
      ;;
    -a|--auto)
      shift
      INStmp='auto'
      ;;
    -m|--manual)
      shift
      INStmp='manual'
      ;;
    -apt|--mirror)
      shift
      isMirror='1'
      tmpMirror="$1"
      shift
      ;;
    *)
      echo -ne " Usage:\n\tbash $0\t-d/--debian [7/\033[33m\033[04mwheezy\033[0m|8/jessie|9/stretch]\n\t\t\t\t-v/--ver [32/\033[33m\033[04mi386\033[0m|64/amd64]\n\t\t\t\t-apt/--mirror\n\t\t\t\t-a/--auto\n\t\t\t\t-m/--manual\n"
      exit 1;
      ;;
    esac
  done

[ $EUID -ne 0 ] && echo "Error:This script must be run as root!" && exit 1
[ -f /boot/grub/grub.cfg ] && GRUBOLD='0' && GRUBDIR='/boot/grub' && GRUBFILE='grub.cfg'
[ -z $GRUBDIR ] && [ -f /boot/grub2/grub.cfg ] && GRUBOLD='0' && GRUBDIR='/boot/grub2' && GRUBFILE='grub.cfg'
[ -z $GRUBDIR ] && [ -f /boot/grub/grub.conf ] && GRUBOLD='1' && GRUBDIR='/boot/grub' && GRUBFILE='grub.conf'
[ -z $GRUBDIR -o -z $GRUBFILE ] && echo "Error! Not Found grub path." && exit 1

[ -n $vDEBtmp ] && {
[ "$vDEBtmp" == '7' -o "$vDEBtmp" == 'wheezy' ] && linuxdists='debian' && vDEB='wheezy';
[ "$vDEBtmp" == '8' -o "$vDEBtmp" == 'jessie' ] && linuxdists='debian' && vDEB='jessie';
[ "$vDEBtmp" == '9' -o "$vDEBtmp" == 'stretch' ] && linuxdists='debian' && vDEB='stretch';
[ "$vDEBtmp" == 'precise' ] && linuxdists='ubuntu' && vDEB='precise';
[ "$vDEBtmp" == 'trusty' ] && linuxdists='ubuntu' && vDEB='trusty';
[ "$vDEBtmp" == 'wily' ] && linuxdists='ubuntu' && vDEB='wily';
[ "$vDEBtmp" == 'xenial' ] && linuxdists='ubuntu' && vDEB='xenial';
[ "$vDEBtmp" == 'yakkety' ] && linuxdists='ubuntu' && vDEB='yakkety';
[ "$vDEBtmp" == 'zesty' ] && linuxdists='ubuntu' && vDEB='zesty';
}
[ -n $vDEBtmp ] && {
[ "$VERtmp" == '32' -o "$VERtmp" == 'i386' ] && VER='i386';
[ "$VERtmp" == '64' -o "$VERtmp" == 'amd64' ] && VER='amd64';
}

[ -z $linuxdists ] && linuxdists='debian'
[ -n $isMirror ] && [ "$isMirror" == '1' ] && [ -n $tmpMirror ] && {
tmpDebianMirror="$(echo -n "$tmpMirror" |grep -Eo '.*\.(\w+)')"
echo -n "$tmpDebianMirror" |grep -q '://'
[ $? -eq '0' ] && {
DebianMirror="$(echo -n "$tmpDebianMirror" |awk -F'://' '{print $2}')"
} || {
DebianMirror="$(echo -n "$tmpDebianMirror")"
}
} || {
[[ $linuxdists == 'debian' ]] && DebianMirror='httpredir.debian.org'
[[ $linuxdists == 'ubuntu' ]] && DebianMirror='archive.ubuntu.com'
}
[ -z $DebianMirrorDirectory ] && [ -n $DebianMirror ] && [ -n $tmpMirror ] && {
DebianMirrorDirectory="$(echo -n "$tmpMirror" |awk -F''${DebianMirror}'' '{print $2}' |sed 's/\/$//g')"
}
[ "$DebianMirrorDirectory" == '/' ] && [ -n $DebianMirror ] && {
[[ $linuxdists == 'debian' ]] && DebianMirrorDirectory='/debian'
[[ $linuxdists == 'ubuntu' ]] && DebianMirrorDirectory='/ubuntu'
}
[ -z $DebianMirrorDirectory ] && [ -n $DebianMirror ] && {
[[ $linuxdists == 'debian' ]] && DebianMirrorDirectory='/debian'
[[ $linuxdists == 'ubuntu' ]] && DebianMirrorDirectory='/ubuntu'
}

[ -n $INStmp ] && {
[ "$INStmp" == 'auto' ] && inVNC='n'
[ "$INStmp" == 'manual' ] && inVNC='y'
}
[ -n $WDtmp ] && myPASSWORD="$WDtmp"

[ -z $vDEB ] && vDEB='wheezy';
[ -z $VER ] && VER='i386';
[ -z $myPASSWORD ] && myPASSWORD='Vicer'

clear && echo -e "\n\033[36m# Install\033[0m\n"

[ -z $inVNC ] && ASKVNC(){
inVNC='y';
echo -ne "\033[34mCan you login VNC?\033[0m\e[33m[\e[32my\e[33m/n]\e[0m "
read inVNCtmp
[[ -n "$inVNCtmp" ]] && inVNC=$inVNCtmp
[ "$inVNC" == 'y' -o "$inVNC" == 'Y' ] && inVNC='y'
[ "$inVNC" == 'n' -o "$inVNC" == 'N' ] && inVNC='n'
}

[ "$inVNC" == 'y' -o "$inVNC" == 'n' ] || ASKVNC;

[[ $linuxdists == 'debian' ]] && LinuxName='Debian'
[[ $linuxdists == 'ubuntu' ]] && LinuxName='Ubuntu'
[ "$inVNC" == 'y' ] && echo -e "\033[34mManual Mode\033[0m insatll \033[33m$LinuxName\033[0m [\033[33m$vDEB\033[0m] [\033[33m$VER\033[0m] in VNC. "
[ "$inVNC" == 'n' ] && echo -e "\033[34mAuto Mode\033[0m insatll \033[33m$LinuxName\033[0m [\033[33m$vDEB\033[0m] [\033[33m$VER\033[0m]. "

echo -e "\n[\033[33m$vDEB\033[0m] [\033[33m$VER\033[0m] Downloading..."
[ -z $DebianMirror ] && echo -ne "\033[31mError! \033[0mGet debian mirror fail! \n" && exit 1
[ -z $DebianMirrorDirectory ] && echo -ne "\033[31mError! \033[0mGet debian mirror directory fail! \n" && exit 1
wget --no-check-certificate -qO '/boot/initrd.gz' "http://$DebianMirror$DebianMirrorDirectory/dists/$vDEB/main/installer-$VER/current/images/netboot/$linuxdists-installer/$VER/initrd.gz"
[ $? -ne '0' ] && echo -ne "\033[31mError! \033[0mDownload 'initrd.gz' failed! \n" && exit 1
wget --no-check-certificate -qO '/boot/linux' "http://$DebianMirror$DebianMirrorDirectory/dists/$vDEB/main/installer-$VER/current/images/netboot/$linuxdists-installer/$VER/linux"
[ $? -ne '0' ] && echo -ne "\033[31mError! \033[0mDownload 'linux' failed! \n" && exit 1

DEFAULTNET="$(ip route show |grep -o 'default via [0-9]\{1,3\}.[0-9]\{1,3\}.[0-9]\{1,3\}.[0-9]\{1,3\}.*' |head -n1 |sed 's/proto.*\|onlink.*//g' |awk '{print $NF}')"
[ -n "$DEFAULTNET" ] && IPSUB="$(ip addr |grep ''${DEFAULTNET}'' |grep 'global' |grep 'brd' |head -n1 |grep -o '[0-9]\{1,3\}.[0-9]\{1,3\}.[0-9]\{1,3\}.[0-9]\{1,3\}/[0-9]\{1,2\}')"
IPv4="$(echo -n "$IPSUB" |cut -d'/' -f1)"
NETSUB="$(echo -n "$IPSUB" |grep -o '/[0-9]\{1,2\}')"
GATE="$(ip route show |grep -o 'default via [0-9]\{1,3\}.[0-9]\{1,3\}.[0-9]\{1,3\}.[0-9]\{1,3\}' |head -n1 |grep -o '[0-9]\{1,3\}.[0-9]\{1,3\}.[0-9]\{1,3\}.[0-9]\{1,3\}')"
[ -n "$NETSUB" ] && MASK="$(echo -n '128.0.0.0/1,192.0.0.0/2,224.0.0.0/3,240.0.0.0/4,248.0.0.0/5,252.0.0.0/6,254.0.0.0/7,255.0.0.0/8,255.128.0.0/9,255.192.0.0/10,255.224.0.0/11,255.240.0.0/12,255.248.0.0/13,255.252.0.0/14,255.254.0.0/15,255.255.0.0/16,255.255.128.0/17,255.255.192.0/18,255.255.224.0/19,255.255.240.0/20,255.255.248.0/21,255.255.252.0/22,255.255.254.0/23,255.255.255.0/24,255.255.255.128/25,255.255.255.192/26,255.255.255.224/27,255.255.255.240/28,255.255.255.248/29,255.255.255.252/30,255.255.255.254/31,255.255.255.255/32' |grep -o '[0-9]\{1,3\}.[0-9]\{1,3\}.[0-9]\{1,3\}.[0-9]\{1,3\}'${NETSUB}'' |cut -d'/' -f1)"

[ -n "$GATE" ] && [ -n "$MASK" ] && [ -n "$IPv4" ] || {
echo "Not found \`ip command\`, It will use \`route command\`."
ipNum() {
  local IFS='.'
  read ip1 ip2 ip3 ip4 <<<"$1"
  echo $((ip1*(1<<24)+ip2*(1<<16)+ip3*(1<<8)+ip4))
}

SelectMax(){
ii=0
for IPITEM in `route -n |awk -v OUT=$1 '{print $OUT}' |grep '[0-9]\{1,3\}.[0-9]\{1,3\}.[0-9]\{1,3\}.[0-9]\{1,3\}'`
  do
    NumTMP="$(ipNum $IPITEM)"
    eval "arrayNum[$ii]='$NumTMP,$IPITEM'"
    ii=$[$ii+1]
  done
echo ${arrayNum[@]} |sed 's/\s/\n/g' |sort -n -k 1 -t ',' |tail -n1 |cut -d',' -f2
}

[[ -z $IPv4 ]] && IPv4="$(ifconfig |grep 'Bcast' |head -n1 |grep -o '[0-9]\{1,3\}.[0-9]\{1,3\}.[0-9]\{1,3\}.[0-9]\{1,3\}' |head -n1)"
[[ -z $GATE ]] && GATE="$(SelectMax 2)"
[[ -z $MASK ]] && MASK="$(SelectMax 3)"

[ -n "$GATE" ] && [ -n "$MASK" ] && [ -n "$IPv4" ] || {
echo "Error! Not configure network. "
exit 1
}
}

[ -f /etc/network/interfaces ] && {
[[ -z "$(sed -n '/iface.*inet static/p' /etc/network/interfaces)" ]] && AutoNet='1' || AutoNet='0'
[ -d /etc/network/interfaces.d ] && {
ICFGN="$(find /etc/network/interfaces.d -name '*.cfg' |wc -l)" || ICFGN='0'
[ "$ICFGN" -ne '0' ] && {
for NetCFG in `ls -1 /etc/network/interfaces.d/*.cfg`
 do 
  [[ -z "$(cat $NetCFG | sed -n '/iface.*inet static/p')" ]] && AutoNet='1' || AutoNet='0'
  [ "$AutoNet" -eq '0' ] && break
done
}
}
}
[ -d /etc/sysconfig/network-scripts ] && {
ICFGN="$(find /etc/sysconfig/network-scripts -name 'ifcfg-*' |grep -v 'lo'|wc -l)" || ICFGN='0'
[ "$ICFGN" -ne '0' ] && {
for NetCFG in `ls -1 /etc/sysconfig/network-scripts/ifcfg-* |grep -v 'lo$' |grep -v ':[0-9]\{1,\}'`
 do 
  [[ -n "$(cat $NetCFG | sed -n '/BOOTPROTO.*[dD][hH][cC][pP]/p')" ]] && AutoNet='1' || {
  AutoNet='0' && . $NetCFG
  [ -n $NETMASK ] && MASK="$NETMASK"
  [ -n $GATEWAY ] && GATE="$GATEWAY"
}
  [ "$AutoNet" -eq '0' ] && break
done
}
}

[ ! -f $GRUBDIR/$GRUBFILE ] && echo "Error! Not Found $GRUBFILE. " && exit 1

[ ! -f $GRUBDIR/$GRUBFILE.old ] && [ -f $GRUBDIR/$GRUBFILE.bak ] && mv -f $GRUBDIR/$GRUBFILE.bak $GRUBDIR/$GRUBFILE.old
mv -f $GRUBDIR/$GRUBFILE $GRUBDIR/$GRUBFILE.bak
[ -f $GRUBDIR/$GRUBFILE.old ] && cat $GRUBDIR/$GRUBFILE.old >$GRUBDIR/$GRUBFILE || cat $GRUBDIR/$GRUBFILE.bak >$GRUBDIR/$GRUBFILE

[ "$GRUBOLD" == '0' ] && {
CFG0="$(awk '/menuentry /{print NR}' $GRUBDIR/$GRUBFILE|head -n 1)"
CFG2="$(awk '/menuentry /{print NR}' $GRUBDIR/$GRUBFILE|head -n 2 |tail -n 1)"
CFG1=""
for CFGtmp in `awk '/}/{print NR}' $GRUBDIR/$GRUBFILE`
 do
  [ $CFGtmp -gt "$CFG0" -a $CFGtmp -lt "$CFG2" ] && CFG1="$CFGtmp";
 done
[ -z "$CFG1" ] && {
echo "Error! read $GRUBFILE. "
exit 1
}
sed -n "$CFG0,$CFG1"p $GRUBDIR/$GRUBFILE >/tmp/grub.new
[ -f /tmp/grub.new ] && [ "$(grep -c '{' /tmp/grub.new)" -eq "$(grep -c '}' /tmp/grub.new)" ] || {
echo -ne "\033[31mError! \033[0mNot configure $GRUBFILE. \n"
exit 1
}

sed -i "/menuentry.*/c\menuentry\ \'Install OS \[$vDEB\ $VER\]\'\ --class debian\ --class\ gnu-linux\ --class\ gnu\ --class\ os\ \{" /tmp/grub.new
[ "$(grep -c '{' /tmp/grub.new)" -eq "$(grep -c '}' /tmp/grub.new)" ] || {
echo "Error! configure append $GRUBFILE. "
exit 1
}
sed -i "/echo.*Loading/d" /tmp/grub.new
}

[ "$GRUBOLD" == '1' ] && {
CFG0="$(awk '/title /{print NR}' $GRUBDIR/$GRUBFILE|head -n 1)"
CFG1="$(awk '/title /{print NR}' $GRUBDIR/$GRUBFILE|head -n 2 |tail -n 1)"
[ -n $CFG0 ] && [ -z $CFG1 -o $CFG1 == $CFG0 ] && sed -n "$CFG0,$"p $GRUBDIR/$GRUBFILE >/tmp/grub.new
[ -n $CFG0 ] && [ -z $CFG1 -o $CFG1 != $CFG0 ] && sed -n "$CFG0,$CFG1"p $GRUBDIR/$GRUBFILE >/tmp/grub.new
[ ! -f /tmp/grub.new ] && echo "Error! configure append $GRUBFILE. " && exit 1
sed -i "/title.*/c\title\ \'Install OS \[$vDEB\ $VER\]\'" /tmp/grub.new
sed -i '/^#/d' /tmp/grub.new
}

[ -n "$(grep 'initrd.*/' /tmp/grub.new |awk '{print $2}' |tail -n 1 |grep '^/boot/')" ] && Type='InBoot' || Type='NoBoot'

LinuxKernel="$(grep 'linux.*/' /tmp/grub.new |awk '{print $1}' |head -n 1)"
[ -z $LinuxKernel ] && LinuxKernel="$(grep 'kernel.*/' /tmp/grub.new |awk '{print $1}' |head -n 1)"
LinuxIMG="$(grep 'initrd.*/' /tmp/grub.new |awk '{print $1}' |tail -n 1)"

[ "$Type" == 'InBoot' ] && {
sed -i "/$LinuxKernel.*\//c\\\t$LinuxKernel\\t\/boot\/linux auto=true hostname=$linuxdists domain= -- quiet" /tmp/grub.new
sed -i "/$LinuxIMG.*\//c\\\t$LinuxIMG\\t\/boot\/initrd.gz" /tmp/grub.new
}

[ "$Type" == 'NoBoot' ] && {
sed -i "/$LinuxKernel.*\//c\\\t$LinuxKernel\\t\/linux auto=true hostname=$linuxdists domain= -- quiet" /tmp/grub.new
sed -i "/$LinuxIMG.*\//c\\\t$LinuxIMG\\t\/initrd.gz" /tmp/grub.new
}

sed -i '$a\\n' /tmp/grub.new

[ "$inVNC" == 'n' ] && {
GRUBPATCH='0'
[ -f /etc/network/interfaces -o -d /etc/sysconfig/network-scripts ] && {
sed -i ''${CFG0}'i\\n' $GRUBDIR/$GRUBFILE
sed -i ''${CFG0}'r /tmp/grub.new' $GRUBDIR/$GRUBFILE
[ -z $AutoNet ] && echo "Error, Not found interfaces config." && exit 1
[ -f  $GRUBDIR/grubenv ] && sed -i 's/saved_entry/#saved_entry/g' $GRUBDIR/grubenv
[ -d /boot/tmp ] && rm -rf /boot/tmp
mkdir -p /boot/tmp/
cd /boot/tmp/
gzip -d < ../initrd.gz | cpio --extract --verbose --make-directories --no-absolute-filenames >>/dev/null 2>&1
cat >/boot/tmp/preseed.cfg<<EOF
d-i debian-installer/locale string en_US
d-i console-setup/layoutcode string us

d-i keyboard-configuration/xkb-keymap string us

d-i netcfg/choose_interface select auto

d-i netcfg/disable_autoconfig boolean true
d-i netcfg/dhcp_failed note
d-i netcfg/dhcp_options select Configure network manually
d-i netcfg/get_ipaddress string $IPv4
d-i netcfg/get_netmask string $MASK
d-i netcfg/get_gateway string $GATE
d-i netcfg/get_nameservers string 8.8.8.8
d-i netcfg/no_default_route boolean true
d-i netcfg/confirm_static boolean true

d-i mirror/country string manual
d-i mirror/http/hostname string $DebianMirror
d-i mirror/http/directory string $DebianMirrorDirectory
d-i mirror/http/proxy string

d-i passwd/root-login boolean ture
d-i passwd/make-user boolean false
d-i passwd/root-password password $myPASSWORD
d-i passwd/root-password-again password $myPASSWORD
d-i user-setup/allow-password-weak boolean true
d-i user-setup/encrypt-home boolean false

d-i clock-setup/utc boolean true
d-i time/zone string US/Eastern
d-i clock-setup/ntp boolean true

d-i partman/early_command string \
debconf-set partman-auto/disk "\$(list-devices disk |head -n1)"; \
debconf-set grub-installer/bootdev string "\$(list-devices disk |head -n1)"; \
umount /media || true;
d-i partman/mount_style select uuid
d-i partman-auto/init_automatically_partition select Guided - use entire disk
d-i partman-auto/method string regular
d-i partman-lvm/device_remove_lvm boolean true
d-i partman-md/device_remove_md boolean true
d-i partman-auto/choose_recipe select atomic
d-i partman-partitioning/confirm_write_new_label boolean true
d-i partman/choose_partition select finish
d-i partman-lvm/confirm boolean true
d-i partman-lvm/confirm_nooverwrite boolean true
d-i partman/confirm boolean true
d-i partman/confirm_nooverwrite boolean true

d-i debian-installer/allow_unauthenticated boolean true

tasksel tasksel/first multiselect minimal
d-i pkgsel/update-policy select none
d-i pkgsel/include string openssh-server
d-i pkgsel/upgrade select none

popularity-contest popularity-contest/participate boolean false

d-i grub-installer/only_debian boolean true
d-i grub-installer/bootdev string default
d-i finish-install/reboot_in_progress note
d-i debian-installer/exit/reboot boolean true
d-i preseed/late_command string	\
sed -i 's/^.*PermitRootLogin.*/PermitRootLogin yes/g' /target/etc/ssh/sshd_config; \
sed -i 's/^.*PasswordAuthentication.*/PasswordAuthentication yes/g' /target/etc/ssh/sshd_config;
EOF
[ "$AutoNet" -eq '1' ] && {
sed -i '/netcfg\/disable_autoconfig/d' /boot/tmp/preseed.cfg
sed -i '/netcfg\/dhcp_options/d' /boot/tmp/preseed.cfg
sed -i '/netcfg\/get_.*/d' /boot/tmp/preseed.cfg
sed -i '/netcfg\/confirm_static/d' /boot/tmp/preseed.cfg
}
[ "$vDEB" == 'trusty' ] && GRUBPATCH='1'
[ "$vDEB" == 'wily' ] && GRUBPATCH='1'
[ "$GRUBPATCH" == '1' ] && {
sed -i 's/^d-i\ grub-installer\/bootdev\ string\ default//g' /boot/tmp/preseed.cfg
}
[ "$GRUBPATCH" == '0' ] && {
sed -i 's/debconf-set\ grub-installer\/bootdev.*\"\;//g' /boot/tmp/preseed.cfg
}
[ "$vDEB" == 'xenial' ] && {
sed -i 's/^d-i\ clock-setup\/ntp\ boolean\ true/d-i\ clock-setup\/ntp\ boolean\ false/g' /boot/tmp/preseed.cfg
}
[ "$linuxdists" == 'debian' ] && {
sed -i '/user-setup\/allow-password-weak/d' /boot/tmp/preseed.cfg
sed -i '/user-setup\/encrypt-home/d' /boot/tmp/preseed.cfg
sed -i '/pkgsel\/update-policy/d' /boot/tmp/preseed.cfg
sed -i 's/umount\ \/media.*\;//g' /boot/tmp/preseed.cfg
}
rm -rf ../initrd.gz
find . | cpio -H newc --create --verbose | gzip -9 > ../initrd.gz
rm -rf /boot/tmp
}
}

[ "$inVNC" == 'y' ] && {
sed -i '$i\\n' $GRUBDIR/$GRUBFILE
sed -i '$r /tmp/grub.new' $GRUBDIR/$GRUBFILE
echo -e "\n\033[33m\033[04mIt will reboot! \nPlease look at VNC! \nSelect\033[0m\033[32m Install OS [$vDEB $VER] \033[33m\033[4mto install system.\033[04m\n\n\033[31m\033[04mThere is some information for you.\nDO NOT CLOSE THE WINDOW! \033[0m\n"
echo -e "\033[35mIPv4\t\tNETMASK\t\tGATEWAY\033[0m"
echo -e "\033[36m\033[04m$IPv4\033[0m\t\033[36m\033[04m$MASK\033[0m\t\033[36m\033[04m$GATE\033[0m\n\n"

read -n 1 -p "Press Enter to reboot..." INP
if [ "$INP" != '' ] ; then
echo -ne '\b \n'
echo "";
fi
}

chown root:root $GRUBDIR/$GRUBFILE
chmod 444 $GRUBDIR/$GRUBFILE

sleep 3 && reboot >/dev/null 2>&1
