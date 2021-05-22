#!/bin/bash
# 用于分析 Nginx 日志

#创建索引
createIndex(){
  indexFile=$1'.tmp'
  countryIndexFile=$1'.tmp.country'

  echo "Create "$indexFile" Index--------"
  sed -n -r 's/^([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)\W-\W-\W\[(.+?)\]\W"(.+?)"\W([0-9]+).+$/\1|\2|\4|\3/p' $1 > $indexFile

  echo "Create "$countryIndexFile" Index--------"
  awk -F'|' '{a[$1]+=1}END{for (i in a) system("geoiplookup "i" |xargs -0  printf %s:%d:%s "i" "a[i]"")}' $indexFile > $countryIndexFile

  sed -n -r -i  's/^([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+):([0-9])+:.+:\W(.+)$/\1|\2|\3/p' $countryIndexFile
}

#是否重建索引
isInitIndex=false
#是否总计
isTotal=false
#是否地区统计
isCountryTotal=false
#是否时间统计
isQuery=false
#是否 Http status 统计
isHttpStatus=false
beginTime=""
endTime=""
httpStatus=""

while getopts ":f:itq:cs:h" optname
do
    case "$optname" in
      "f")
        fileName=$OPTARG
        ;;
      "i")
        isInitIndex=true
        ;;
      "t")
        isTotal=true
        ;;
      "q")
        set -f # disable glob
        isQuery=true
        IFS=',' array=($OPTARG)
        beginTime=${array[0]}
        endTime=${array[1]}
        ;;
      "c")
        isCountryTotal=true
        ;;
      "s")
        isHttpStatus=true
        httpStatus=$OPTARG
        ;;
      "h")
        echo "All Functions:"
        echo "sh access.sh -f access.log -i -t -q 19/May/2019:00:00:00,19/May/2019:23:59:59 -c -s 404"
        echo "View Total Number:"
        echo "sh access.sh -f access.log -t"
        echo "Top-10 hosts requests:"
        echo "sh access.sh -f access.log -q 19/May/2019:00:00:00,19/May/2019:23:59:59"
        echo "Top-10 country requests:"
        echo "sh access.sh -f access.log -c"
        echo "Top-10 hosts requests from http status:"
        echo "sh access.sh -f access.log -s"
        echo "Refresh Index:"
        echo "sh access.sh -f access.log -i"
        ;;
      ":")
        echo "No argument value for option $OPTARG"
        exit 1
        ;;
      "?")
        echo "Unknown option $OPTARG"
        exit 1
        ;;
      *)
        echo "Unknown error while processing options"
        exit 1
        ;;
    esac
    #echo "option index is $OPTIND"
done

indexFile=$fileName'.tmp'
countryIndexFile=$fileName'.tmp.country'

if [ ! -f "$indexFile" ]; then
echo "index file does not exist, create....."
isInitIndex=true
fi

if [ $isInitIndex == true ]
then
  createIndex $fileName
fi

if [ $isTotal == true ]
then
  fileTotal=`cat $fileName |wc -l `
  indexTotal=`cat $indexFile |wc -l `
  errorTotal=$[fileTotal - indexTotal];
  echo "Total number of lines $fileTotal,HTTP requests $indexTotal, format error $errorTotal"
  echo "========================================"
fi

if [ $isQuery == true ]
then
  echo "Top-10 hosts requests from $beginTime to $endTime:"
  awk -F'|' '{if($2>="'$beginTime' +0800" && $2<="'${endTime}' +0800") a[$1]+=1;}END{for (i in a)print i, ":",a[i]}' $indexFile | sort -r -n -k 2 -t : | head -n 10
  echo "========================================"
fi

if [ $isCountryTotal == true ]
then
  echo "Top-10 country requests:"
  awk -F'|' '{a[$3]+=$2}END{for (i in a)print i, ":",a[i]}' $countryIndexFile | sort -r -n -k 2 -t : | head -n 10
  echo "========================================"
fi

if [ $isHttpStatus == true ]
then
  echo "Top-10 hosts requests form http status $httpStatus :"
  awk -F'|' '{if($3 == "'$httpStatus'") a[$1]+=1}END{for (i in a)print i, ":",a[i]}' $indexFile | sort -r -n -k 2 -t : | head -n 10
  echo "========================================"
fi
