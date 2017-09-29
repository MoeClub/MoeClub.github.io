#!/bin/bash  

while [[ $# -ge 1 ]]; do
  case $1 in
    -n|--num)
      shift
      inNum="$1"
      shift
      ;;
    -N|--number)
      shift
      isNumber='1'
      ;;
    -L|--lower)
      shift
      isLower='1'
      ;;
    -U|--upper)
      shift
      isUpper='1'
      ;;
    -h|-H|--help)
      echo -ne " Usage:\n\t$0\t[NUL][number]\n\t\t-N\--number\n\t\t-L\--lower\n\t\t-U\--upper\n"
      exit 1;
      ;;
    *)
      [ -n "$(echo -n "$1" |grep 'N\|number')" ] && isNumber='1'
      [ -n "$(echo -n "$1" |grep 'L\|lower')" ] && isLower='1'
      [ -n "$(echo -n "$1" |grep 'U\|upper')" ] && isUpper='1'
      inNum="$(echo -n "$1" |sed 's/-\|L\|lower\|N\|number\|U\|upper//g')"
      shift
      ;;
    esac
  done

[ -n $inNum ] && [ "$inNum" != "$(echo "$inNum" |grep -o '[0-9]\{1,\}' |xargs |sed 's/ //g')" ] && echo "Error, invalid input." && exit 1;
[ -z $inNum ] && Num='8' || Num="$inNum"
[ "$isLower" != '1' -a "$isUpper" != '1' ] && isNumber='1'

pool_N=(0 1 2 3 4 5 6 7 8 9)
pool_L=(a b c d e f g h i j k l m n o p q r s t u v w x y z)
pool_U=(A B C D E F G H I J K L M N O P Q R S T U V W X Y Z)

[ "$isNumber" == '1' ] && POOL=(${pool_N[@]})
[ "$isLower" == '1' ] && POOL=(${pool_L[@]})
[ "$isUpper" == '1' ] && POOL=(${pool_U[@]})
[ "$isNumber" == '1' ] && [ "$isLower" == '1' ] && POOL=(${pool_N[@]} ${pool_L[@]})
[ "$isNumber" == '1' ] && [ "$isUpper" == '1' ] && POOL=(${pool_N[@]} ${pool_U[@]})
[ "$isLower" == '1' ] && [ "$isUpper" == '1' ] && POOL=(${pool_L[@]} ${pool_U[@]})
[ "$isNumber" == '1' ] && [ "$isLower" == '1' ] && [ "$isUpper" == '1' ] && POOL=(${pool_N[@]} ${pool_L[@]} ${pool_U[@]})

i=0; while :; do STR[$i]=${POOL[$((RANDOM%${#POOL[@]}))]} && i=$[i+1]; [ "$i" -ge "$Num" ] && break; done

for str in ${STR[*]}; do echo -n $str; done
