#!/bin/bash
while [[ $# -ge 1 ]]; do
  case $1 in
    -t|--type)
      shift
      tmpType="$1"
      shift
      ;;
    -h|--head)
      shift
      tmpHead="$1"
      shift
      ;;
    *)
      echo 'Error! invaild input.'
      exit 1;
      ;;
    esac
  done

[ -n tmpType ] && loadType=$(echo -n $tmpType |sed 's/,/ /g') || loadType='';
[ -n tmpHead ] && loadHead=$(echo -n $tmpHead |sed 's/\s//g') || loadHead='';
[ -n "$loadHead" ] && Head=''${loadHead}'_' || Head='';
[ -z "$loadType" ] && echo "Please input file type! " && exit 1

export Num='0'
for iType in `echo $loadType`
 do
  ls -1 *.$iType >/dev/null 2>&1
  [ $? -eq '0' ] && {
    iNum="$(ls -1 *.$iType |wc -l)"
    Num=$[Num+iNum]
  }
 done

[ $Num == '0' ] && echo 'Not found file! ' && exit 1
[ $Num -lt '100' ] && NUM=2;
[ $Num -ge '100' ] && [ $Num -lt '1000' ] && NUM=3;
[ $Num -ge '1000' ] && [ $Num -lt '10000' ] && NUM=4;
[ $Num -ge '10000' ] && [ $Num -lt '100000' ] && NUM=5;
[ $Num -ge '100000' ] && echo 'The number of file too large! ' && exit 1

ListFile(){
IFS=$'\n'
for var in `ls -1 *.$1`
 do
  [ -z "$NUM" ] && echo "Error ! "&& break;
  [ -n "$NUM" ] && i=$[$i+1];
  [ $NUM -eq '2' ] && [ $i -lt '10' ] && mv -f "$var" ''${Head}'0'${i}'.'${1}'';
  [ $NUM -eq '2' ] && [ $i -ge '10' ] && mv -f "$var" ''${Head}''${i}'.'${1}'';
  [ $NUM -eq '3' ] && [ $i -lt '10' ] && mv -f "$var" ''${Head}'00'${i}'.'${1}'';
  [ $NUM -eq '3' ] && [ $i -ge '10' ] && [ $i -lt '100' ] && mv -f "$var" ''${Head}'0'${i}'.'${1}'';
  [ $NUM -eq '3' ] && [ $i -ge '100' ] && [ $i -lt '1000' ] && mv -f "$var" ''${Head}''${i}'.'${1}'';
  [ $NUM -eq '4' ] && [ $i -lt '10' ] && mv -f "$var" ''${Head}'000'${i}'.'${1}'';
  [ $NUM -eq '4' ] && [ $i -ge '10' ] && [ $i -lt '100' ] && mv -f "$var" ''${Head}'00'${i}'.'${1}'';
  [ $NUM -eq '4' ] && [ $i -ge '100' ] && [ $i -lt '1000' ] && mv -f "$var" ''${Head}'0'${i}'.'${1}'';
  [ $NUM -eq '4' ] && [ $i -ge '1000' ] && [ $i -lt '10000' ] && mv -f "$var" ''${Head}''${i}'.'${1}'';
  [ $NUM -eq '5' ] && [ $i -ge '10' ] && mv -f "$var" ''${Head}'0000'${i}'.'${1}'';
  [ $NUM -eq '5' ] && [ $i -ge '10' ] && [ $i -lt '100' ] && mv -f "$var" ''${Head}'000'${i}'.'${1}'';
  [ $NUM -eq '5' ] && [ $i -ge '100' ] && [ $i -lt '1000' ] && mv -f "$var" ''${Head}'00'${i}'.'${1}'';
  [ $NUM -eq '5' ] && [ $i -ge '1000' ] && [ $i -lt '10000' ] && mv -f "$var" ''${Head}'0'${i}'.'${1}'';
  [ $NUM -eq '5' ] && [ $i -ge '10000' ] && [ $i -lt '100000' ] && mv -f "$var" ''${Head}''${i}'.'${1}'';
 done
}

i=0
for iType in `echo $loadType`
 do
  ListFile $iType
 done


