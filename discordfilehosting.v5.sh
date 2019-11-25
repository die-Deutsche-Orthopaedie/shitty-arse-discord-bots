#!/bin/bash
# copyrekt die deutsche Orthopädiespezialist 201⑨
# discord "file hostin'" bot (sarcastic
# upload all files of a folder to discord, but this time with multiple accounts and multi-threads support
# auto compress files into 8MB or 50MB volumes if file size excceeded
# auto generate discord link file so you can aria2c its sorry arse afterwards, so that you actually don't need to be limited to bullshit 8MB or 50MB file size limit

maxfilesize=8 # in MB and not in MiB bruh
aria2location="/lea/is/worst/girl/aria2c.exe"

username_defaults="Hermann FEGELEIN! FEGELEIN!! FEGELEIN!!! "
avatarurl_defaults="https://cdn.discordapp.com/attachments/467378952739094539/597940396907036674/FegeleinHeadOrthodox.png"

function ubertantics { # $1 = auth, $2 = guild name, $3 = channel name, $4 = webhook name, $5 = output config file path, $6 = number of channels
    rm "$5" -f
    # create a guild
    response=`curl "https://discordapp.com/api/v6/guilds" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:70.0) Gecko/20100101 Firefox/70.0" -H "Accept: */*" -H "Accept-Language: zh-CN" --compressed -H "Content-Type: application/json" -H "Authorization: $1" -H "Origin: https://discordapp.com" -H "Connection: keep-alive" -H "Referer: https://discordapp.com/@me" -H "Cookie: __cfduid=d18e61b3a58d5bf3884bee6af6f80557c1542341827" -H "TE: Trailers" --data "{\"name\":\"$2\",\"region\":\"us-west\",\"icon\":null}"`
    guildid=`echo "$response" | sed 's/,/\n/g' | grep '"id"' | head -1 | grep -Eo "[0-9]*"`
    syschannelid=`echo "$response" | sed 's/,/\n/g' | grep '"system_channel_id"' | grep -Eo "[0-9]*"`
    if [ ! -f "funnyfaces.txt" ]
    then
        wget "https://cdn.discordapp.com/attachments/598119350850945055/602983449871253505/funnyfaces.txt" -O "funnyfaces.txt"
    fi
    leftfunny=`sed -n "1p" funnyfaces.txt`
    rightfunny=`sed -n "2p" funnyfaces.txt`
    # upload funny emojis :funny_v2:
    response=`curl "https://discordapp.com/api/v6/guilds/$guildid/emojis" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:70.0) Gecko/20100101 Firefox/70.0" -H "Accept: */*" -H "Accept-Language: zh-CN" --compressed -H "Content-Type: application/json" -H "Authorization: $1" -H "Connection: keep-alive" -H "Referer: https://discordapp.com/channels/602959306437951528/602959307985780749" -H "Cookie: __cfduid=d18e61b3a58d5bf3884bee6af6f80557c1542341827" -H "TE: Trailers" --data @- <<CURL_DATA
        {"image":"$leftfunny","name":"funny_v2"}
CURL_DATA`
    leftfunnyid=`echo "$response" | sed 's/,/\n/g' | grep '"id"' | grep -Eo "[0-9]*"`
    # upload another funny emojis :funny_v2_right:
    response=`curl "https://discordapp.com/api/v6/guilds/$guildid/emojis" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:70.0) Gecko/20100101 Firefox/70.0" -H "Accept: */*" -H "Accept-Language: zh-CN" --compressed -H "Content-Type: application/json" -H "Authorization: $1" -H "Connection: keep-alive" -H "Referer: https://discordapp.com/channels/602959306437951528/602959307985780749" -H "Cookie: __cfduid=d18e61b3a58d5bf3884bee6af6f80557c1542341827" -H "TE: Trailers" --data @- <<CURL_DATA
        {"image":"$rightfunny","name":"funny_v2_right"}
CURL_DATA`
    rightfunnyid=`echo "$response" | sed 's/,/\n/g' | grep '"id"' | grep -Eo "[0-9]*"`
    echo "-F|<:funny_v2:$leftfunnyid>|<:funny_v2_right:$rightfunnyid>" >> "$5"
    
    [ "$6" ] && channels="$6" || channels=16
    for channel in `seq 1 $channels`
    do
        # create a channel
        response=`curl "https://discordapp.com/api/v6/guilds/$guildid/channels" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:70.0) Gecko/20100101 Firefox/70.0" -H "Accept: */*" -H "Accept-Language: zh-CN" --compressed -H "Content-Type: application/json" -H "Authorization: $1" -H "Origin: https://discordapp.com" -H "Connection: keep-alive" -H "Referer: https://discordapp.com/channels/$guildid" -H "Cookie: __cfduid=d18e61b3a58d5bf3884bee6af6f80557c1542341827" -H "TE: Trailers" --data "{\"type\":0,\"name\":\"$3$channel\",\"permission_overwrites\":[]}"`
        channelid=`echo "$response" | sed 's/,/\n/g' | grep '"id"' | grep -Eo "[0-9]*"`
        # create a webhook
        response=`curl "https://discordapp.com/api/v6/channels/$channelid/webhooks" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:70.0) Gecko/20100101 Firefox/70.0" -H "Accept: */*" -H "Accept-Language: zh-CN" --compressed -H "Content-Type: application/json" -H "Authorization: $1" -H "Origin: https://discordapp.com" -H "Connection: keep-alive" -H "Referer: https://discordapp.com/channels/$guildid/$channelid" -H "Cookie: __cfduid=d18e61b3a58d5bf3884bee6af6f80557c1542341827" -H "TE: Trailers" --data "{\"name\":\"$4 $channel\"}"`
        token=`echo "$response" | sed 's/,/\n/g' | grep "token" | sed 's/ "token": "//g' | sed 's/"//g'`
        webhookid=`echo "$response" | sed 's/,/\n/g' | grep '"id"' | head -1 | grep -Eo "[0-9]*"`
        curl -F "payload_json={\"content\":\"<:funny_v2:$leftfunnyid><:funny_v2_right:$rightfunnyid>\",\"username\":\"FEGELEIN $channel\",\"avatar_url\":\"https://cdn.discordapp.com/attachments/467378952739094539/597940396907036674/FegeleinHeadOrthodox.png\"}" "https://discordapp.com/api/webhooks/$webhookid/$token"
        echo "-W|https://discordapp.com/api/webhooks/$webhookid/$token" >> "$5"
    done
}

function message { # $1 = message
    [ "${webhookurl[0]}" ] && curl -F "payload_json={\"content\":\"$1\",\"username\":\"${username[0]}\",\"avatar_url\":\"${avatarurl[0]}\"}" "${webhookurl[0]}" || curl "https://discordapp.com/api/v6/channels/${purechannelid[0]}/messages" -H "User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:61.0) Gecko/20100101 Firefox/61.0" -H "Accept: */*" -H "Accept-Language: en-US" --compressed -H "Referer: https://discordapp.com/channels/${channelid[0]}" -H "Content-Type: application/json" -H "Authorization: ${auth[0]}" -H "Cookie: __cfduid=d6fa896e3cb4d9ce5a05e36e3c845ada11531595067" -H "DNT: 1" -H "Connection: keep-alive" --data "{\"content\":\"$1\",\"nonce\":\"46776845$RANDOM$RANDOM$RANDOM\",\"tts\":false}"; 
}

function uploadfile { # $1 = message, #2 = filepath
    [ "${webhookurl["$processid"]}" ] && curl -F "payload_json={\"content\":\"$1\",\"username\":\"${username["$processid"]}\",\"avatar_url\":\"${avatarurl["$processid"]}\"}" -F "filename=@$2" "${webhookurl["$processid"]}" || curl "https://discordapp.com/api/v6/channels/${purechannelid["$processid"]}/messages" -H "User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:61.0) Gecko/20100101 Firefox/61.0" -H "Accept: */*" -H "Accept-Language: en-US" --compressed -H "Referer: https://discordapp.com/channels/${channelid["$processid"]}" -H "Authorization: ${auth["$processid"]}" -H "Content-Type: multipart/form-data; boundary=---------------------------32345443330436" -H "Cookie: __cfduid=d7be2f6bf6a3c09f82cd952f554ea2cb31531625199" -H "DNT: 1" -H "Connection: keep-alive" -F "payload_json={\"content\":\"$1\",\"nonce\":\"46776845$RANDOM$RANDOM$RANDOM\",\"tts\":false}" -F "filename=@$2"
}

function upload_via_url { # $1 = message, #2 = url, #3 = start locaion, #4 = end location, #5 = extra parameters (if any)
    if [ ! "$5" ]
    then
        [ "${webhookurl["$processid"]}" ] && curl --range "$3-$4" "$2" | curl -# -F "payload_json={\"content\":\"$1\",\"username\":\"${username["$processid"]}\",\"avatar_url\":\"${avatarurl["$processid"]}\"}" -F "file=@-" "${webhookurl["$processid"]}" || curl --range "$3"-"$4" "$2" | curl -# "https://discordapp.com/api/v6/channels/${purechannelid["$processid"]}/messages" -H "User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:61.0) Gecko/20100101 Firefox/61.0" -H "Accept: */*" -H "Accept-Language: en-US" --compressed -H "Referer: https://discordapp.com/channels/${channelid["$processid"]}" -H "Authorization: ${auth["$processid"]}" -H "Content-Type: multipart/form-data; boundary=---------------------------32345443330436" -H "Cookie: __cfduid=d7be2f6bf6a3c09f82cd952f554ea2cb31531625199" -H "DNT: 1" -H "Connection: keep-alive" -F "payload_json={\"content\":\"$1\",\"nonce\":\"46776845$RANDOM$RANDOM$RANDOM\",\"tts\":false}" -F "filename=@-"
    else
        [ "${webhookurl["$processid"]}" ] && eval "curl --range '$3-$4' '$2' $5" | curl -# -F "payload_json={\"content\":\"$1\",\"username\":\"${username["$processid"]}\",\"avatar_url\":\"${avatarurl["$processid"]}\"}" -F "file=@-" "${webhookurl["$processid"]}" || eval "curl --range $3-$4 '$2' $5" | curl -# "https://discordapp.com/api/v6/channels/${purechannelid["$processid"]}/messages" -H "User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:61.0) Gecko/20100101 Firefox/61.0" -H "Accept: */*" -H "Accept-Language: en-US" --compressed -H "Referer: https://discordapp.com/channels/${channelid["$processid"]}" -H "Authorization: ${auth["$processid"]}" -H "Content-Type: multipart/form-data; boundary=---------------------------32345443330436" -H "Cookie: __cfduid=d7be2f6bf6a3c09f82cd952f554ea2cb31531625199" -H "DNT: 1" -H "Connection: keep-alive" -F "payload_json={\"content\":\"$1\",\"nonce\":\"46776845$RANDOM$RANDOM$RANDOM\",\"tts\":false}" -F "filename=@-"
    fi
}

function praseconf {
    processes=0
    if [ ! -s "$configfilepath" ]
    then
        echo "Houston, we have an arsefockin' problem: CONFIG FILE IS EMPTY" >&2
        exit 4
    fi

    for templine in `cat "$configfilepath"`
    do
        temp=`echo $templine | cut -f1 -d\|`
        if [ "$temp" = "-F" ]
        then
            leftfunny=`echo $templine | cut -f2 -d\|`
            rightfunny=`echo $templine | cut -f3 -d\|`
        else
            if [ "$temp" = "-W" ]
            then
                webhookurl[$processes]=`echo $templine | cut -f2 -d\|`
                username[$processes]=`echo $templine | cut -f3 -d\|`
                avatarurl[$processes]=`echo $templine | cut -f4 -d\|`
                if [ ! "${username["$processes"]}" ]
                then
                    username[$processes]="$username_defaults $processes"
                fi
                if [ ! "${avatarurl["$processes"]}" ]
                then
                    avatarurl[$processes]="$avatarurl_defaults"
                fi
            else
                auth[$processes]=`echo $templine | cut -f1 -d\|`
                channelid[$processes]=`echo $templine | cut -f2 -d\|`
                if ! [ "${channelid["$processes"]}" != "${auth["$processes"]}" ]
                then
                    channelid[$processes]="$channelid_defeults"
                fi
                purechannelid[$processes]=`echo "${channelid["$processes"]}" | cut -d/ -f2`
                echo "bruh ${auth["$processes"]} ${purechannelid["$processes"]}"
            fi
            let processes+=1
        fi
    done
    echo -e "found \e[36m$processes\e[0m process(es)"
    # for processid in `seq 0 $processes`
    # do
        # [ "${webhookurl["$processid"]}" ] && echo "${webhookurl["$processid"]} ${username["$processid"]} ${avatarurl["$processid"]} " || echo "${auth["$processid"]}"
    # done
}

function upload_subprocess {  # upload a single file into discord, where $1 = absolute path, $2 = process id, $3 = file's fullpath
    local basepath="$1"
    local processid="$2"
    local fullpath="$3"
    if [ ! -d "$fullpath" ]
    then
        local relativepath="${fullpath#$basepath}"
        relativepath="${relativepath#/}"
        local dir="${relativepath%/*}"
        local file="${relativepath##*/}"
        if [ "$dir" = "$file" ]
        then
            dir=""
        fi
        if [[ "$file" == *,* ]]
        then
            local file2=`echo "$file" | sed 's/,/_/g'`
            local filesize=`ls -l "$basepath/$dir/$file" | awk '{ print $5 }'`
            if [ "$forcepack" ] || [ $filesize -gt $((1000000*$maxfilesize)) ]
            then
                rm "/tmp/bruh$processid" -rf
                mkdir "/tmp/bruh$processid"
                rar a -v${maxfilesize}M -ep1 -htb -m0 -ma5 -rr5 -ts -ol "/tmp/bruh$processid/${file2%.*}.rar" "$basepath/$dir/$file"
                file="${file%.*}"
                file2="${file2%.*}"
                local files
                for files in `ls "/tmp/bruh$processid" | sed 's/ /|/g'`
                do
                    files=`echo "$files" | sed 's/|/ /g'`
                    local newfiles="${files/$file2/$file}"
                    [ "$dir" ] && response=`uploadfile "$rightfunny**$dir**/$newfiles$leftfunny" "/tmp/bruh$processid/$files"` || response=`uploadfile "$rightfunny$newfiles$leftfunny" "/tmp/bruh$processid/$files"`
                    local discordlink=`echo "$response" | sed 's/,/\n/g' | grep '"url"' | sed 's/"/\n/g' | grep 'http'`
                    echo -e "\e[36m$discordlink\e[0m uploaded by process \e[36m$processid\e[0m"
                    echo "$discordlink" >> "/tmp/damned/$exportfilename.part$processid"
                    echo " dir=downloaded/$dir" >> "/tmp/damned/$exportfilename.part$processid"
                    echo " out=$newfiles" >> "/tmp/damned/$exportfilename.part$processid"
                    sleep $sleeptime
                done
                rm "/tmp/bruh$processid" -rf
            else
                mv "$basepath/$dir/$file" "$basepath/$dir/$file2"
                [ "$dir" ] && response=`uploadfile "$rightfunny**$dir**/$file$leftfunny" "$basepath/$dir/$file2"` || response=`uploadfile "$rightfunny$file$leftfunny" "$basepath/$file2"`
                discordlink=`echo "$response" | sed 's/,/\n/g' | grep '"url"' | sed 's/"/\n/g' | grep 'http'`
                echo -e "\e[36m$discordlink\e[0m uploaded by process \e[36m$processid\e[0m"
                echo "$discordlink" >> "/tmp/damned/$exportfilename.part$processid"
                echo " dir=downloaded/$dir" >> "/tmp/damned/$exportfilename.part$processid"
                echo " out=$file" >> "/tmp/damned/$exportfilename.part$processid"
                sleep $sleeptime
                mv "$basepath/$dir/$file2" "$basepath/$dir/$file"
            fi
        else
            local filesize=`ls -l "$basepath/$dir/$file" | awk '{ print $5 }'`
            if [ "$forcepack" ] || [ $filesize -gt $((1048576*$maxfilesize)) ]
            then
                rm "/tmp/bruh$processid" -rf
                mkdir "/tmp/bruh$processid"
                rar a -v${maxfilesize}M -ep1 -htb -m0 -ma5 -rr5 -ts -ol "/tmp/bruh$processid/${file%.*}.rar" "$basepath/$dir/$file"
                local files
                for files in `ls "/tmp/bruh$processid" | sed 's/ /|/g'`
                do
                        files=`echo "$files" | sed 's/|/ /g'`
                        [ "$dir" ] && response=`uploadfile "$rightfunny**$dir**/$files$leftfunny" "/tmp/bruh$processid/$files"` || response=`uploadfile "$rightfunny$files$leftfunny" "/tmp/bruh$processid/$files"`
                        local discordlink=`echo "$response" | sed 's/,/\n/g' | grep '"url"' | sed 's/"/\n/g' | grep 'http'`
                        echo -e "\e[36m$discordlink\e[0m uploaded by process \e[36m$processid\e[0m"
                        echo "$discordlink" >> "/tmp/damned/$exportfilename.part$processid"
                        echo " dir=downloaded/$dir" >> "/tmp/damned/$exportfilename.part$processid"
                        echo " out=$files" >> "/tmp/damned/$exportfilename.part$processid"
                        sleep $sleeptime
                done
                rm "/tmp/bruh$processid" -rf
            else
                [ "$dir" ] && response=`uploadfile "$rightfunny**$dir**/$file$leftfunny" "$basepath/$dir/$file"` || response=`uploadfile "$rightfunny$file$leftfunny" "$basepath/$file"`
                local discordlink=`echo "$response" | sed 's/,/\n/g' | grep '"url"' | sed 's/"/\n/g' | grep 'http'`
                echo -e "\e[36m$discordlink\e[0m uploaded by process \e[36m$processid\e[0m"
                echo "$discordlink" >> "/tmp/damned/$exportfilename.part$processid"
                echo " dir=downloaded/$dir" >> "/tmp/damned/$exportfilename.part$processid"
                echo " out=$file" >> "/tmp/damned/$exportfilename.part$processid"
                sleep $sleeptime
            fi
        fi
    fi
}

function upload_subprocess2 { # "$processid" "$start" "end" "partnum"
    local processid="$1"
    local start="$2"
    local end="$3"
    local partnum="$4"
    local response=`upload_via_url "$rightfunnypart **$partnum** of url $basedir$leftfunny" "$basedir" "$start" "$end" "$curlparameters"`
    local discordlink=`echo "$response" | sed 's/,/\n/g' | grep '"url"' | sed 's/"/\n/g' | grep 'http'`
    echo -e "\e[36m$discordlink\e[0m uploaded by process \e[36m$processid\e[0m"
    echo "$discordlink" >> "/tmp/damned/$exportfilename.part$processid"
    echo " dir=downloaded/$dir" >> "/tmp/damned/$exportfilename.part$processid"
    echo " out=$remotefilename.part$partnum" >> "/tmp/damned/$exportfilename.part$processid"
    sleep $sleeptime
}

function batgeneration() {
    echo "@echo off" > direct.download.bat
    echo "aria2c -x 128 -s 128 -j 128 -k 1M -R -c --auto-file-renaming=false -i $exportfilename" >> direct.download.bat
    if [ "$remote" ]
    then
        echo "echo pls make sure all files are finished downloadin', then continue... " >> direct.download.bat
        echo "pause > nul" >> direct.download.bat
        echo "cd downloaded" >> direct.download.bat
        combine="type"
        for fnum in `seq 1 $totalfiles`
        do
            combine="$combine $remotefilename.part$fnum"
        done
        combine="$combine > $remotefilename"
        echo "$combine" >> direct.download.bat
        echo -e "echo pls enjoy your file \e[36m$remotefilename\e[0m in \e[36mdownloaded\e[0m folder :wiebitte:" >> direct.download.bat
        echo "pause > nul" >> direct.download.bat
    fi
    echo "aria2c -x 128 -s 128 -j 128 -k 1M -R -c --auto-file-renaming=false -i %1" > drag.list.file.and.download.bat
}

function scheduler1 {
    sleeptime=0
    echo "" > "$exportfilename"
    rm "/tmp/damned" -rf
    mkdir "/tmp/damned"
    message "$welcomemessage"
    sleep $sleeptime
    
    totalfiles=0
    for fullpath in `find "$basedir"`
    do
        let totalfiles++
        processid=$[totalfiles%processes]
        upload_subprocess "$basedir" "$processid" "$fullpath"
    done
    
    message "$finishmessage"
    sleep $sleeptime
    for processid in `seq 0 $[processes-1]`
    do
        cat "/tmp/damned/$exportfilename.part$processid" >> "$exportfilename"
    done
    rm "/tmp/damned" -rf
}

function scheduler2 {
    sleeptime=1
    echo "" > "$exportfilename"
    rm "/tmp/damned" -rf
    mkdir "/tmp/damned"
    message "$welcomemessage"
    sleep $sleeptime
    
    totalfiles=0
    for fullpath in `find "$basedir"`
    do
        let totalfiles++
        processid=$[totalfiles%processes]
        echo "$fullpath" >> "/tmp/damned/list$processid"
    done
    
    for processid in `seq 0 $[processes-1]`
    do
    {
        for fullpath in `cat "/tmp/damned/list$processid"`
        do
            upload_subprocess "$basedir" "$processid" "$fullpath"
        done
    } &
    done
    wait
    
    message "$finishmessage"
    sleep $sleeptime
    for processid in `seq 0 $[processes-1]`
    do
        cat "/tmp/damned/$exportfilename.part$processid" >> "$exportfilename"
    done
    rm "/tmp/damned" -rf
}

function scheduler3 {
    sleeptime=1
    echo "" > "$exportfilename"
    rm "/tmp/damned" -rf
    mkdir "/tmp/damned"
    message "$welcomemessage"
    sleep $sleeptime
    
    filesize=`eval curl -sI $basedir $curlparameters | grep 'Content-Length' | grep -Eo '[0-9]*'`
    [ "$remotefilename" == " " ] && remotefilename="bruh.txt"
    maxfilesizeinbytes=$((maxfilesize*1000000))
    
    totalfiles=0
    for init in `seq 0 $maxfilesizeinbytes $filesize`
    do
        let totalfiles++
        processid=$[totalfiles%processes]
        end=$((init+maxfilesizeinbytes-1))
        [ $end -gt $filesize ] && end=$filesize
        echo "$init-$end-$totalfiles" >> "/tmp/damned/list$processid"
        echo "$init-$end-$totalfiles -> $processid"
    done
    
    for processid in `seq 0 $[processes-1]`
    do
    {
        for rangeinfo in `cat "/tmp/damned/list$processid"`
        do
            start=`echo $rangeinfo | cut -f1 -d\-`
            end=`echo $rangeinfo | cut -f2 -d\-`
            partnum=`echo $rangeinfo | cut -f3 -d\-`
            upload_subprocess2 "$processid" "$start" "$end" "$partnum"
        done
    } &
    done
    wait
    
    message "$finishmessage"
    sleep $sleeptime
    for processid in `seq 0 $[processes-1]`
    do
        cat "/tmp/damned/$exportfilename.part$processid" >> "$exportfilename"
    done
    # rm "/tmp/damned" -rf
}

OLD_IFS=$IFS
IFS=$'\n'

original_parameters="$0"

for parameter in "$@"
do
    original_parameters="$original_parameters '$parameter'"
done

currentdir=`pwd`
parameters=`getopt -o aAe:E:u:U:r:R:hHfFnN -a -l antics,max-filesize:,export-filename:,uber-pack:,uber-standalone:,remote:,help,force-pack,nitro -- "$@"`

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
        -a | -A | --antics)
            antics="JAJAJAJAJA"
            shift
            ;;
        --max-filesize)
            maxfilesize="$2"
            shift 2
            ;;
        -f | -F | --force-pack)
            forcepack="JAJAJAJAJA"
            shift
            ;;
        -n | -N | --nitro)
            maxfilesize=50
            shift
            ;;
        -r | -R | --remote)
            remote="JAJAJAJAJA"
            remotefilename="$2"
            shift 2
            ;;
        -e | -E | --export-filename)
            exportfilename="$2"
            shift 2
            ;;
        -u | -U | --uber-pack)
            uber="$2"
            shift 2
            ;;
        --uber-standalone)
            uber2="$2"
            shift 2
            ;;
        -h | -H | --help)
            echo "copyrekt die deutsche Orthopädiespezialist 201⑨"
            echo "discord \"file hostin'\" bot (sarcastic"
            echo "upload all files of a folder to discord, but this time with multiple accounts and multi-threads support"
            echo
            echo "Usage: "
            echo "./discordfilehosting.v5.sh [options] path/remotepath channelid configfilepath [curlparameters]"
            echo
            echo "Options: "
            echo "  --max-filesize <maxfilesize>: max file size in MB when uploadin' to discord, default value is 8MB, exceeded ones would be compressed via rar"
            echo "  -f or -F or --force-pack: pack all files with rar even if they're smaller than max file size"
            echo "  -n or -N or --nitro: equals to --max-filesize 50"
            echo "  -e or -E or --export-filename <filename>: customize filename of discord link file"
            echo "  -r or -R or --remote <filename>: download files on remote server and reupoload them into discord, only file spilt will work, and if you have no alt filename just add a \" \" to replace them"
            echo "      in this case [path] shall be remote url you can add curl parameters after [configfilepath], or not"
            echo "  -u or -U or --uber-pack <filename>: pack generated discord link file, an aria2c.exe and a batch file into an .rar (well, you don't need to type .rar again bruh) so windows users would be happy to use, and most importantly it would be uploaded to discord and have a link aswell, you can instantly copy this link elsewhere as if it's the key to million of files:funny_v2:"
            echo "      --uber-standalone <filename>: pack and upload only, in case this shitty script has an unexpected error at this paticular moment"
            echo "  -a or -A or --antics: THE ULTIMATE ANTICS, once this option is used, this script can use the auth provided to create a guild (or discord \"server\" as you call it), then create 16 or whatever number you like channels and create one webhook per channel, then export webhook urls into a config file so you can use it to upload files afterwards"
            echo "      in this case the parameters should be like: ./discordfilehosting.v3.sh --antics auth guild_name channel_name webhook_name output_config_file_path [number_of_channels]"
            echo
            echo "put auths of accounts and webhook urls into config files, one auth/webhook url per line"
            echo "webhooks must begin with a -W and then seperate webhook url, username (optional) and avatar url (also optional) with a |"
            echo "now normal accounts can post files into another channel other than default channel, just put channel id after a |"
            echo "if you wanna use custom funny emote, you need to add a line with \"-F|[left_funny]|[right_funny]\""
            echo "and btw folder path must be fockin' absolute path"
            exit
            shift
            ;;
        --)
            if [ "$antics" ]
            then
                anticsauth="$2"
                anticsguildname="$3"
                anticschannelname="$4"
                anticswebhookname="$5"
                outputconfigfilepath="$6"
                channels="$7"
                ubertantics "$anticsauth" "$anticsguildname" "$anticschannelname" "$anticswebhookname" "$outputconfigfilepath" "$channels"
                exit
            else
                basedir="$2"
                channelid_defeults="$3"
                shift 2
                break
            fi
            ;;
        *)
            echo "Internal error!"
            exit 255
            ;;
    esac
done

if [ ! "$2" ]
then
    echo "Houston, we have an arsefockin' problem: NO CONFIG FILE" >&2
    exit 3
else
    configfilepath="$2"
    [ "$3" ] && curlparameters="$3"; echo "$curlparameters"|| echo "default" 
    praseconf
    welcomemessage="discord file hostin' bot will be runnin' in here soon, pls consider mutin' this place for a minute$leftfunny$rightfunny"
    finishmessage="done$leftfunny$rightfunny"
fi

if [ ! "$exportfilename" ]
then
    time=`date +%y.%m.%d`
    exportfilename="${channelid//\//.}.$time.txt"
fi

if [ "$uber2" ]
then
    processid=0
    response=`uploadfile "link file **$exportfilename** ready to fire$leftfunny$rightfunny" "$exportfilename"`
    discordlink=`echo "$response" | sed 's/,/\n/g' | grep '"url"' | sed 's/"/\n/g' | grep 'http'`
    echo -e "your link file's link: \e[36m$discordlink\e[0m"
    batgeneration
    rar a -ep1 -htb -m5 -ma5 -rr5 -ts -ol "/tmp/$uber2.rar" "$exportfilename" "$aria2location" "direct.download.bat" "drag.list.file.and.download.bat"
    rm "direct.download.bat" "drag.list.file.and.download.bat" -f
    response=`uploadfile "über pack **$uber2.rar** ready to fire$leftfunny$rightfunny" "/tmp/$uber2.rar"`
    discordlink=`echo "$response" | sed 's/,/\n/g' | grep '"url"' | sed 's/"/\n/g' | grep 'http'`
    echo -e "your über pack's link: \e[36m$discordlink\e[0m"
    rm "/tmp/$uber2.rar" -f
    exit
fi

if [ "$remote" ]
then
    scheduler3
else
    scheduler2
fi

if [ "$uber" ]
then
    processid=0
    response=`uploadfile "link file **$exportfilename** ready to fire$leftfunny$rightfunny" "$exportfilename"`
    discordlink=`echo "$response" | sed 's/,/\n/g' | grep '"url"' | sed 's/"/\n/g' | grep 'http'`
    echo -e "your link file's link: \e[36m$discordlink\e[0m"
    batgeneration
    rar a -ep1 -htb -m5 -ma5 -rr5 -ts -ol "/tmp/$uber.rar" "$exportfilename" "$aria2location" "direct.download.bat" "drag.list.file.and.download.bat"
    rm "direct.download.bat" "drag.list.file.and.download.bat" -f
    response=`uploadfile "über pack **$uber.rar** ready to fire$leftfunny$rightfunny" "/tmp/$uber.rar"`
    discordlink=`echo "$response" | sed 's/,/\n/g' | grep '"url"' | sed 's/"/\n/g' | grep 'http'`
    echo -e "your über pack's link: \e[36m$discordlink\e[0m"
    rm "/tmp/$uber.rar" -f
fi

IFS=$OLD_IFS
