#!/bin/bash

function UpLoadTree()
{
for DIRF in `dir .`
  do
    if [[ -d $DIRF ]]; then
    RDIRTMP="$(echo "$(pwd)" |sed 's|'${PDIR}'||')"
    cadaver <<EOF
cd $RDIR$RDIRTMP
mkdir ./$DIRF
EOF
      cd $DIRF
      UpLoadTree;
      [ `dir -d` == "." ] && cd ..
    else
    DIRT=$(pwd)
    RDIRTMP="$(echo "$(pwd)" |sed 's|'${PDIR}'||')"
    cadaver <<EOF
cd $RDIR$RDIRTMP
lcd $DIRT
put $DIRF
EOF
fi
done
}

function ReadTree()
{
PDIR=$(dirname $LDIR);
[ -z $PDIR ] && echo 'Error! Not found the folder, Named '${PDIR}'.' && exit 1
cd $PDIR >/dev/null 2>&1;
[ $? -ne '0' ] && echo 'Error! Not access to the folder, Named '${PDIR}'.' && exit 1
RDIR=$(basename $LDIR);
[ -z $RDIR ] && echo 'Error! Not found the folder, Named '${RDIR}'.' && exit 1
dir -d $RDIR >/dev/null 2>&1;
[ $? -ne '0' ] && echo 'Error! Not access to the folder, Named '${RDIR}'.' && exit 1
TMPDIR=$(dir -d $RDIR);
[ "$TMPDIR" != '.' ] && cd $RDIR || {
echo 'Error! Please input a vaild folder.'
exit 1
}
cadaver <<EOF
mkdir ./$RDIR
EOF
UpLoadTree;
}

function UpLoadFile()
{
cadaver <<EOF
put $LDIR
EOF
}

function CheckBASE()
{
NoBASE='0';
while [[ $# -ge 1 ]]; do
 case $1 in
  *)
   which $1 >/dev/null 2>&1;
   [ $? -ne '0' ] && NoBASE='1' && echo 'Error, Not found '${1}'! '
   shift
   ;;
 esac
done
[ $NoBASE == '1' ] && echo 'Please Insatll it first.' && exit 1;
}

IsDIR='0'
IsFILE='0'
CheckBASE dir mkdir sed dirname basename cadaver
LDIR=$1
[ -z $LDIR ] && echo 'Error! Please input a vaild folder or file.' && exit 1
[ -d $LDIR ] && IsDIR='1'
[ -f $LDIR ] && IsFILE='1'
[ $IsDIR == '0' ] && [ $IsFILE == '0' ] && echo 'Error! Not found the folder or file, Named '${LDIR}'.' && exit 1
[ $IsDIR == '1' ] && [ $IsFILE == '1' ] && echo 'Error! File system incorrect.' && exit 1
[ $IsDIR == '1' ] && ReadTree;
[ $IsFILE == '1' ] && UpLoadFile;

