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

function avajoke() {
    a1=("What you got" "What's up")
    a2=("file" "script" "IBM" "Backblaze" "apkpure")
    bruh1=${a1[$((RANDOM%${#a1[@]}))]}
    bruh2=${a2[$((RANDOM%${#a2[@]}))]}
    echo "$bruh1, $bruh2? You got NOTHIN'! ----Ava"
}

function init() {
    cd
    rm rclone* aria2* -rf
    wget https://downloads.rclone.org/rclone-current-linux-amd64.zip
    unzip rclone-current-linux-amd64.zip
    for file in `ls | grep "rclone-v"`
    do
        # alias rclone="~/$file/rclone"
        rclonecmd="$(pwd)/$file/rclone"
    done
    wget https://github.com/q3aql/aria2-static-builds/releases/download/v1.35.0/aria2-1.35.0-linux-gnu-64bit-build1.tar.bz2
    tar -xvjf aria2-1.35.0-linux-gnu-64bit-build1.tar.bz2
    # alias aria2c="~/aria2-1.35.0-linux-gnu-64bit-build1/aria2c"
    aria2cmd="$(pwd)/aria2-1.35.0-linux-gnu-64bit-build1/aria2c"
    rcloneconf=`"$rclonecmd" config file | grep ".conf"`
    echo "[$remotename]" > "$rcloneconf"
    echo "type = b2" >> "$rcloneconf"
    echo "account = $b2id" >> "$rcloneconf"
    echo "key = $b2key" >> "$rcloneconf"
    echo "hard_delete = true" >> "$rcloneconf"
    # "$rclonecmd" lsd "$remotename:$bucketname"
    cd "$currentdir"
}

function reupload() {
    [ ! -d "$tmpdir" ] && mkdir $tmpdir; cd $tmpdir; rm $tmpdir/* -f
    [ "$aria2" ] && "$aria2cmd" -R -s 16 -x 16 -k 1M --header="User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:62.0) Gecko/20100101 Firefox/62.0" "$resurl" -o "$resfilename" || wget --user-agent="Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:62.0) Gecko/20100101 Firefox/62.0" "$resurl" -O "$resfilename"
                
    for file in `ls`
    do
        "$rclonecmd" -vv copy "$file" "$remotename:$bucketname/$foldername"
        echo "$anticsite/file/$bucketname/$foldername/$file" >> "$currentdir/results.$foldername.txt"
        rm "$file" -f
    done
}

function apkpure() { # $1 = apkpure search term, $2 = foldername
    foldername="$2"
    aria2="JAJAJA"
    keyword="$1"
    author="a certain short haired cutie with glasses and blue eyes lover that you all know:wiebitte:"
    "$rclonecmd" -vv purge "$remotename:$bucketname/$foldername"
    
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
            resfilename=`echo "$damn" | grep -Eo 'span class="file".*<span class="fsize"' | sed 's/span class="file">//g' | sed 's/ <span class="fsize"//g'`
            resurl=`echo "$damn" | grep 'iframe id="iframe_download"' | sed 's/"/\n/g' | grep "http"`
            if [ "$resurl" ]
            then
                reupload
            fi
        done
    done
    cd "$currentdir"
    "$rclonecmd" -vv copy "$currentdir/results.$foldername.txt" "$remotename:$bucketname/$foldername"
    rm "$currentdir/results.$foldername.txt" -f
    
    finaltime=`date +%s%N`
    # usedtime=`echo "scale=3;($finaltime - $starttime)/1000000000" | bc`
    usedtime=`awk -v x=$finaltime -v y=$starttime 'BEGIN{printf "%.3f",(x-y)/1000000000}'`
    echo -e "Thanks for usin' this shitty arse bot, this bot has finished dumpin' apks in \033[36m$usedtime\033[0m second(s), see u next time"
    echo -e "and results was stored in \033[36m$currentdir/results.$foldername.txt\033[0m and \033[36m$anticsite/file/$bucketname/$foldername/results.$foldername.txt\033[0m"
    IFS=$OLD_IFS
}

function loop() {
    OLD_IFS=$IFS
    IFS=$'\n'
    toilet_chan_has_smol_dicc="JAJAJAJAJA"
    cat /dev/null > "$listenfile" # to ignore the last unfinished job
    rm backblazeapkpure.php -f
    wget "https://github.com/die-Deutsche-Orthopaedie/shitty-arse-discord-bots/raw/master/backblazeapkpure.php" # time for the bootstrappin' antics
    sed -i "s/\[insert your listenfile name here\]/${listenfile##*/}/g" backblazeapkpure.php
    sed -i "s/\[insert your antics domain name here\]/${anticsite//\//\\/}/g" backblazeapkpure.php
    sed -i "s/\[insert your bucket name here\]/$bucketname/g" backblazeapkpure.php
    while [ "$toilet_chan_has_smol_dicc" ]
    do
        x=`cat "$listenfile"`
        if [ "$x" ]
        then
            kw=`echo "$x" | cut -f1 -d\|`
            folder=`echo "$x" | cut -f2 -d\|`
            # reads parameter from file that's written by perhaps php
            # echo "$kw" "$folder"
            apkpure "$kw" "$folder" > "log.$folder.txt" 2>&1
            cat /dev/null > "$listenfile"
        else
            avajoke
        fi
        sleep 2
    done
    IFS=$OLD_IFS
}

OLD_IFS=$IFS
IFS=$'\n'

original_parameters="$0"

for parameter in "$@"
do
    original_parameters="$original_parameters '$parameter'"
done

currentdir=`pwd`
rm "$tmpdir"/* -f
parameters=`getopt -o l:L:hH -a -l loop:,help -- "$@"`

if [ $? != 0 ]
then
    echo "Houston, we have an arsefockin' problem: Unrecognized Option Detected, Terminating....." >&2
    exit 2
fi

if [ $# -eq 0 ]
then
    echo "Houston, we have an arsefockin' problem: You MUST at least provide a parameter" >&2
    exit 1
fi

eval set -- "$parameters"

while true
do
    echo $@
    case "$1" in
        -l | -L | --loop)
            loop="JAJAJAJAJA"
            listenfile="$2"
            shift 2
            ;;
        -h | -H | --help)
            echo "copyrekt die deutsche Orthopädiespezialist 2020"
            echo "backblaze antics script, to use ibm cloud and backblaze to collect all of apkpure's apk under a certain search term and reupload them (and link file about them) into backblaze"
            echo "so perhaps you don't need to spend a futabruhin' cent for it"
            echo "just sign up ibm cloud and backblaze today! :wiebitte:"
            echo "required: a B2 id and key in backblaze's app key, a bucket name that's previously created, remote name can be anythin'"
            echo 'parameters: bash backblazeapkpure.sh "$b2id" "$b2key" "$bucketname" "$keyword" "$folder_in_backblaze" (optional'
            echo
            echo "Usage: "
            echo "bash backblazeapkpure.sh [options] b2id b2key bucketname keyword [folder_in_backblaze]"
            echo
            echo "Options: "
            echo "  -l or -L or --loop <listenfile>: it would summon an infinite loop to detect a certain file every 2 seconds to receive keyword and perhaps folder_in_backblaze, which can be modified by php or whatever you'll deploy into ibm cloud"
            echo "    the listened file shall be empty without input and shall be filled with \"keyword|folder_in_backblaze\" only when inputted"
            echo
            echo "channel id should be <chatroom id/channel id> format"
            echo "picarchive_channel_id is the channel to reupload pics from source channel"
            echo "by default it shall use a webhook to upload smol pics, but big pics shall be uploaded by a nitro account"
            exit
            shift
            ;;
        --)
            b2id="$2"
            b2key="$3"
            bucketname="$4"
            currentdir=`pwd`
            init
            break
            ;;
        *)
            echo "Internal error!"
            exit 255
            ;;
    esac
done

echo "$loop"
if [ "$loop" ]
then
    loop
else
    [ "$6" ] && apkpure "$5" "$6" || apkpure "$5" "$5"
fi
