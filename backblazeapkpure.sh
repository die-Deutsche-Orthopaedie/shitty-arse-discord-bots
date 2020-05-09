#!/bin/bash
# copyrekt die deutsche Orthopädiespezialist 2020
# backblaze antics script, to use ibm cloud and backblaze to collect all of apkpure's apk under a certain search term and reupload them (and link file about them) into backblaze
# so perhaps you don't need to spend a futabruhin' cent for it
# just sign up ibm cloud and backblaze today! :wiebitte:
# required: a B2 id and key in backblaze's app key, a bucket name that's previously created, remote name can be anythin'
# parameters: bash backblazeapkpure.sh "$b2id" "$b2key" "$bucketname" "$keyword" "$folder_in_backblaze" (optional

remotename="wiebitte"
anticsite="https://kawaii.toiletchan.xyz"
tmpdir="/tmp/wiebitte"

function init() {
    cd
    rm rclone* aria2* -rf
    wget https://downloads.rclone.org/rclone-current-linux-amd64.zip
    unzip rclone-current-linux-amd64.zip
    for file in `ls | grep "rclone-v"`
    do
        rclonecmd="$(pwd)/$file/rclone"
    done
    wget https://github.com/q3aql/aria2-static-builds/releases/download/v1.35.0/aria2-1.35.0-linux-gnu-64bit-build1.tar.bz2
    tar -xvjf aria2-1.35.0-linux-gnu-64bit-build1.tar.bz2
    aria2cmd="$(pwd)/aria2-1.35.0-linux-gnu-64bit-build1/aria2c"
    rcloneconf=`"$rclonecmd" config file | grep ".conf"`
    echo "[$remotename]" > "$rcloneconf"
    echo "type = b2" >> "$rcloneconf"
    echo "account = $b2id" >> "$rcloneconf"
    echo "key = $b2key" >> "$rcloneconf"
    echo "hard_delete = true" >> "$rcloneconf"
    "$rclonecmd" ls "$remotename:$bucketname"
    cd "$currentdir"
}

function apkpure() { # $1 = apkpure search term, $2 = foldername
    foldername="$2"
    aria2="JAJAJA"
    keyword="$1"
    author="a certain short haired cutie with glasses and blue eyes lover that you all know:wiebitte:"
    
    starttime=`date +%s%N`
    OLD_IFS=$IFS
    IFS=$'\n'
    finalfish=`curl "https://apkpure.com/search?q=$keyword" | grep "<span>[0-9]*</span> search results found" | grep -Eo "[0-9]*"`
    
    echo -e "apkpure.com fully automatic masspostin' bot developed by \033[36m$author\033[0m"
    echo -e "\033[31mLegal Disclaimer**: this bot's result is completely generated from the target site, so either the author or users of this bot has \033[31mABSOLUTELY NO LIABILITY** for its behaviors, or \033[31mWOULD YOU JUST KINDLY GO DIDDLE YOURSELF YOU SOCIAL JUSTICE ARSEFOCKIN' WORRIORS\033[0m? "
    echo -e "FYI, the search term is \033[36m$keyword\033[0m, and it has \033[36m$finalfish\033[0m search result(s), so enjoy your fockin' apk"
    
    for jajaja in `seq 0 15 $finalfish`
    do 
        for link in `curl "https://apkpure.com/search-page?q=$keyword&t=app&begin=$jajaja" | grep ' <p class="search-title">' | grep -Eo 'href=.*">' | sed 's/href="//g' | sed 's/">//g' `
        do
            damn=`curl "https://apkpure.com$link/download?from=details"`
            apkfilename=`echo "$damn" | grep -Eo 'span class="file".*<span class="fsize"' | sed 's/span class="file">//g' | sed 's/ <span class="fsize"//g'`
            apklink=`echo "$damn" | grep 'iframe id="iframe_download"' | sed 's/"/\n/g' | grep "http"`
            if [ "$apklink" ]
            then
                [ ! -d "$tmpdir" ] && mkdir $tmpdir; cd $tmpdir; rm $tmpdir/* -f
                [ "$aria2" ] && "$aria2cmd" -R -s 16 -x 16 -k 1M --header="User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:62.0) Gecko/20100101 Firefox/62.0" "$apklink" -o "$apkfilename" || wget --user-agent="Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:62.0) Gecko/20100101 Firefox/62.0" "$apklink" -O "$apkfilename"
                
                for file in `ls`
                do
                    "$rclonecmd" -vv copy "$file" "$remotename:$bucketname/$foldername"
                    echo "$anticsite/file/$bucketname/$foldername/$file" >> "$currentdir/results.$foldername.txt"
                    rm "$file" -f
                done
            fi
        done
    done
    cd "$currentdir"
    "$rclonecmd" -vv copy "$currentdir/results.$foldername.txt" "$remotename:$bucketname/$foldername"
    
    finaltime=`date +%s%N`
    # usedtime=`echo "scale=3;($finaltime - $starttime)/1000000000" | bc`
    usedtime=`awk -v x=$finaltime -v y=$starttime 'BEGIN{printf "%.3f",(x-y)/1000000000}'`
    echo -e "Thanks for usin' this shitty arse bot, this bot has finished dumpin' apks in \033[36m$usedtime\033[0m second(s), see u next time"
    echo -e "and results was stored in \033[36m$currentdir/results.$foldername.txt\033[0m and \033[36m$anticsite/file/$bucketname/$foldername/results.$foldername.txt\033[0m"
    IFS=$OLD_IFS
}


b2id="$1"
b2key="$2"
bucketname="$3"
currentdir=`pwd`
init
[ "$5" ] && apkpure "$4" "$5" || apkpure "$4" "$4"
