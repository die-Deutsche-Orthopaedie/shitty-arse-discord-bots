#!/bin/bash
# copyrekt die deutsche Orthopädiespezialist 2021
# bash version of dudisk svip link parsing script inspired by https://github.com/yuantuo666/baiduwp-php/
# usage: ./dudisk.sh sharelink [password]
# parse svip link of all files in a share link, and export them into a download.sharelink.sh, then you can just bash download.sharelink.sh to download all files and they will be in the same directory hierarchy as share link
# svip links only have 8 hours before expiration

BDUSS='' # any dudisk account shall be fine
STOKEN='' # any dudisk account shall be fine
SVIP_BDUSS='' # svip account only
APP_ID='250528'

function urldecode() { : "${*//+/ }"; echo -e "${_//%/\\x}"; }

function rawurlencode() {
  local string="${1}"
  local strlen=${#string}
  local encoded=""
  local pos c o

  for (( pos=0 ; pos<strlen ; pos++ )); do
     c=${string:$pos:1}
     case "$c" in
        [-_.~a-zA-Z0-9] ) o="${c}" ;;
        * )               printf -v o '%%%02x' "'$c"
     esac
     encoded+="${o}"
  done
  echo "${encoded}"    # You can either set a return variable (FASTER) 
  REPLY="${encoded}"   #+or echo the result (EASIER)... or both... :p
}

function verifypw() { # $1 = share url but removed 1 in the beginning, $2 = pw
    result=`curl "https://pan.baidu.com/share/verify?channel=chunlei&clienttype=0&web=1&app_id=250528&surl=$1" -H "User-Agent: netdisk" -H "Referer: https://pan.baidu.com/disk/home" --data "pwd=$2" 2>/dev/null`
    echo $result | sed 's/,/\n/g' | grep '"randsk"' | sed 's/"randsk":"//g;s/"}//g'
}

function getdllink() { # $1 = fsid
    fsid="$1"
    sekey='{"sekey":"'`urldecode $randsk`'"}'
    sekey=`rawurlencode $sekey`
    result=`curl "https://pan.baidu.com/api/sharedownload?app_id=$APP_ID&channel=chunlei&clienttype=12&sign=$sign&timestamp=$timestamp&web=1" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.514.1919.810 Safari/537.36" -H "Cookie: BDUSS=$BDUSS;STOKEN=$STOKEN;BDCLND=$randsk" -H "Referer: https://pan.baidu.com/disk/home" --data "encrypt=0&extra=$sekey&fid_list=[$fsid]&primaryid=$shareid&uk=$uk&product=share&type=nolimit" 2>/dev/null`
    dlink=`echo $result | grep -Po '"dlink":".*?"' | sed 's/"dlink":"//g;s/"$//g'`
    dlink="${dlink//\\/}"
    curl -s -I -X POST  "$dlink" -H "User-Agent: LogStatistic" -H "Cookie: BDUSS=$SVIP_BDUSS" 2>/dev/null | grep "Location:" | sed 's/^Location: //g' 
}

function getfilelist() { 
    result=`curl "https://pan.baidu.com/s/$shareurl" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.514.1919.810 Safari/537.36" -H "Cookie: BDUSS=$BDUSS;STOKEN=$STOKEN;BDCLND=$randsk" 2>/dev/null | grep -Eo "yunData.setData\((\{.*?\})\)" | sed 's/^yunData.setData(//g;s/)$//g'`
    uk=`echo $result | grep -Eo '"uk":[0-9]*' | grep -Eo '[0-9]*'`
    shareid=`echo $result | grep -Eo '"shareid":[0-9]*' | grep -Eo '[0-9]*'`
    timestamp=`echo $result | grep -Eo '"timestamp":[0-9]*' | grep -Eo '[0-9]*'`
    sign=`echo $result | grep -Po '"sign":".*?"' | sed 's/"sign":"//g;s/"$//g'`
    
    for line in `echo $result | grep -Po '"list":\[.*?\]' | sed 's/^"list":\[//g;s/\]$//g' | sed 's/},{/},\n{/g'`
    do
        # echo "$line"
        local dirsign=`echo "$line" | grep -Eo '"isdir":[0-9]*' | grep -Eo '[0-9]*'`
        local fsid=`echo "$line" | grep -Eo '"fs_id":[0-9]*' | grep -Eo '[0-9]*'`
        local filepath=`urldecode echo "$line" | grep -Po '"path":".*?"' | sed 's/"path":"//g;s/"$//g'`
        filepath="${filepath//\\/}"
        fileparentpath=`urldecode echo "$line" | grep -Po '"parent_path":".*?"' | sed 's/"parent_path":"//g;s/"$//g'`
        fileparentpath="${fileparentpath//\\/}"
        local resultpath=".${filepath//$fileparentpath/}"
        local filename=`urldecode echo "$line" | grep -Po '"server_filename":".*?"' | sed 's/"server_filename":"//g;s/"$//g'`
        filename="${filename//\\/}"
        local resultpath2="${resultpath//$filename/}"
        local filesize=`echo "$line" | grep -Eo '"size":[0-9]*' | grep -Eo '[0-9]*'`
        local filemd5=`urldecode echo "$line" | grep -Po '"md5":".*?"' | sed 's/"md5":"//g;s/"$//g'`
        
        if [ "$dirsign" -eq 0 ]
        then
            echo -e "detected file: \e[36m$resultpath\e[0m"
            dllink=`getdllink $fsid | sed 's/\r//g'`
            echo "# file name: $filename" >> "download.$shareurl.sh"
            echo "# file path: $resultpath" >> "download.$shareurl.sh"
            echo "# file size: $filesize" >> "download.$shareurl.sh"
            echo "# file md5 checksum: $filemd5" >> "download.$shareurl.sh"
            echo "aria2c --user-agent='LogStatistic' --dir='$resultpath2' --out='$filename' -k 1M -x 128 -s 128 -j 64 -R -c --auto-file-renaming=false '$dllink'" >> "download.$shareurl.sh"
            echo >> "download.$shareurl.sh"
            echo -e "file \e[36m$resultpath\e[0m finished processin'"
            echo
        else
            echo -e "detected folder: \e[36m$resultpath\e[0m"
            echo
            getdir "$filepath"
            echo -e "folder \e[36m$resultpath\e[0m finished processin'"
            echo
        fi
    done
}

function getdir() { # recrusive function, $1 = path
    dir="$1"
    for line in `curl "https://pan.baidu.com/share/list?shareid=$shareid&uk=$uk&dir=$dir" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.514.1919.810 Safari/537.36" -H "Cookie: BDUSS=$BDUSS;STOKEN=$STOKEN;BDCLND=$randsk" 2>/dev/null | grep -Po '"list":\[.*?\]' | sed 's/^"list":\[//g;s/\]$//g' | sed 's/},{/},\n{/g'`
    do
        # echo "$line"
        local dirsign=`echo "$line" | grep -Eo '"isdir":[0-9]*' | grep -Eo '[0-9]*'`
        local fsid=`echo "$line" | grep -Eo '"fs_id":[0-9]*' | grep -Eo '[0-9]*'`
        local filepath=`urldecode echo "$line" | grep -Po '"path":".*?"' | sed 's/"path":"//g;s/"$//g'`
        filepath="${filepath//\\/}"
        local resultpath=".${filepath//$fileparentpath/}"
        local filename=`urldecode echo "$line" | grep -Po '"server_filename":".*?"' | sed 's/"server_filename":"//g;s/"$//g'`
        filename="${filename//\\/}"
        local resultpath2="${resultpath//$filename/}"
        local filesize=`echo "$line" | grep -Eo '"size":[0-9]*' | grep -Eo '[0-9]*'`
        local filemd5=`urldecode echo "$line" | grep -Po '"md5":".*?"' | sed 's/"md5":"//g;s/"$//g'`
        
        if [ "$dirsign" -eq 0 ]
        then
            echo -e "detected file: \e[36m$resultpath\e[0m"
            dllink=`getdllink $fsid | sed 's/\r//g'`
            echo "# file name: $filename" >> "download.$shareurl.sh"
            echo "# file path: $resultpath" >> "download.$shareurl.sh"
            echo "# file size: $filesize" >> "download.$shareurl.sh"
            echo "# file md5 checksum: $filemd5" >> "download.$shareurl.sh"
            echo "aria2c --user-agent='LogStatistic' --dir='$resultpath2' --out='$filename' -k 1M -x 128 -s 128 -j 64 -R -c --auto-file-renaming=false '$dllink'" >> "download.$shareurl.sh"
            echo >> "download.$shareurl.sh"
            echo -e "file \e[36m$resultpath\e[0m finished processin'"
            echo
        else
            echo -e "detected folder: \e[36m$resultpath\e[0m"
            echo
            getdir "$filepath"
            echo -e "folder \e[36m$resultpath\e[0m finished processin'"
            echo
        fi
    done
}

OLD_IFS=$IFS
IFS=$'\n'

shareurl="$1"
pw="$2"
shareurl1="${shareurl#1}"

echo -e "\e[36mcopyrekt die deutsche Orthopädiespezialist 2021\e[0m"
echo -e "\e[36mbash version of dudisk svip link parsing script inspired by \e[32mhttps://github.com/yuantuo666/baiduwp-php/\e[0m"

randsk=`verifypw "$shareurl1" "$pw"`
if [ ! "$randsk" ]
then
    echo -e "\e[31mpassword error:futabruh:\e[0m"
    exit 1145141919810
fi

echo -e "\e[36mgeneratin' \e[32mdownload.$shareurl.sh...\e[0m"
cat /dev/null > "download.$shareurl.sh"
echo

getfilelist

echo -e "\e[32mdownload.$shareurl.sh\e[36m generation complete, you can use \e[32mbash download.$shareurl.sh\e[36m to download all files, have fun:paimonbitte:\e[0m"

IFS=$OLD_IFS
