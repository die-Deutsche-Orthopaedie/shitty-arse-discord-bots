#!/bin/bash
# copyrekt die deutsche Orthopädiespezialist 201⑨
# discord "file hostin'" bot (sarcastic
# upload all files of a folder to discord, but this time with multiple accounts and multi-threads support
# auto compress files into 8MB or 50MB volumes if file size excceeded
# auto generate discord link file so you can aria2c its sorry arse afterwards, so that you actually don't need to be limited to bullshit 8MB or 50MB file size limit

maxfilesize=8 # in MB and not in MiB bruh
aria2location="/lea/is/worst/girl/aria2c.exe"

rightfunny=""
leftfunny=""
welcomemessage="discord file hostin' bot will be runnin' in here soon, pls consider mutin' this place for a minute$leftfunny$rightfunny"
finishmessage="done$leftfunny$rightfunny"

username_defaults="Hermann FEGELEIN! FEGELEIN!! FEGELEIN!!! "
avatarurl_defaults="https://discordapp.com/assets/322c936a8c8be1b803cd94861bdfa868.png"

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
            auth[$processes]="$temp"
        fi
        let processes+=1
    done
    echo -e "found \e[36m$processes\e[0m process(es)"
    # for processid in `seq 0 $processes`
    # do
        # [ "${webhookurl["$processid"]}" ] && echo "${webhookurl["$processid"]} ${username["$processid"]} ${avatarurl["$processid"]} " || echo "${auth["$processid"]}"
    # done
}

function upload_subprocess {  # upload a single file into discord, where $1 = absolute path, $2 = channel id, $3 = process id, $4 = file's fullpath
    local basepath="$1"
    local channelid="$2"
    local processid="$3"
    local fullpath="$4"
    local purechannelid=`echo "$channelid" | cut -d/ -f2`
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
                    local response=`[ "${webhookurl["$processid"]}" ] && curl -F "payload_json={\"content\":\"$rightfunny**$dir**/$newfiles$leftfunny\",\"username\":\"${username["$processid"]}\",\"avatar_url\":\"${avatarurl["$processid"]}\"}" -F "filename=@/tmp/bruh$processid/$files" "${webhookurl["$processid"]}" || curl "https://discordapp.com/api/v6/channels/$purechannelid/messages" -H "User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:61.0) Gecko/20100101 Firefox/61.0" -H "Accept: */*" -H "Accept-Language: en-US" --compressed -H "Referer: https://discordapp.com/channels/$channelid" -H "Authorization: ${auth["$processid"]}" -H "Content-Type: multipart/form-data; boundary=---------------------------32345443330436" -H "Cookie: __cfduid=d7be2f6bf6a3c09f82cd952f554ea2cb31531625199" -H "DNT: 1" -H "Connection: keep-alive" -F "payload_json={\"content\":\"$rightfunny**$dir**/$newfiles$leftfunny\",\"nonce\":\"46776845$RANDOM$RANDOM$RANDOM\",\"tts\":false}" -F "filename=@/tmp/bruh$processid/$files"`
                    local discordlink=`echo "$response" | sed 's/,/\n/g' | grep '"attachments"' | grep '"url"' | sed 's/,/\n/g' | grep '"attachments"' | sed 's/"/\n/g' | grep 'http'`
                    echo -e "\e[36m$discordlink\e[0m uploaded by process \e[36m$processid\e[0m"
                    echo "$discordlink" >> "/tmp/damned/$exportfilename.part$processid"
                    echo " dir=downloaded/$dir" >> "/tmp/damned/$exportfilename.part$processid"
                    echo " out=$newfiles" >> "/tmp/damned/$exportfilename.part$processid"
                    sleep $sleeptime
                done
                rm "/tmp/bruh$processid" -rf
            else
                mv "$basepath/$dir/$file" "$basepath/$dir/$file2"
                response=`[ "${webhookurl["$processid"]}" ] && curl -F "payload_json={\"content\":\"$rightfunny**$dir**/$file$leftfunny\",\"username\":\"${username["$processid"]}\",\"avatar_url\":\"${avatarurl["$processid"]}\"}" -F "filename=@$basepath/$dir/$file2" "${webhookurl["$processid"]}" || curl "https://discordapp.com/api/v6/channels/$purechannelid/messages" -H "User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:61.0) Gecko/20100101 Firefox/61.0" -H "Accept: */*" -H "Accept-Language: en-US" --compressed -H "Referer: https://discordapp.com/channels/$channelid" -H "Authorization: ${auth["$processid"]}" -H "Content-Type: multipart/form-data; boundary=---------------------------32345443330436" -H "Cookie: __cfduid=d7be2f6bf6a3c09f82cd952f554ea2cb31531625199" -H "DNT: 1" -H "Connection: keep-alive" -F "payload_json={\"content\":\"$rightfunny**$dir**/$file$leftfunny\",\"nonce\":\"46776845$RANDOM$RANDOM$RANDOM\",\"tts\":false}" -F "filename=@$basepath/$dir/$file2"`
                discordlink=`echo "$response" | sed 's/,/\n/g' | grep '"attachments"' | grep '"url"' | sed 's/,/\n/g' | grep '"attachments"' | sed 's/"/\n/g' | grep 'http'`
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
                        local response=`[ "${webhookurl["$processid"]}" ] && curl -F "payload_json={\"content\":\"$rightfunny**$dir**/$files$leftfunny\",\"username\":\"${username["$processid"]}\",\"avatar_url\":\"${avatarurl["$processid"]}\"}" -F "filename=@/tmp/bruh$processid/$files" "${webhookurl["$processid"]}" || curl "https://discordapp.com/api/v6/channels/$purechannelid/messages" -H "User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:61.0) Gecko/20100101 Firefox/61.0" -H "Accept: */*" -H "Accept-Language: en-US" --compressed -H "Referer: https://discordapp.com/channels/$channelid" -H "Authorization: ${auth["$processid"]}" -H "Content-Type: multipart/form-data; boundary=---------------------------32345443330436" -H "Cookie: __cfduid=d7be2f6bf6a3c09f82cd952f554ea2cb31531625199" -H "DNT: 1" -H "Connection: keep-alive" -F "payload_json={\"content\":\"$rightfunny**$dir**/$files$leftfunny\",\"nonce\":\"46776845$RANDOM$RANDOM$RANDOM\",\"tts\":false}" -F "filename=@/tmp/bruh$processid/$files"`
                        local discordlink=`echo "$response" | sed 's/,/\n/g' | grep '"attachments"' | grep '"url"' | sed 's/,/\n/g' | grep '"attachments"' | sed 's/"/\n/g' | grep 'http'`
                        echo -e "\e[36m$discordlink\e[0m uploaded by process \e[36m$processid\e[0m"
                        echo "$discordlink" >> "/tmp/damned/$exportfilename.part$processid"
                        echo " dir=downloaded/$dir" >> "/tmp/damned/$exportfilename.part$processid"
                        echo " out=$files" >> "/tmp/damned/$exportfilename.part$processid"
                        sleep $sleeptime
                done
                rm "/tmp/bruh$processid" -rf
            else
                local response=`[ "${webhookurl["$processid"]}" ] && curl -F "payload_json={\"content\":\"$rightfunny**$dir**/$file$leftfunny\",\"username\":\"${username["$processid"]}\",\"avatar_url\":\"${avatarurl["$processid"]}\"}" -F "filename=@$basepath/$dir/$file" "${webhookurl["$processid"]}" || curl "https://discordapp.com/api/v6/channels/$purechannelid/messages" -H "User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:61.0) Gecko/20100101 Firefox/61.0" -H "Accept: */*" -H "Accept-Language: en-US" --compressed -H "Referer: https://discordapp.com/channels/$channelid" -H "Authorization: ${auth["$processid"]}" -H "Content-Type: multipart/form-data; boundary=---------------------------32345443330436" -H "Cookie: __cfduid=d7be2f6bf6a3c09f82cd952f554ea2cb31531625199" -H "DNT: 1" -H "Connection: keep-alive" -F "payload_json={\"content\":\"$rightfunny**$dir**/$file$leftfunny\",\"nonce\":\"46776845$RANDOM$RANDOM$RANDOM\",\"tts\":false}" -F "filename=@$basepath/$dir/$file"`
                local discordlink=`echo "$response" | sed 's/,/\n/g' | grep '"attachments"' | grep '"url"' | sed 's/,/\n/g' | grep '"attachments"' | sed 's/"/\n/g' | grep 'http'`
                echo -e "\e[36m$discordlink\e[0m uploaded by process \e[36m$processid\e[0m"
                echo "$discordlink" >> "/tmp/damned/$exportfilename.part$processid"
                echo " dir=downloaded/$dir" >> "/tmp/damned/$exportfilename.part$processid"
                echo " out=$file" >> "/tmp/damned/$exportfilename.part$processid"
                sleep $sleeptime
            fi
        fi
    fi
}

function scheduler1 {
    sleeptime=0
    echo "" > "$exportfilename"
    rm "/tmp/damned" -rf
    mkdir "/tmp/damned"
    [ "${webhookurl[0]}" ] && curl -d "{\"content\":\"$welcomemessage\",\"username\":\"${username[0]\",\"avatar_url\":\"${avatarurl[0]}\"}" "${webhookurl[0]}" || curl "https://discordapp.com/api/v6/channels/$purechannelid/messages" -H "User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:61.0) Gecko/20100101 Firefox/61.0" -H "Accept: */*" -H "Accept-Language: en-US" --compressed -H "Referer: https://discordapp.com/channels/$channelid" -H "Content-Type: application/json" -H "Authorization: ${auth[0]}" -H "Cookie: __cfduid=d6fa896e3cb4d9ce5a05e36e3c845ada11531595067" -H "DNT: 1" -H "Connection: keep-alive" --data "{\"content\":\"$welcomemessage\",\"nonce\":\"46776845$RANDOM$RANDOM$RANDOM\",\"tts\":false}"; 
    sleep $sleeptime
    
    totalfiles=0
    for fullpath in `find "$basedir"`
    do
        let totalfiles++
        processid=$[totalfiles%processes]
        upload_subprocess "$basedir" "$channelid" "$processid" "$fullpath"
    done
    
    [ "${webhookurl[0]}" ] && curl -d "{\"content\":\"$finishmessage\",\"username\":\"${username[0]\",\"avatar_url\":\"${avatarurl[0]}\"}" "${webhookurl[0]}" || curl "https://discordapp.com/api/v6/channels/$purechannelid/messages" -H "User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:61.0) Gecko/20100101 Firefox/61.0" -H "Accept: */*" -H "Accept-Language: en-US" --compressed -H "Referer: https://discordapp.com/channels/$channelid" -H "Content-Type: application/json" -H "Authorization: ${auth[0]}" -H "Cookie: __cfduid=d6fa896e3cb4d9ce5a05e36e3c845ada11531595067" -H "DNT: 1" -H "Connection: keep-alive" --data "{\"content\":\"$finishmessage\",\"nonce\":\"46776845$RANDOM$RANDOM$RANDOM\",\"tts\":false}";
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
    [ "${webhookurl[0]}" ] && curl -d "{\"content\":\"$welcomemessage\",\"username\":\"${username[0]\",\"avatar_url\":\"${avatarurl[0]}\"}" "${webhookurl[0]}" || curl "https://discordapp.com/api/v6/channels/$purechannelid/messages" -H "User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:61.0) Gecko/20100101 Firefox/61.0" -H "Accept: */*" -H "Accept-Language: en-US" --compressed -H "Referer: https://discordapp.com/channels/$channelid" -H "Content-Type: application/json" -H "Authorization: ${auth[0]}" -H "Cookie: __cfduid=d6fa896e3cb4d9ce5a05e36e3c845ada11531595067" -H "DNT: 1" -H "Connection: keep-alive" --data "{\"content\":\"$welcomemessage\",\"nonce\":\"46776845$RANDOM$RANDOM$RANDOM\",\"tts\":false}"; 
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
            upload_subprocess "$basedir" "$channelid" "$processid" "$fullpath"
        done
    } &
    done
    wait
    
    [ "${webhookurl[0]}" ] && curl -d "{\"content\":\"$finishmessage\",\"username\":\"${username[0]\",\"avatar_url\":\"${avatarurl[0]}\"}" "${webhookurl[0]}" || curl "https://discordapp.com/api/v6/channels/$purechannelid/messages" -H "User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:61.0) Gecko/20100101 Firefox/61.0" -H "Accept: */*" -H "Accept-Language: en-US" --compressed -H "Referer: https://discordapp.com/channels/$channelid" -H "Content-Type: application/json" -H "Authorization: ${auth[0]}" -H "Cookie: __cfduid=d6fa896e3cb4d9ce5a05e36e3c845ada11531595067" -H "DNT: 1" -H "Connection: keep-alive" --data "{\"content\":\"$finishmessage\",\"nonce\":\"46776845$RANDOM$RANDOM$RANDOM\",\"tts\":false}";
    sleep $sleeptime
    for processid in `seq 0 $[processes-1]`
    do
        cat "/tmp/damned/$exportfilename.part$processid" >> "$exportfilename"
    done
    rm "/tmp/damned" -rf
}

OLD_IFS=$IFS
IFS=$'\n'

original_parameters="$0"

for parameter in "$@"
do
    original_parameters="$original_parameters '$parameter'"
done

currentdir=`pwd`
parameters=`getopt -o c:C:e:E:u:U:hHfFnN -a -l config-file:,max-filesize:,export-filename:,uber-pack:,uber-standalone:,help,force-pack,nitro -- "$@"`

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
        -c | -C | --config-file)
            configfilepath="$2"
            shift 2
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
            maxfilesize=48
            shift
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
            echo "./futaba.sh [options] path channelid configfilepath"
            echo
            echo "Options: "
            echo "  --max-filesize <maxfilesize>: max file size in MB when uploadin' to discord, default value is 8MB, exceeded ones would be compressed via rar"
            echo "  -f or -F or --force-pack: pack all files with rar even if they're smaller than max file size"
            echo "  -n or -N or --nitro: equals to --max-filesize 50"
            echo "  -e or -E or --export-filename <filename>: customize filename of discord link file"
            echo "  -u or -U or --uber-pack <filename>: pack generated discord link file, an aria2c.exe and a batch file into an .rar (well, you don't need to type .rar again bruh) so windows users would be happy to use, and most importantly it would be uploaded to discord and have a link aswell, you can instantly copy this link elsewhere as if it's the key to million of files:funny_v2:"
            echo "      --uber-standalone <filename>: pack and upload only, in case this shitty script has an unexpected error at this paticular moment"
            echo
            echo "put auths of accounts and webhook urls into config files, one auth/webhook url per line"
            echo "webhooks must begin with a -W and then seperate webhook url, username (optional) and avatar url (also optional) with a |"
            echo "and btw folder path must be fockin' absolute path"
            exit
            shift
            ;;
        --)
            basedir="$2"
            channelid="$3"
            purechannelid=`echo "$channelid" | cut -d/ -f2`
            shift 2
            break
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
    praseconf
fi

if [ ! "$exportfilename" ]
then
    time=`date +%y.%m.%d`
    exportfilename="${channelid//\//.}.$time.txt"
fi

if [ "$uber2" ]
then
    response=`[ "${webhookurl[0]}" ] && curl -F "payload_json={\"content\":\"link file **$exportfilename** ready to fire$leftfunny$rightfunny\",\"username\":\"${username[0]}\",\"avatar_url\":\"${avatarurl[0]}\"}" -F "filename=@$exportfilename" "${webhookurl[0]}" || curl "https://discordapp.com/api/v6/channels/$purechannelid/messages" -H "User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:61.0) Gecko/20100101 Firefox/61.0" -H "Accept: */*" -H "Accept-Language: en-US" --compressed -H "Referer: https://discordapp.com/channels/$channelid" -H "Authorization: ${auth[0]}" -H "Content-Type: multipart/form-data; boundary=---------------------------32345443330436" -H "Cookie: __cfduid=d7be2f6bf6a3c09f82cd952f554ea2cb31531625199" -H "DNT: 1" -H "Connection: keep-alive" -F "payload_json={\"content\":\"link file **$exportfilename** ready to fire$leftfunny$rightfunny\",\"nonce\":\"46776845$RANDOM$RANDOM$RANDOM\",\"tts\":false}" -F "filename=@$exportfilename"`
    discordlink=`echo "$response" | sed 's/,/\n/g' | grep '"attachments"' | grep '"url"' | sed 's/,/\n/g' | grep '"attachments"' | sed 's/"/\n/g' | grep 'http'`
    echo -e "your link file's link: \e[36m$discordlink\e[0m"
    echo "aria2c -x 128 -s 128 -j 128 -k 1M -R -c --auto-file-renaming=false -i $exportfilename" > direct.download.bat
    echo "aria2c -x 128 -s 128 -j 128 -k 1M -R -c --auto-file-renaming=false -i %1" > drag.list.file.and.download.bat
    rar a -ep1 -htb -m5 -ma5 -rr5 -ts -ol "/tmp/$uber2.rar" "$exportfilename" "$aria2location" "direct.download.bat" "drag.list.file.and.download.bat"
    rm "direct.download.bat" "drag.list.file.and.download.bat" -f
    response=`[ "${webhookurl[0]}" ] && curl -F "payload_json={\"content\":\"über pack **$uber2.rar** ready to fire$leftfunny$rightfunny\",\"username\":\"${username[0]}\",\"avatar_url\":\"${avatarurl[0]}\"}" -F "filename=@/tmp/$uber2.rar" "$webhookurl" || curl "https://discordapp.com/api/v6/channels/$purechannelid/messages" -H "User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:61.0) Gecko/20100101 Firefox/61.0" -H "Accept: */*" -H "Accept-Language: en-US" --compressed -H "Referer: https://discordapp.com/channels/$channelid" -H "Authorization: ${auth[0]}" -H "Content-Type: multipart/form-data; boundary=---------------------------32345443330436" -H "Cookie: __cfduid=d7be2f6bf6a3c09f82cd952f554ea2cb31531625199" -H "DNT: 1" -H "Connection: keep-alive" -F "payload_json={\"content\":\"über pack **$uber2.rar** ready to fire$leftfunny$rightfunny\",\"nonce\":\"46776845$RANDOM$RANDOM$RANDOM\",\"tts\":false}" -F "filename=@/tmp/$uber2.rar"`
    discordlink=`echo "$response" | sed 's/,/\n/g' | grep '"attachments"' | grep '"url"' | sed 's/,/\n/g' | grep '"attachments"' | sed 's/"/\n/g' | grep 'http'`
    echo -e "your über pack's link: \e[36m$discordlink\e[0m"
    rm "/tmp/$uber2.rar" -f
    exit
fi

scheduler2

if [ "$uber" ]
then
    response=`[ "${webhookurl[0]}" ] && curl -F "payload_json={\"content\":\"link file **$exportfilename** ready to fire$leftfunny$rightfunny\",\"username\":\"${username[0]}\",\"avatar_url\":\"${avatarurl[0]}\"}" -F "filename=@$exportfilename" "$webhookurl" || curl "https://discordapp.com/api/v6/channels/$purechannelid/messages" -H "User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:61.0) Gecko/20100101 Firefox/61.0" -H "Accept: */*" -H "Accept-Language: en-US" --compressed -H "Referer: https://discordapp.com/channels/$channelid" -H "Authorization: ${auth[0]}" -H "Content-Type: multipart/form-data; boundary=---------------------------32345443330436" -H "Cookie: __cfduid=d7be2f6bf6a3c09f82cd952f554ea2cb31531625199" -H "DNT: 1" -H "Connection: keep-alive" -F "payload_json={\"content\":\"link file **$exportfilename** ready to fire$leftfunny$rightfunny\",\"nonce\":\"46776845$RANDOM$RANDOM$RANDOM\",\"tts\":false}" -F "filename=@$exportfilename"`
    discordlink=`echo "$response" | sed 's/,/\n/g' | grep '"attachments"' | grep '"url"' | sed 's/,/\n/g' | grep '"attachments"' | sed 's/"/\n/g' | grep 'http'`
    echo -e "your link file's link: \e[36m$discordlink\e[0m"
    echo "aria2c -x 128 -s 128 -j 128 -k 1M -R -c --auto-file-renaming=false -i $exportfilename" > direct.download.bat
    echo "aria2c -x 128 -s 128 -j 128 -k 1M -R -c --auto-file-renaming=false -i %1" > drag.list.file.and.download.bat
    rar a -ep1 -htb -m5 -ma5 -rr5 -ts -ol "/tmp/$uber.rar" "$exportfilename" "$aria2location" "direct.download.bat" "drag.list.file.and.download.bat"
    rm "direct.download.bat" "drag.list.file.and.download.bat" -f
    response=`[ "${webhookurl[0]}" ] && curl -F "payload_json={\"content\":\"über pack **$uber.rar** ready to fire$leftfunny$rightfunny\",\"username\":\"${username[0]}\",\"avatar_url\":\"${avatarurl[0]}\"}" -F "filename=@/tmp/$uber.rar" "$webhookurl" || curl "https://discordapp.com/api/v6/channels/$purechannelid/messages" -H "User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:61.0) Gecko/20100101 Firefox/61.0" -H "Accept: */*" -H "Accept-Language: en-US" --compressed -H "Referer: https://discordapp.com/channels/$channelid" -H "Authorization: ${auth[0]}" -H "Content-Type: multipart/form-data; boundary=---------------------------32345443330436" -H "Cookie: __cfduid=d7be2f6bf6a3c09f82cd952f554ea2cb31531625199" -H "DNT: 1" -H "Connection: keep-alive" -F "payload_json={\"content\":\"über pack **$uber.rar** ready to fire$leftfunny$rightfunny\",\"nonce\":\"46776845$RANDOM$RANDOM$RANDOM\",\"tts\":false}" -F "filename=@/tmp/$uber.rar"`
    discordlink=`echo "$response" | sed 's/,/\n/g' | grep '"attachments"' | grep '"url"' | sed 's/,/\n/g' | grep '"attachments"' | sed 's/"/\n/g' | grep 'http'`
    echo -e "your über pack's link: \e[36m$discordlink\e[0m"
    rm "/tmp/$uber.rar" -f
fi

IFS=$OLD_IFS
