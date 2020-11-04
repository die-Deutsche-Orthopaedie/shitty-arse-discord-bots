#!/bin/bash
# copyrekt die deutsche Orthopädiespezialist 2020
# discord "file hostin'" bot (sarcastic
# upload all files of a folder to discord, but this time with multiple accounts and multi-threadin' support
# auto compress files into 8MB or 50MB volumes if file size excceeded
# auto generate discord link file so you can aria2c its sorry arse afterwards, so that you actually don't need to be limited to bullshit 8MB or 50MB file size limit

maxfilesize=8 # in MB and not in MiB bruh
let threshold=$maxfilesize*1024*1024-114514 # discord's filesize limit is as barbarian as yajuu senpai, so i used 114514 to limit filesize:wiebitte:
aria2location="/lea/is/worst/girl/aria2c.exe"
tmpdir="/tmp/wiebitte"
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
    [ "${webhookurl[0]}" ] && curl --retry 9 --retry-delay 1 -F "payload_json={\"content\":\"$1\",\"username\":\"${username[0]}\",\"avatar_url\":\"${avatarurl[0]}\"}" "${webhookurl[0]}" || curl --retry 9 --retry-delay 1 "https://discordapp.com/api/v6/channels/${purechannelid[0]}/messages" -H "User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:61.0) Gecko/20100101 Firefox/61.0" -H "Accept: */*" -H "Accept-Language: en-US" --compressed -H "Referer: https://discordapp.com/channels/${channelid[0]}" -H "Content-Type: application/json" -H "Authorization: ${auth[0]}" -H "Cookie: __cfduid=d6fa896e3cb4d9ce5a05e36e3c845ada11531595067" -H "DNT: 1" -H "Connection: keep-alive" --data "{\"content\":\"$1\",\"nonce\":\"46776845$RANDOM$RANDOM$RANDOM\",\"tts\":false}"; 
}

function uploadfile { # $1 = message, #2 = filepath, #3 = processid (probably useful)
    local discordlink=""
    while [ "$discordlink" = "" ]
    do
        local response=`[ "${webhookurl["$processid"]}" ] && curl -F "payload_json={\"content\":\"$1\",\"username\":\"${username["$processid"]}\",\"avatar_url\":\"${avatarurl["$processid"]}\"}" -F "filename=@$2" "${webhookurl["$processid"]}" || curl "https://discordapp.com/api/v6/channels/${purechannelid["$processid"]}/messages" -H "User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:61.0) Gecko/20100101 Firefox/61.0" -H "Accept: */*" -H "Accept-Language: en-US" --compressed -H "Referer: https://discordapp.com/channels/${channelid["$processid"]}" -H "Authorization: ${auth["$processid"]}" -H "Content-Type: multipart/form-data; boundary=---------------------------32345443330436" -H "Cookie: __cfduid=d7be2f6bf6a3c09f82cd952f554ea2cb31531625199" -H "DNT: 1" -H "Connection: keep-alive" -F "payload_json={\"content\":\"$1\",\"nonce\":\"46776845$RANDOM$RANDOM$RANDOM\",\"tts\":false}" -F "filename=@$2"`
        discordlink=`echo "$response" | sed 's/,/\n/g' | grep '"url"' | sed 's/"/\n/g' | grep 'http'`
        if [ "$checksums" ]
        then
            if [ "$discordlink" ]
            then
                # wget "$discordlink" -O "$tmpdir/${discordlink##*/}.checksumtemp.$3"
                aria2c -x 8 -s 8 -k 1M -R -c --auto-file-renaming=false "$discordlink" --dir="$tmpdir" --out="${discordlink##*/}.checksumtemp.$3" 1>&2
                local sha5122=`sha512sum "$tmpdir/${discordlink##*/}.checksumtemp.$3" | cut -f1 -d" "`
            else
                local sha5122="999999"
            fi
            local sha5121=`sha512sum "$2" | cut -f1 -d" "`
            
            if [ "$sha5121" == "$sha5122" ]
            then
                # echo -e "\e[36mchecksum for \e[32m$2\e[36 passed[0m" 1>&2
                echo -e "\e[36mchecksum for \e[32m$2\e[36m passed\e[0m" 1>&2
            else
                echo -e "\e[31mchecksum for \e[32m$2\e[31m failed\e[0m, will reupload" 1>&2
                discordlink=""
            fi
            rm "$tmpdir/${discordlink##*/}.checksumtemp.$3" -f
        fi
        sleep $sleeptime
    done
    echo "$discordlink"
}

function upload_via_url { # $1 = message, #2 = url, #3 = start locaion, #4 = end location, #5 = extra parameters (if any)
    if [ ! "$5" ]
    then
        [ "${webhookurl["$processid"]}" ] && curl --retry 9 --retry-delay 1 --range "$3-$4" "$2" | curl -# -F "payload_json={\"content\":\"$1\",\"username\":\"${username["$processid"]}\",\"avatar_url\":\"${avatarurl["$processid"]}\"}" -F "file=@-" "${webhookurl["$processid"]}" || curl --retry 9 --retry-delay 1 --range "$3"-"$4" "$2" | curl -# "https://discordapp.com/api/v6/channels/${purechannelid["$processid"]}/messages" -H "User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:61.0) Gecko/20100101 Firefox/61.0" -H "Accept: */*" -H "Accept-Language: en-US" --compressed -H "Referer: https://discordapp.com/channels/${channelid["$processid"]}" -H "Authorization: ${auth["$processid"]}" -H "Content-Type: multipart/form-data; boundary=---------------------------32345443330436" -H "Cookie: __cfduid=d7be2f6bf6a3c09f82cd952f554ea2cb31531625199" -H "DNT: 1" -H "Connection: keep-alive" -F "payload_json={\"content\":\"$1\",\"nonce\":\"46776845$RANDOM$RANDOM$RANDOM\",\"tts\":false}" -F "filename=@-"
    else
        [ "${webhookurl["$processid"]}" ] && eval "curl --retry 9 --retry-delay 1 --range '$3-$4' '$2' $5" | curl -# -F "payload_json={\"content\":\"$1\",\"username\":\"${username["$processid"]}\",\"avatar_url\":\"${avatarurl["$processid"]}\"}" -F "file=@-" "${webhookurl["$processid"]}" || eval "curl --retry 9 --retry-delay 1 --range $3-$4 '$2' $5" | curl -# "https://discordapp.com/api/v6/channels/${purechannelid["$processid"]}/messages" -H "User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:61.0) Gecko/20100101 Firefox/61.0" -H "Accept: */*" -H "Accept-Language: en-US" --compressed -H "Referer: https://discordapp.com/channels/${channelid["$processid"]}" -H "Authorization: ${auth["$processid"]}" -H "Content-Type: multipart/form-data; boundary=---------------------------32345443330436" -H "Cookie: __cfduid=d7be2f6bf6a3c09f82cd952f554ea2cb31531625199" -H "DNT: 1" -H "Connection: keep-alive" -F "payload_json={\"content\":\"$1\",\"nonce\":\"46776845$RANDOM$RANDOM$RANDOM\",\"tts\":false}" -F "filename=@-"
    fi
}

function upload_via_rclone { # $1 = message, #2 = basedir, #3 = filename, #4 = start location, #5 = counts
    [ "${webhookurl["$processid"]}" ] && rclone --low-level-retries 9 cat --offset "$4" --count "$5" "$2/$3" | curl -# -F "payload_json={\"content\":\"$1\",\"username\":\"${username["$processid"]}\",\"avatar_url\":\"${avatarurl["$processid"]}\"}" -F "file=@-" "${webhookurl["$processid"]}" || rclone --low-level-retries 9 cat "$2/$3" | curl -# "https://discordapp.com/api/v6/channels/${purechannelid["$processid"]}/messages" -H "User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:61.0) Gecko/20100101 Firefox/61.0" -H "Accept: */*" -H "Accept-Language: en-US" --compressed -H "Referer: https://discordapp.com/channels/${channelid["$processid"]}" -H "Authorization: ${auth["$processid"]}" -H "Content-Type: multipart/form-data; boundary=---------------------------32345443330436" -H "Cookie: __cfduid=d7be2f6bf6a3c09f82cd952f554ea2cb31531625199" -H "DNT: 1" -H "Connection: keep-alive" -F "payload_json={\"content\":\"$1\",\"nonce\":\"46776845$RANDOM$RANDOM$RANDOM\",\"tts\":false}" -F "filename=@-"
    discordlink=`echo "$response" | sed 's/,/\n/g' | grep '"url"' | sed 's/"/\n/g' | grep 'http'`
    sleep $sleeptime
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
    if [ "$threadlimit" ]
    then
        echo -e "but you set a thread limit of \e[36m$threadlimit\e[0m"
        [ "$processes" -gt "$threadlimit" ] && processes="$threadlimit"
        echo -e "so... the actual thread limit was set to \e[36m$processes\e[0m"
    fi
    # for processid in `seq 0 $processes`
    # do
        # [ "${webhookurl["$processid"]}" ] && echo "${webhookurl["$processid"]} ${username["$processid"]} ${avatarurl["$processid"]} " || echo "${auth["$processid"]}"
    # done
}

function upload_subprocess {  # upload a single file into discord, where $1 = absolute path, $2 = process id, $3 = file's fullpath
    local basepath="$1"
    local processid="$2"
    local fullpath="$3"
    local processedfile=0
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
            if [ "$forcepack" ] || [ "$filesize" -gt "$threshold" ]
            then
                rm "$tmpdir$processid" -rf
                mkdir "$tmpdir$processid"
                # rar a -v${maxfilesize}M -ep1 -htb -m0 -ma5 -rr5 -ts -ol "$tmpdir$processid/${file2%.*}.rar" "$basepath/$dir/$file"
                rar a -v${threshold}B -ep1 -htb -m0 -ma5 -rr5 -ts -ol "$tmpdir$processid/${file2%.*}.rar" "$basepath/$dir/$file"
                file="${file%.*}"
                file2="${file2%.*}"
                local files
                for files in `ls "$tmpdir$processid" | sed 's/ /|/g'`
                do
                    files=`echo "$files" | sed 's/|/ /g'`
                    local newfiles="${files/$file2/$file}"
                    local discordlink=""
                    [ "$dir" ] && discordlink=`uploadfile "$rightfunny**$dir**/$newfiles$leftfunny" "$tmpdir$processid/$files" "$processid"` || discordlink=`uploadfile "$rightfunny$newfiles$leftfunny" "$tmpdir$processid/$files" "$processid"`
                    echo -e "\e[36m$discordlink\e[0m uploaded by process \e[32m$processid\e[0m"
                    echo "$discordlink" >> "$tmpdir/$exportfilename.part$processid"
                    [ "$dir" ] && echo " dir=downloaded/$dir" >> "$tmpdir/$exportfilename.part$processid" || echo " dir=downloaded" >> "$tmpdir/$exportfilename.part$processid"
                    echo " out=$newfiles" >> "$tmpdir/$exportfilename.part$processid"
                done
                rm "$tmpdir$processid" -rf
            else
                mv "$basepath/$dir/$file" "$basepath/$dir/$file2"
                local discordlink=""
                [ "$dir" ] && discordlink=`uploadfile "$rightfunny**$dir**/$file$leftfunny" "$basepath/$dir/$file2" "$processid"` || discordlink=`uploadfile "$rightfunny$file$leftfunny" "$basepath/$file2" "$processid"`
                let processedfile++
                echo -e "\e[36m$discordlink\e[0m uploaded by process \e[32m$processid\e[0m, file \e[36m$processedfile\e[0m/\e[32m${filesinprocess["$processid"]}\e[0m"
                echo "$discordlink" >> "$tmpdir/$exportfilename.part$processid"
                [ "$dir" ] && echo " dir=downloaded/$dir" >> "$tmpdir/$exportfilename.part$processid" || echo " dir=downloaded" >> "$tmpdir/$exportfilename.part$processid"
                echo " out=$file" >> "$tmpdir/$exportfilename.part$processid"
                mv "$basepath/$dir/$file2" "$basepath/$dir/$file"
            fi
        else
            local filesize=`ls -l "$basepath/$dir/$file" | awk '{ print $5 }'`
            if [ "$forcepack" ] || [ "$filesize" -gt "$threshold" ]
            then
                rm "$tmpdir$processid" -rf
                mkdir "$tmpdir$processid"
                # rar a -v${maxfilesize}M -ep1 -htb -m0 -ma5 -rr5 -ts -ol "$tmpdir$processid/${file%.*}.rar" "$basepath/$dir/$file"
                rar a -v${threshold}B -ep1 -htb -m0 -ma5 -rr5 -ts -ol "$tmpdir$processid/${file%.*}.rar" "$basepath/$dir/$file"
                local files
                for files in `ls "$tmpdir$processid" | sed 's/ /|/g'`
                do
                        files=`echo "$files" | sed 's/|/ /g'`
                        local discordlink=""
                        [ "$dir" ] && discordlink=`uploadfile "$rightfunny**$dir**/$files$leftfunny" "$tmpdir$processid/$files" "$processid"` || discordlink=`uploadfile "$rightfunny$files$leftfunny" "$tmpdir$processid/$files" "$processid"`
                        echo -e "\e[36m$discordlink\e[0m uploaded by process \e[32m$processid\e[0m"
                        echo "$discordlink" >> "$tmpdir/$exportfilename.part$processid"
                        [ "$dir" ] && echo " dir=downloaded/$dir" >> "$tmpdir/$exportfilename.part$processid" || echo " dir=downloaded" >> "$tmpdir/$exportfilename.part$processid"
                        echo " out=$files" >> "$tmpdir/$exportfilename.part$processid"
                done
                rm "$tmpdir$processid" -rf
            else
                discordlink=""
                [ "$dir" ] && discordlink=`uploadfile "$rightfunny**$dir**/$file$leftfunny" "$basepath/$dir/$file" "$processid"` || discordlink=`uploadfile "$rightfunny$file$leftfunny" "$basepath/$file" "$processid"`
                let processedfile++
                echo -e "\e[36m$discordlink\e[0m uploaded by process \e[32m$processid\e[0m, file \e[36m$processedfile\e[0m/\e[32m${filesinprocess["$processid"]}\e[0m"
                echo "$discordlink" >> "$tmpdir/$exportfilename.part$processid"
                [ "$dir" ] && echo " dir=downloaded/$dir" >> "$tmpdir/$exportfilename.part$processid" || echo " dir=downloaded" >> "$tmpdir/$exportfilename.part$processid"
                echo " out=$file" >> "$tmpdir/$exportfilename.part$processid"
            fi
        fi
    fi
}

function upload_subprocess2 { # for remote url
    local processid="$1"
    local start="$2"
    local end="$3"
    local partnum="$4"
    local response=`upload_via_url "$rightfunny**part $partnum** of url $basedir$leftfunny" "$basedir" "$start" "$end" "$curlparameters"`
    local discordlink=`echo "$response" | sed 's/,/\n/g' | grep '"url"' | sed 's/"/\n/g' | grep 'http'`
    echo -e "\e[36m$discordlink\e[0m uploaded by process \e[32m$processid\e[0m"
    echo "$discordlink" >> "$tmpdir/$exportfilename.part$processid"
    echo " dir=downloaded" >> "$tmpdir/$exportfilename.part$processid"
    echo " out=$remotefilename.part$partnum" >> "$tmpdir/$exportfilename.part$processid"
    sleep $sleeptime
}

function upload_subprocess3 { # for rclone
    local processid="$1"
    local start="$2"
    local end="$3"
    local counts="$((end - start + 1))"
    local partnum="$4"
    local filename="$5"
    [ "oneindexurl" ] && local fileurl="$6"
    [ "oneindexurl" ] && local response=`upload_via_url "$rightfunny**part $partnum** of rclone location $filename$leftfunny" "$fileurl" "$start" "$end"` || local response=`upload_via_rclone "$rightfunny**part $partnum** of rclone location $filename$leftfunny" "$basedir" "$filename" "$start" "$counts"`
    # [ "oneindexurl" ] && echo "upload_via_url \"$rightfunny**part $partnum** of rclone location $filename$leftfunny\" \"$fileurl\" \"$start\" \"$end\"" || echo "upload_via_rclone \"$rightfunny**part $partnum** of rclone location $filename$leftfunny\" \"$basedir\" \"$filename\" \"$start\" \"$counts\""
    local discordlink=`echo "$response" | sed 's/,/\n/g' | grep '"url"' | sed 's/"/\n/g' | grep 'http'`
    echo -e "\e[36m$discordlink\e[0m uploaded by process \e[32m$processid\e[0m"
    echo "$discordlink" >> "$tmpdir/$exportfilename.part$processid"
    if [ `echo "$filename" | grep -c "/"` -eq 0 ]
    then
        echo " dir=downloaded" >> "$tmpdir/$exportfilename.part$processid"
        echo " out=$filename.part$partnum" >> "$tmpdir/$exportfilename.part$processid"
    else
        local dir="${filename%/*}"
        local filename2="${filename##*/}"
        echo " dir=downloaded/$dir" >> "$tmpdir/$exportfilename.part$processid"
        echo " out=$filename2.part$partnum" >> "$tmpdir/$exportfilename.part$processid"
    fi
    sleep $sleeptime
}

function batgeneration() {
    batfilename="${exportfilename%.*}.bat"
    echo "@echo off" > "$batfilename"
    echo "aria2c -x 128 -s 128 -j 32 -k 1M -R -c --auto-file-renaming=false -i $exportfilename" >> "$batfilename"
    if [ "$remote" ]
    then
        echo "echo pls make sure all files are finished downloadin', then continue... " >> "$batfilename"
        echo "pause > nul" >> "$batfilename"
        echo "cd downloaded" >> "$batfilename"
        combine="type"
        for fnum in `seq 1 $totalfiles`
        do
            combine="$combine $remotefilename.part$fnum"
        done
        combine="$combine > $remotefilename"
        echo "$combine" >> "$batfilename"
        echo -e "echo pls enjoy your file \e[36m$remotefilename\e[0m in \e[36mdownloaded\e[0m folder :wiebitte:" >> "$batfilename"
        echo "pause > nul" >> "$batfilename"
    elif [ "$rclone" ]
    then
        echo "echo pls make sure all files are finished downloadin', then continue... " >> "$batfilename"
        echo "pause > nul" >> "$batfilename"
        echo "cd downloaded" >> "$batfilename"
        cat $tmpdir/temp.bat >> "$batfilename"
        echo -e "echo pls enjoy your files in \e[36mdownloaded\e[0m folder :wiebitte:" >> "$batfilename"
        echo "pause > nul" >> "$batfilename"
    fi
}

function scheduler1 { # single thread with accounts in turn, obsolete
    sleeptime=0
    echo "" > "$exportfilename"
    rm "$tmpdir" -rf
    mkdir "$tmpdir"
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
        cat "$tmpdir/$exportfilename.part$processid" >> "$exportfilename"
    done
    batgeneration
    rm "$tmpdir" -rf
}

function scheduler2 { # muptiple threads for local files
    sleeptime=1
    echo "" > "$exportfilename"
    rm "$tmpdir" -rf
    mkdir "$tmpdir"
    message "$welcomemessage"
    sleep $sleeptime
    
    totalfiles=0
    for processid in `seq 0 $[processes-1]`
    do
        filesinprocess[$processid]=0
    done
    
    for fullpath in `find "$basedir"`
    do
        let totalfiles++
        processid=$[totalfiles%processes]
        echo "$fullpath" >> "$tmpdir/list$processid"
        let filesinprocess[$processid]++
    done
    
    for processid in `seq 0 $[processes-1]`
    do
    {
        for fullpath in `cat "$tmpdir/list$processid"`
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
        cat "$tmpdir/$exportfilename.part$processid" >> "$exportfilename"
    done
    batgeneration
    rm "$tmpdir" -rf
}

function scheduler3 { # muptiple threads for remote files
    sleeptime=1
    echo "" > "$exportfilename"
    rm "$tmpdir" -rf
    mkdir "$tmpdir"
    message "$welcomemessage"
    sleep $sleeptime
    
    filesize=`eval curl -sI $basedir $curlparameters | grep 'Content-Length' | grep -Eo '[0-9]*'`
    [ "$remotefilename" == " " ] && remotefilename="bruh.txt"
    # maxfilesizeinbytes=$((maxfilesize*1000000))
    
    totalfiles=0
    for init in `seq 0 $threshold $filesize`
    do
        let totalfiles++
        processid=$[totalfiles%processes]
        end=$((init+threshold-1))
        [ $end -gt $((filesize-1)) ] && end=$((filesize-1))
        echo "$init|$end|$totalfiles" >> "$tmpdir/list$processid"
        # echo "$init|$end|$totalfiles -> $processid"
    done
    
    for processid in `seq 0 $[processes-1]`
    do
    {
        for rangeinfo in `cat "$tmpdir/list$processid"`
        do
            start=`echo $rangeinfo | cut -f1 -d\|`
            end=`echo $rangeinfo | cut -f2 -d\|`
            partnum=`echo $rangeinfo | cut -f3 -d\|`
            upload_subprocess2 "$processid" "$start" "$end" "$partnum"
        done
    } &
    done
    wait
    
    message "$finishmessage"
    sleep $sleeptime
    for processid in `seq 0 $[processes-1]`
    do
        cat "$tmpdir/$exportfilename.part$processid" >> "$exportfilename"
    done
    batgeneration
    rm "$tmpdir" -rf
}

function scheduler4 { # muptiple threads for rclone files
    sleeptime=1
    echo "" > "$exportfilename"
    rm "$tmpdir" -rf
    mkdir "$tmpdir"
    message "$welcomemessage"
    sleep $sleeptime
    
    # maxfilesizeinbytes=$((maxfilesize*1000000))
    totalfiles=0
    echo "" > $tmpdir/temp.bat
    # for fileinfo in `rclone ls $basedir`; do filesize=`echo $fileinfo | grep -Eo "^ *[0-9]* " | grep -Eo "[0-9]*"`; filename=${fileinfo//`echo $fileinfo | grep -Eo "^ *[0-9]* "`/}; echo -e "\e[36m$filename\e[0m has \e[36m$filesize\e[0m byte(s)"; done
    for fileinfo in `rclone ls $basedir`
    do
        filesize=`echo $fileinfo | grep -Eo "^ *[0-9]* " | grep -Eo "[0-9]*"`
        filename=${fileinfo//`echo $fileinfo | grep -Eo "^ *[0-9]* "`/}
        [ "oneindexurl" ] && fileurl=`curl -sI "$oneindexurl/$filename" | grep "Location: " | sed 's/Location: //g' | sed 's/\r//g' | sed 's/\n//g' | sed 's/\t//g'`
        fileparts=0
        for init in `seq 0 $threshold $filesize`
        do
            let totalfiles++
            let fileparts++
            processid=$[totalfiles%processes]
            end=$((init+threshold-1))
            [ $end -gt $((filesize-1)) ] && end=$((filesize-1))
            [ "oneindexurl" ] && echo "$init|$end|$fileparts|$filename|$fileurl" >> "$tmpdir/list$processid" || echo "$init|$end|$fileparts|$filename" >> "$tmpdir/list$processid"
            # echo "$init|$end|$fileparts|$filename -> $processid"
        done
        dosfilename=${filename//\//\\}
        combine="type"
        for fnum in `seq 1 $fileparts`
        do
            combine="$combine $dosfilename.part$fnum"
        done
        combine="$combine > $dosfilename"
        echo "$combine" >> $tmpdir/temp.bat
    done
    
    for processid in `seq 0 $[processes-1]`
    do
    {
        for rangeinfo in `cat "$tmpdir/list$processid"`
        do
            start=`echo $rangeinfo | cut -f1 -d\|`
            end=`echo $rangeinfo | cut -f2 -d\|`
            partnum=`echo $rangeinfo | cut -f3 -d\|`
            filename=`echo $rangeinfo | cut -f4 -d\|`
            [ "oneindexurl" ] && fileurl=`echo $rangeinfo | cut -f5- -d\|`
            [ "oneindexurl" ] && upload_subprocess3 "$processid" "$start" "$end" "$partnum" "$filename" "$fileurl" || upload_subprocess3 "$processid" "$start" "$end" "$partnum" "$filename"
        done
    } &
    done
    wait
    
    message "$finishmessage"
    sleep $sleeptime
    for processid in `seq 0 $[processes-1]`
    do
        cat "$tmpdir/$exportfilename.part$processid" >> "$exportfilename"
    done
    batgeneration
    rm "$tmpdir" -rf
}

OLD_IFS=$IFS
IFS=$'\n'
part="part"
starttime=`date +%s%N`

original_parameters="$0"

for parameter in "$@"
do
    original_parameters="$original_parameters '$parameter'"
done

currentdir=`pwd`
parameters=`getopt -o aAe:E:u:U:r:R:hHfFnNcC -a -l antics,max-filesize:,threadlimit:,export-filename:,uber-pack:,uber-standalone:,norar,remote:,rclone,help,force-pack,nitro,oneindex-optimization:,checksums -- "$@"`

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
    # echo $@
    case "$1" in
        -a | -A | --antics)
            antics="JAJAJAJAJA"
            shift
            ;;
        --max-filesize)
            maxfilesize="$2"
            let threshold=$maxfilesize*1024*1024-114514 # discord's filesize limit is as barbarian as yajuu senpai, so i used 114514 to limit filesize:wiebitte:
            shift 2
            ;;
        --threadlimit)
            threadlimit="$2"
            shift 2
            ;;
        -f | -F | --force-pack)
            forcepack="JAJAJAJAJA"
            shift
            ;;
        -n | -N | --nitro)
            maxfilesize=50
            let threshold=$maxfilesize*1024*1024-114514 # discord's filesize limit is as barbarian as yajuu senpai, so i used 114514 to limit filesize:wiebitte:
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
        --norar)
            norar="JAJAJAJAJA"
            shift
            ;;
        --rclone)
            rclone="JAJAJAJAJA"
            shift
            ;;
        --oneindex-optimization)
            oneindexurl="$2"
            shift 2
            ;;
        -c | -C | --checksums)
            checksums="JAJAJAJAJA"
            shift
            ;;
        -h | -H | --help)
            echo -e "copyrekt \e[36mdie deutsche Orthopädiespezialist\e[0m 2020"
            echo -e "discord \"\e[36mfile hostin'\e[0m\" bot (sarcastic"
            echo "upload all files of a folder to discord, but this time with multiple accounts and multi-threads support"
            echo
            echo "Usage: "
            echo -e "./\e[36mdiscordfilehosting.v9.sh\e[0m \e[32m[options] path/remotepath channelid configfilepath [curlparameters]\e[0m"
            echo
            echo "\e[36mOptions\e[0m: "
            echo -e "  \e[36m--max-filesize\e[0m \e[32m<maxfilesize>\e[0m: max file size in MB when uploadin' to discord, default value is 8MB, exceeded ones would be compressed via rar"
            echo -e "  \e[36m--threadlimit\e[0m \e[32m<threads>\e[0m: you can appoint thread limits in some cases, like your shitty arse vps is too shitty to handle too many threads that config file gives"
            echo -e "  \e[36m-f\e[0m or \e[36m-F\e[0m or \e[36m--force-pack\e[0m: pack all files with rar even if they're smaller than max file size"
            echo -e "  \e[36m-n\e[0m or \e[36m-N\e[0m or \e[36m--nitro\e[0m: equals to \e[36m--max-filesize\e[0m \e[32m50\e[0m"
            echo -e "  \e[36m-e\e[0m or \e[36m-E\e[0m or \e[36m--export-filename\e[0m \e[32m<filename>\e[0m: customize filename of discord link file"
            echo -e "  \e[36m-r\e[0m or \e[36m-R\e[0m or \e[36m--remote\e[0m \e[32m<filename>\e[0m: download files on remote server and reupoload them into discord, only file spilt will work, and if you have no alt filename just add a \" \" to replace them"
            echo -e "  \e[36m-c\e[0m or \e[36m-C\e[0m or \e[36m--checksums\e[0m: redownload and do checksums after uploadin' files to discord to make sure the file is uploaded as is, recommended for unstable connections or large data uploads"
            echo -e "      in this case \e[32m[path]\e[0m shall be remote url you can add curl parameters after \e[32m[configfilepath]\e[0m, or not"
            echo -e "      \e[36m--rclone\e[0m: process rclone's remotes usin' rclone cat, pls make the path of remote in \e[32m[path]\e[0m"
            echo -e "          \e[36m--oneindex-optimization\e[0m \e[32m<oneindex url>\e[0m: use oneindex to parse rclone's onedrive links, so you don't actually need to start 24 rclones:wiebitte:"
            echo -e "  \e[36m-u\e[0m or \e[36m-U\e[0m or \e[36m--uber-pack\e[0m \e[32m<filename>\e[0m: pack generated discord link file, an aria2c.exe and a batch file into an .rar (well, you don't need to type .rar again bruh) so windows users would be happy to use, and more importantly it would be uploaded to discord and have a link aswell, you can instantly copy this link elsewhere as if it's the key to million of files:wiebitte:"
            echo -e "      \e[36m--uber-standalone\e[0m \e[32m<filename>\e[0m: pack and upload only"
            echo -e "      \e[36m--norar\e[0m: upload link file only"
            echo -e "  \e[36m-a\e[0m or \e[36m-A\e[0m or \e[36m--antics\e[0m: THE ULTIMATE ANTICS, once this option is used, this script can use the auth provided to create a guild (or discord \"server\" as you call it), then create 16 or whatever number you like channels and create one webhook per channel, then export webhook urls into a config file so you can use it to upload files afterwards"
            echo -e "      in this case the parameters should be like: "
            echo -e "      ./\e[36mdiscordfilehosting.v9.sh\e[0m \e[32m--antics auth guild_name channel_name webhook_name output_config_file_path [number_of_channels]\e[0m"
            echo
            echo -e "put auths of accounts and webhook urls into config files, one auth/webhook url per line"
            echo -e "webhooks must begin with a -W and then seperate webhook url, username (optional) and avatar url (also optional) with a |"
            echo -e "now normal accounts can post files into another channel other than default channel, just put channel id after a |"
            echo -e "if you wanna use custom funny emote, you need to add a line with \"-F|[left_funny]|[right_funny]\""
            echo -e "and btw folder path must be fockin' absolute path"
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
    sleeptime=1
    exportfilesize=`ls -l "$exportfilename" | awk '{ print $5 }'`
    if [ "$exportfilesize" -gt "$threshold" ] 
    then
        rar a -ep1 -htb -m5 -ma5 -rr5 -ts -ol "${exportfilename%.*}.rar" "$exportfilename"
        discordlink=`uploadfile "link file **${exportfilename%.*}.rar** ready to fire$leftfunny$rightfunny" "$uber.rar" "$processid"`
        rm "${exportfilename%.*}.rar" -f
    else
        discordlink=`uploadfile "link file **$exportfilename** ready to fire$leftfunny$rightfunny" "$exportfilename" "$processid"`
    fi
    echo -e "your link file's link: \e[36m$discordlink\e[0m"
    if [ ! "$norar" ]
    then
        # cp -p "${exportfilename%.*}.bat" "direct.download.bat"
        # unix2dos "direct.download.bat"
        echo "aria2c -x 128 -s 128 -j 32 -k 1M -R -c --auto-file-renaming=false -i \"$exportfilename\"" > direct.download.bat
        echo "aria2c -x 128 -s 128 -j 32 -k 1M -R -c --auto-file-renaming=false -i %1" > drag.list.file.and.download.bat
        rar a -ep1 -htb -m5 -ma5 -rr5 -ts -ol "$uber2.rar" "$exportfilename" "$aria2location" "direct.download.bat" "drag.list.file.and.download.bat"
        rm "direct.download.bat" "drag.list.file.and.download.bat" -f
        discordlink=`uploadfile "über pack **$uber2.rar** ready to fire$leftfunny$rightfunny" "$uber2.rar" "$processid"`
        echo -e "your über pack's link: \e[36m$discordlink\e[0m"
        rm "$uber2.rar" -f
    fi
    exit
fi

if [ "$remote" ]
then
    scheduler3
elif [ "$rclone" ]
then
    scheduler4
else
    scheduler2
fi

if [ "$uber" ]
then
    processid=0
    sleeptime=1
    exportfilesize=`ls -l "$exportfilename" | awk '{ print $5 }'`
    if [ "$exportfilesize" -gt "$threshold" ] 
    then
        rar a -ep1 -htb -m5 -ma5 -rr5 -ts -ol "${exportfilename%.*}.rar" "$exportfilename"
        discordlink=`uploadfile "link file **${exportfilename%.*}.rar** ready to fire$leftfunny$rightfunny" "$uber.rar" "$processid"`
        rm "${exportfilename%.*}.rar" -f
    else
        discordlink=`uploadfile "link file **$exportfilename** ready to fire$leftfunny$rightfunny" "$exportfilename" "$processid"`
    fi
    echo -e "your link file's link: \e[36m$discordlink\e[0m"
    if [ ! "$norar" ]
    then
        cp -p "${exportfilename%.*}.bat" "direct.download.bat"
        unix2dos "direct.download.bat"
        echo "aria2c -x 128 -s 128 -j 32 -k 1M -R -c --auto-file-renaming=false -i %1" > drag.list.file.and.download.bat
        rar a -ep1 -htb -m5 -ma5 -rr5 -ts -ol "$uber.rar" "$exportfilename" "$aria2location" "direct.download.bat" "drag.list.file.and.download.bat"
        rm "direct.download.bat" "drag.list.file.and.download.bat" -f
        discordlink=`uploadfile "über pack **$uber.rar** ready to fire$leftfunny$rightfunny" "$uber.rar" "$processid"`
        echo -e "your über pack's link: \e[36m$discordlink\e[0m"
        rm "$uber.rar" -f
    fi
fi

finaltime=`date +%s%N`
# usedtime=`echo "scale=3;($finaltime - $starttime)/1000000000" | bc`
usedtime=`awk -v x=$finaltime -v y=$starttime 'BEGIN{printf "%.3f",(x-y)/1000000000}'`
echo -e "Thanks for usin' this shitty arse bot, this bot has finished uploadin' files into discord in \033[36m$usedtime\033[0m second(s), see u next time"
    
IFS=$OLD_IFS
