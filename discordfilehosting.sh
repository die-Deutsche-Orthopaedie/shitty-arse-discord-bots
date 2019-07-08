#!/bin/bash
# copyrekt die deutsche Orthopädiespezialist 201⑨
# discord "file hostin'" bot (sarcastic
# upload all files of a folder to discord
# auto compress files into 8MB or 50MB volumes if file size excceeded
# auto generate discord links file so you can aria2c its sorry arse afterwards, so that you actually don't need to be limited to bullshit 8MB or 50MB file size limit

maxfilesize=8 # in MB and not in MiB bruh
aria2location="/lea/is/worst/girl/aria2c.exe"
auth_defaults=""

function recursiveUploadv3 { # $1 = absolute path, $2 = channel id, $3 = superbase
    channelid="$2"
    purechannelid=`echo "$channelid" | cut -d/ -f2`
    if [ "$3" ]
    then
        superbase="$3"
    else
        curl "https://discordapp.com/api/v6/channels/$purechannelid/messages" -H "User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:61.0) Gecko/20100101 Firefox/61.0" -H "Accept: */*" -H "Accept-Language: en-US" --compressed -H "Referer: https://discordapp.com/channels/$channelid" -H "Content-Type: application/json" -H "Authorization: $auth" -H "Cookie: __cfduid=d6fa896e3cb4d9ce5a05e36e3c845ada11531595067" -H "DNT: 1" -H "Connection: keep-alive" --data "{\"content\":\"ddOs' hentai upload bot would be runnin' in here soon, pls consider mutin' this place for a minute<:funny_v2:530321446338035742><:funny_v2_right:530321527908859907>\",\"nonce\":\"46776845$RANDOM$RANDOM$RANDOM\",\"tts\":false}";
        sleep 1
        superbase="$1"
    fi
    local base="$1"
    for file in `ls "$base" | sed 's/ /|/g'`
    do
        file=`echo "$file" | sed 's/|/ /g'`
        if [ -d "$base/$file" ]
        then
            path="$base/$file"
            relative=${path#$superbase}
            curl "https://discordapp.com/api/v6/channels/$purechannelid/messages" -H "User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:61.0) Gecko/20100101 Firefox/61.0" -H "Accept: */*" -H "Accept-Language: en-US" --compressed -H "Referer: https://discordapp.com/channels/$channelid" -H "Content-Type: application/json" -H "Authorization: $auth" -H "Cookie: __cfduid=d6fa896e3cb4d9ce5a05e36e3c845ada11531595067" -H "DNT: 1" -H "Connection: keep-alive" --data "{\"content\":\"<:funny_v2_right:530321527908859907>**${relative#/}**<:funny_v2:530321446338035742>\",\"nonce\":\"46776845$RANDOM$RANDOM$RANDOM\",\"tts\":false}";
            recursiveUploadv3 "$base/$file" "$2" "$superbase"
            sleep 1
        else
            if [[ "$file" == *,* ]]
            then
                file2=`echo "$file" | sed 's/,/_/g'`
                if [ $filesize -gt $((1000000*$maxfilesize)) ]
                then
                    rm /tmp/bruh -rf
                    mkdir /tmp/bruh
                    rar a -v${maxfilesize}M -ep1 -htb -m0 -ma5 -rr5 -ts -ol "/tmp/bruh/${file2%.*}.rar" "$base/$file"
                    for files in `ls /tmp/bruh | sed 's/ /|/g'`
                    do
                        files=`echo "$files" | sed 's/|/ /g'`
                        response=`curl "https://discordapp.com/api/v6/channels/$purechannelid/messages" -H "User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:61.0) Gecko/20100101 Firefox/61.0" -H "Accept: */*" -H "Accept-Language: en-US" --compressed -H "Referer: https://discordapp.com/channels/$channelid" -H "Authorization: $auth" -H "Content-Type: multipart/form-data; boundary=---------------------------32345443330436" -H "Cookie: __cfduid=d7be2f6bf6a3c09f82cd952f554ea2cb31531625199" -H "DNT: 1" -H "Connection: keep-alive" -F "payload_json={\"content\":\"<:funny_v2_right:530321527908859907>$files<:funny_v2:530321446338035742>\",\"nonce\":\"46776845$RANDOM$RANDOM$RANDOM\",\"tts\":false}" -F "filename=@/tmp/bruh/$files"`
                        discordlink=`echo "$response" | sed 's/,/\n/g' | grep '"attachments"' | grep '"url"' | sed 's/,/\n/g' | grep '"attachments"' | sed 's/"/\n/g' | grep 'http'`
                        echo -e "\e[36m$discordlink\e[0m"
                        echo "$discordlink" >> "$exportfilename"
                        sleep 1
                    done
                    rm /tmp/bruh -rf
                else
                    mv "$base/$file" "$base/$file2"
                    response=`curl "https://discordapp.com/api/v6/channels/$purechannelid/messages" -H "User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:61.0) Gecko/20100101 Firefox/61.0" -H "Accept: */*" -H "Accept-Language: en-US" --compressed -H "Referer: https://discordapp.com/channels/$channelid" -H "Authorization: $auth" -H "Content-Type: multipart/form-data; boundary=---------------------------32345443330436" -H "Cookie: __cfduid=d7be2f6bf6a3c09f82cd952f554ea2cb31531625199" -H "DNT: 1" -H "Connection: keep-alive" -F "payload_json={\"content\":\"<:funny_v2_right:530321527908859907>$file<:funny_v2:530321446338035742>\",\"nonce\":\"46776845$RANDOM$RANDOM$RANDOM\",\"tts\":false}" -F "filename=@$base/$file2"`
                    discordlink=`echo "$response" | sed 's/,/\n/g' | grep '"attachments"' | grep '"url"' | sed 's/,/\n/g' | grep '"attachments"' | sed 's/"/\n/g' | grep 'http'`
                    echo -e "\e[36m$discordlink\e[0m"
                    echo "$discordlink" >> "$exportfilename"
                    sleep 1
                    mv "$base/$file2" "$base/$file"
                fi
            else
                filesize=`ls -l "$base/$file" | awk '{ print $5 }'`
                if [ $filesize -gt $((1048576*$maxfilesize)) ]
                then
                    rm /tmp/bruh -rf
                    mkdir /tmp/bruh
                    rar a -v${maxfilesize}M -ep1 -htb -m0 -ma5 -rr5 -ts -ol "/tmp/bruh/${file%.*}.rar" "$base/$file"
                    for files in `ls /tmp/bruh | sed 's/ /|/g'`
                    do
                        files=`echo "$files" | sed 's/|/ /g'`
                        response=`curl "https://discordapp.com/api/v6/channels/$purechannelid/messages" -H "User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:61.0) Gecko/20100101 Firefox/61.0" -H "Accept: */*" -H "Accept-Language: en-US" --compressed -H "Referer: https://discordapp.com/channels/$channelid" -H "Authorization: $auth" -H "Content-Type: multipart/form-data; boundary=---------------------------32345443330436" -H "Cookie: __cfduid=d7be2f6bf6a3c09f82cd952f554ea2cb31531625199" -H "DNT: 1" -H "Connection: keep-alive" -F "payload_json={\"content\":\"<:funny_v2_right:530321527908859907>$files<:funny_v2:530321446338035742>\",\"nonce\":\"46776845$RANDOM$RANDOM$RANDOM\",\"tts\":false}" -F "filename=@/tmp/bruh/$files"`
                        discordlink=`echo "$response" | sed 's/,/\n/g' | grep '"attachments"' | grep '"url"' | sed 's/,/\n/g' | grep '"attachments"' | sed 's/"/\n/g' | grep 'http'`
                        echo -e "\e[36m$discordlink\e[0m"
                        echo "$discordlink" >> "$exportfilename"
                        sleep 1
                    done
                    rm /tmp/bruh -rf
                else
                    response=`curl "https://discordapp.com/api/v6/channels/$purechannelid/messages" -H "User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:61.0) Gecko/20100101 Firefox/61.0" -H "Accept: */*" -H "Accept-Language: en-US" --compressed -H "Referer: https://discordapp.com/channels/$channelid" -H "Authorization: $auth" -H "Content-Type: multipart/form-data; boundary=---------------------------32345443330436" -H "Cookie: __cfduid=d7be2f6bf6a3c09f82cd952f554ea2cb31531625199" -H "DNT: 1" -H "Connection: keep-alive" -F "payload_json={\"content\":\"<:funny_v2_right:530321527908859907>$file<:funny_v2:530321446338035742>\",\"nonce\":\"46776845$RANDOM$RANDOM$RANDOM\",\"tts\":false}" -F "filename=@$base/$file"`
                    discordlink=`echo "$response" | sed 's/,/\n/g' | grep '"attachments"' | grep '"url"' | sed 's/,/\n/g' | grep '"attachments"' | sed 's/"/\n/g' | grep 'http'`
                    echo -e "\e[36m$discordlink\e[0m"
                    echo "$discordlink" >> "$exportfilename"
                    sleep 1
                fi
            fi
        fi
    done
    if [ ! "$3" ]
    then
        curl "https://discordapp.com/api/v6/channels/$purechannelid/messages" -H "User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:61.0) Gecko/20100101 Firefox/61.0" -H "Accept: */*" -H "Accept-Language: en-US" --compressed -H "Referer: https://discordapp.com/channels/$channelid" -H "Content-Type: application/json" -H "Authorization: $auth" -H "Cookie: __cfduid=d6fa896e3cb4d9ce5a05e36e3c845ada11531595067" -H "DNT: 1" -H "Connection: keep-alive" --data "{\"content\":\"done<:funny_v2:530321446338035742><:funny_v2_right:530321527908859907>\",\"nonce\":\"46776845$RANDOM$RANDOM$RANDOM\",\"tts\":false}";
    fi
}


original_parameters="$0"

for parameter in "$@"
do
    original_parameters="$original_parameters '$parameter'"
done

starttime=`date +%s%N`
currentdir=`pwd`
parameters=`getopt -o c:C:e:E:u:U:hHnN -a -l config-file:,max-filesize:,export-filename:,uber-pack:,help,nitro -- "$@"`

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
        -h | -H | --help)
            echo "copyrekt die deutsche Orthopädiespezialist 201⑨"
            echo "discord \"file hostin'\" bot (sarcastic"
            echo "upload all files of a folder to discord"
            echo
            echo "Usage: "
            echo "./futaba.sh [options] path channelid [auth]"
            echo
            echo "Options: "
            echo "  -c or -C or --config-file <configfilepath>: load a configuration file which contains three lines of webhook url, account curl command and account curl command (used to upload); well it's for backward compatibility of futaba.sh bruh"
            echo "  --max-filesize <maxfilesize>: max file size in MB when uploadin' to discord, default value is 8MB, exceeded ones would be compressed via rar"
            echo "  -n or -N or --nitro: equals to --max-filesize 50"
            echo "  -e or -E or --export-filename <filename>: customize filename of discord links file"
            echo "  -u or -U or --uber-pack <filename>: pack generated discord links file, an aria2c.exe and a batch file into an .rar (well, you don't need to type .rar again bruh) so windows users would be happy to use, and most importantly it would be uploaded to discord and have a link aswell, you can instantly copy this link elsewhere as if it's the key to million of files:funny_v2:"
            echo
            echo "and btw folder path must be fockin' absolute path"
            exit
            shift
            ;;
        --)
            basedir="$2"
            channelid="$3"
            shift 2
            break
            ;;
        *)
            echo "Internal error!"
            exit 255
            ;;
    esac
done

if [ "$2" ] && [ "$configfilepath" ]
then
    echo "Houston, we have an arsefockin' problem: You basically can't use auth and config file both" >&2
    exit 3
fi

if [ "$configfilepath" ]
then
    auth=`cat "$configfilepath" | grep '"Authorization: ' | head -1 | sed 's/"/\n/g' | grep "Authorization: " | sed 's/Authorization: //g'`
else
    if [ "$2" ]
    then
        auth="$2"
    else
        if [ "$auth_defaults" ]
        then
            auth="$auth_defaults"
        else
            echo "Houston, we have an arsefockin' problem: No auth nor config file" >&2
            exit 4
        fi
    fi
fi

if [ ! "$exportfilename" ]
then
    time=`date +%y.%m.%d`
    exportfilename="${channelid//\//.}.$time.txt"
fi

echo "" > "$exportfilename"
recursiveUploadv3 "$basedir" "$channelid"


if [ "$uber" ]
then
    echo "aria2c -x 128 -s 128 -j 128 -k 1M -R -i $exportfilename" > direct.download.bat
    echo "aria2c -x 128 -s 128 -j 128 -k 1M -R -i %1" > drag.list.file.and.download.bat
    rar a -ep1 -htb -m5 -ma5 -rr5 -ts -ol "/tmp/$uber.rar" "$exportfilename" "$aria2location" "direct.download.bat" "drag.list.file.and.download.bat"
    rm "direct.download.bat" "drag.list.file.and.download.bat" -f
    response=`curl "https://discordapp.com/api/v6/channels/$purechannelid/messages" -H "User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:61.0) Gecko/20100101 Firefox/61.0" -H "Accept: */*" -H "Accept-Language: en-US" --compressed -H "Referer: https://discordapp.com/channels/$channelid" -H "Authorization: $auth" -H "Content-Type: multipart/form-data; boundary=---------------------------32345443330436" -H "Cookie: __cfduid=d7be2f6bf6a3c09f82cd952f554ea2cb31531625199" -H "DNT: 1" -H "Connection: keep-alive" -F "payload_json={\"content\":\"über pack $uber.rar ready to fire<:funny_v2:530321446338035742><:funny_v2_right:530321527908859907>\",\"nonce\":\"46776845$RANDOM$RANDOM$RANDOM\",\"tts\":false}" -F "filename=@/tmp/$uber.rar"`
    discordlink=`echo "$response" | sed 's/,/\n/g' | grep '"attachments"' | grep '"url"' | sed 's/,/\n/g' | grep '"attachments"' | sed 's/"/\n/g' | grep 'http'`
    echo -e "your über pack link: \e[36m$discordlink\e[0m"
    rm "/tmp/$uber.rar" -f
fi
