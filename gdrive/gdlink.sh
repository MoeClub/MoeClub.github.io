#!/bin/bash

FileID="$1";

export URL='https://docs.google.com/uc';
export ACTION='export=download';
export LINK='googleusercontent.com';
export google_file_id_num='24,48';
export CODE='MoeClub';

function RandomSTR(){
Num="$1"
declare -a STR
unset STR
[[ -z "$Num" ]] && Num='4'
pool_N=(0 1 2 3 4 5 6 7 8 9)
pool_L=(a b c d e f g h i j k l m n o p q r s t u v w x y z)
pool_U=(A B C D E F G H I J K L M N O P Q R S T U V W X Y Z)
POOL=(${pool_N[@]} ${pool_L[@]} ${pool_U[@]})
i=0; while :; do STR[$i]=${POOL[$((RANDOM%${#POOL[@]}))]} && i=$[i+1]; [ "$i" -ge "$Num" ] && break; done
for str in ${STR[*]}; do echo -n $str; done
}

cookies_str="$(RandomSTR 6)"
google_cookies='/tmp/google_header_'${cookies_str}'';

function RemoveCookies(){
if [[ -n "${google_cookies}" ]]; then
  if [[ -f ${google_cookies} ]]; then
    rm -rf ${google_cookies};
  fi
fi
}

function EXIT(){
  if [[ "$1" == 'no' ]]; then
    ExitFlag='0';
  else
    ExitFlag='1';
    ExitNum="$(echo "$1" |grep -o '[0-9]*')";
    if [[ -z "$ExitNum" ]]; then
      ExitNum='0';
    fi
  fi
  RemoveCookies;
  if [[ "$ExitFlag" == '1' ]]; then
    exit $ExitNum
  fi
}

function CheckDependence(){
FullDependence='0';
for BIN_DEP in `echo "$1" |sed 's/,/\n/g'`
  do
    if [[ -n "$BIN_DEP" ]]; then
      Founded='0';
      for BIN_PATH in `echo "$PATH" |sed 's/:/\n/g'`
        do
          ls $BIN_PATH/$BIN_DEP >/dev/null 2>&1;
          if [ $? == '0' ]; then
            Founded='1';
            break;
          fi
        done
      if [ "$Founded" == '0' ]; then
        FullDependence='1';
        echo -en "$BIN_DEP\t\t[\033[31mNot Found\033[0m]\n";
      fi
    fi
  done
if [ "$FullDependence" == '1' ]; then
  EXIT 1;
fi
}

function GetFileLink(){
  cat "${google_cookies}" |grep "${LINK}" |grep -v '\[following\]$' |head -n1 |grep -o 'https://.*'
  EXIT 0
}

DOCID="$(echo "${FileID}" |grep -o '[0-9a-zA-Z\_\-]\{'${google_file_id_num}'\}')"
if [[ -z "${DOCID}" ]]; then
  echo "Please input google drive file id."
  EXIT 1;
else
  CheckDependence wget,grep,cat,head
fi
wget --no-check-certificate --server-response --save-headers --spider --max-redirect 0 "${URL}?${ACTION}&id=${DOCID}" >"${google_cookies}" 2>&1

if [[ -f "${google_cookies}" ]]; then
  cat "${google_cookies}" |grep '\[following\]$' |grep -q "${LINK}"
  if [[ $? == '0' ]]; then
    GetFileLink;
  else
    USERCODE="$(cat "${google_cookies}" |grep -o 'download_warning_[0-9]*_'${DOCID}'' |grep -o '_[0-9]*_' |grep -o '[0-9]*')"
    if [[ -n "$USERCODE" ]]; then
      wget --no-check-certificate --server-response --save-headers --spider --max-redirect 0 --header "Cookie: download_warning_${USERCODE}_${DOCID}=${CODE}; Domain=.docs.google.com; Path=/uc; Secure; HttpOnly" "${URL}?${ACTION}&id=${DOCID}&confirm=${CODE}" >"${google_cookies}" 2>&1
      cat "${google_cookies}" |grep '\[following\]$' |grep -q "${LINK}"
      if [[ $? == '0' ]]; then
        GetFileLink;
      fi
    fi
  fi
fi
EXIT 1
