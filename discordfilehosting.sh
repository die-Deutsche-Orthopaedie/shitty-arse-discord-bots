#!/bin/bash
# copyrekt die deutsche Orthopädiespezialist 201⑨
# discord "file hostin'" bot (sarcastic
# upload all files of a folder to discord
# auto compress files into 8MB or 50MB volumes if file size excceeded
# auto generate discord link file so you can aria2c its sorry arse afterwards, so that you actually don't need to be limited to bullshit 8MB or 50MB file size limit

maxfilesize=8 # in MB and not in MiB bruh
aria2location="/lea/is/worst/girl/aria2c.exe"
auth_defaults=""

rightfunny=""
leftfunny=""
welcomemessage="ddOs' hentai upload bot would be runnin' in here soon, pls consider mutin' this place for a minute$leftfunny$rightfunny"
finishmessage="done$leftfunny$rightfunny"

username="Hermann FEGELEIN! FEGELEIN!! FEGELEIN!!! "
avatarurl="https://discordapp.com/assets/322c936a8c8be1b803cd94861bdfa868.png"

function recursiveUploadv3 { # $1 = absolute path, $2 = channel id, $3 = superbase
    channelid="$2"
    purechannelid=`echo "$channelid" | cut -d/ -f2`
    if [ "$3" ]
    then
        superbase="$3"
    else
        [ "$webhookurl" ] && curl -d "{\"content\":\"$welcomemessage\",\"username\":\"$username\",\"avatar_url\":\"$avatarurl\"}" "$webhookurl" || curl "https://discordapp.com/api/v6/channels/$purechannelid/messages" -H "User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:61.0) Gecko/20100101 Firefox/61.0" -H "Accept: */*" -H "Accept-Language: en-US" --compressed -H "Referer: https://discordapp.com/channels/$channelid" -H "Content-Type: application/json" -H "Authorization: $auth" -H "Cookie: __cfduid=d6fa896e3cb4d9ce5a05e36e3c845ada11531595067" -H "DNT: 1" -H "Connection: keep-alive" --data "{\"content\":\"$welcomemessage\",\"nonce\":\"46776845$RANDOM$RANDOM$RANDOM\",\"tts\":false}"; 
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
            [ "$webhookurl" ] && curl -d "{\"content\":\"$rightfunny**${relative#/}**$leftfunny\",\"username\":\"$username\",\"avatar_url\":\"$avatarurl\"}" "$webhookurl" || curl "https://discordapp.com/api/v6/channels/$purechannelid/messages" -H "User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:61.0) Gecko/20100101 Firefox/61.0" -H "Accept: */*" -H "Accept-Language: en-US" --compressed -H "Referer: https://discordapp.com/channels/$channelid" -H "Content-Type: application/json" -H "Authorization: $auth" -H "Cookie: __cfduid=d6fa896e3cb4d9ce5a05e36e3c845ada11531595067" -H "DNT: 1" -H "Connection: keep-alive" --data "{\"content\":\"$rightfunny**${relative#/}**$leftfunny\",\"nonce\":\"46776845$RANDOM$RANDOM$RANDOM\",\"tts\":false}";
            recursiveUploadv3 "$base/$file" "$2" "$superbase"
            sleep 1
        else
            relativepath="${base#$superbase}"
            relativepath="${relativepath#/}"
            if [[ "$file" == *,* ]]
            then
                file2=`echo "$file" | sed 's/,/_/g'`
                filesize=`ls -l "$base/$file" | awk '{ print $5 }'`
                if [ "$forcepack" ] || [ $filesize -gt $((1000000*$maxfilesize)) ]
                then
                    rm /tmp/bruh -rf
                    mkdir /tmp/bruh
                    rar a -v${maxfilesize}M -ep1 -htb -m0 -ma5 -rr5 -ts -ol "/tmp/bruh/${file2%.*}.rar" "$base/$file"
                    file="${file%.*}"
                    file2="${file2%.*}"
                    for files in `ls /tmp/bruh | sed 's/ /|/g'`
                    do
                        files=`echo "$files" | sed 's/|/ /g'`
                        newfiles="${files/$file2/$file}"
                        response=`[ "$webhookurl" ] && curl -F "payload_json={\"content\":\"$rightfunny$newfiles$leftfunny\",\"username\":\"$username\",\"avatar_url\":\"$avatarurl\"}" -F "filename=@/tmp/bruh/$files" "$webhookurl" || curl "https://discordapp.com/api/v6/channels/$purechannelid/messages" -H "User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:61.0) Gecko/20100101 Firefox/61.0" -H "Accept: */*" -H "Accept-Language: en-US" --compressed -H "Referer: https://discordapp.com/channels/$channelid" -H "Authorization: $auth" -H "Content-Type: multipart/form-data; boundary=---------------------------32345443330436" -H "Cookie: __cfduid=d7be2f6bf6a3c09f82cd952f554ea2cb31531625199" -H "DNT: 1" -H "Connection: keep-alive" -F "payload_json={\"content\":\"$rightfunny$newfiles$leftfunny\",\"nonce\":\"46776845$RANDOM$RANDOM$RANDOM\",\"tts\":false}" -F "filename=@/tmp/bruh/$files"`
                        discordlink=`echo "$response" | sed 's/,/\n/g' | grep '"attachments"' | grep '"url"' | sed 's/,/\n/g' | grep '"attachments"' | sed 's/"/\n/g' | grep 'http'`
                        echo -e "\e[36m$discordlink\e[0m"
                        echo "$discordlink" >> "$exportfilename"
                        echo " dir=downloaded/$relativepath" >> "$exportfilename"
                        echo " out=$newfiles" >> "$exportfilename"
                        sleep 1
                    done
                    rm /tmp/bruh -rf
                else
                    mv "$base/$file" "$base/$file2"
                    response=`[ "$webhookurl" ] && curl -F "payload_json={\"content\":\"$rightfunny$file$leftfunny\",\"username\":\"$username\",\"avatar_url\":\"$avatarurl\"}" -F "filename=@$base/$file2" "$webhookurl" || curl "https://discordapp.com/api/v6/channels/$purechannelid/messages" -H "User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:61.0) Gecko/20100101 Firefox/61.0" -H "Accept: */*" -H "Accept-Language: en-US" --compressed -H "Referer: https://discordapp.com/channels/$channelid" -H "Authorization: $auth" -H "Content-Type: multipart/form-data; boundary=---------------------------32345443330436" -H "Cookie: __cfduid=d7be2f6bf6a3c09f82cd952f554ea2cb31531625199" -H "DNT: 1" -H "Connection: keep-alive" -F "payload_json={\"content\":\"$rightfunny$file$leftfunny\",\"nonce\":\"46776845$RANDOM$RANDOM$RANDOM\",\"tts\":false}" -F "filename=@$base/$file2"`
                    discordlink=`echo "$response" | sed 's/,/\n/g' | grep '"attachments"' | grep '"url"' | sed 's/,/\n/g' | grep '"attachments"' | sed 's/"/\n/g' | grep 'http'`
                    echo -e "\e[36m$discordlink\e[0m"
                    echo "$discordlink" >> "$exportfilename"
                    echo " dir=downloaded/$relativepath" >> "$exportfilename"
                    echo " out=$file" >> "$exportfilename"
                    sleep 1
                    mv "$base/$file2" "$base/$file"
                fi
            else
                filesize=`ls -l "$base/$file" | awk '{ print $5 }'`
                if [ "$forcepack" ] || [ $filesize -gt $((1048576*$maxfilesize)) ]
                then
                    rm /tmp/bruh -rf
                    mkdir /tmp/bruh
                    rar a -v${maxfilesize}M -ep1 -htb -m0 -ma5 -rr5 -ts -ol "/tmp/bruh/${file%.*}.rar" "$base/$file"
                    for files in `ls /tmp/bruh | sed 's/ /|/g'`
                    do
                        files=`echo "$files" | sed 's/|/ /g'`
                        response=`[ "$webhookurl" ] && curl -F "payload_json={\"content\":\"$rightfunny$files$leftfunny\",\"username\":\"$username\",\"avatar_url\":\"$avatarurl\"}" -F "filename=@/tmp/bruh/$files" "$webhookurl" || curl "https://discordapp.com/api/v6/channels/$purechannelid/messages" -H "User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:61.0) Gecko/20100101 Firefox/61.0" -H "Accept: */*" -H "Accept-Language: en-US" --compressed -H "Referer: https://discordapp.com/channels/$channelid" -H "Authorization: $auth" -H "Content-Type: multipart/form-data; boundary=---------------------------32345443330436" -H "Cookie: __cfduid=d7be2f6bf6a3c09f82cd952f554ea2cb31531625199" -H "DNT: 1" -H "Connection: keep-alive" -F "payload_json={\"content\":\"$rightfunny$files$leftfunny\",\"nonce\":\"46776845$RANDOM$RANDOM$RANDOM\",\"tts\":false}" -F "filename=@/tmp/bruh/$files"`
                        discordlink=`echo "$response" | sed 's/,/\n/g' | grep '"attachments"' | grep '"url"' | sed 's/,/\n/g' | grep '"attachments"' | sed 's/"/\n/g' | grep 'http'`
                        echo -e "\e[36m$discordlink\e[0m"
                        echo "$discordlink" >> "$exportfilename"
                        echo " dir=downloaded/$relativepath" >> "$exportfilename"
                        echo " out=$files" >> "$exportfilename"
                        sleep 1
                    done
                    rm /tmp/bruh -rf
                else
                    response=`[ "$webhookurl" ] && curl -F "payload_json={\"content\":\"$rightfunny$file$leftfunny\",\"username\":\"$username\",\"avatar_url\":\"$avatarurl\"}" -F "filename=@$base/$file" "$webhookurl" || curl "https://discordapp.com/api/v6/channels/$purechannelid/messages" -H "User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:61.0) Gecko/20100101 Firefox/61.0" -H "Accept: */*" -H "Accept-Language: en-US" --compressed -H "Referer: https://discordapp.com/channels/$channelid" -H "Authorization: $auth" -H "Content-Type: multipart/form-data; boundary=---------------------------32345443330436" -H "Cookie: __cfduid=d7be2f6bf6a3c09f82cd952f554ea2cb31531625199" -H "DNT: 1" -H "Connection: keep-alive" -F "payload_json={\"content\":\"$rightfunny$file$leftfunny\",\"nonce\":\"46776845$RANDOM$RANDOM$RANDOM\",\"tts\":false}" -F "filename=@$base/$file"`
                    discordlink=`echo "$response" | sed 's/,/\n/g' | grep '"attachments"' | grep '"url"' | sed 's/,/\n/g' | grep '"attachments"' | sed 's/"/\n/g' | grep 'http'`
                    echo -e "\e[36m$discordlink\e[0m"
                    echo "$discordlink" >> "$exportfilename"
                    echo " dir=downloaded/$relativepath" >> "$exportfilename"
                    echo " out=$file" >> "$exportfilename"
                    sleep 1
                fi
            fi
        fi
    done
    if [ ! "$3" ]
    then
        [ "$webhookurl" ] && curl -d "{\"content\":\"$finishmessage\",\"username\":\"$username\",\"avatar_url\":\"$avatarurl\"}" "$webhookurl" || curl "https://discordapp.com/api/v6/channels/$purechannelid/messages" -H "User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:61.0) Gecko/20100101 Firefox/61.0" -H "Accept: */*" -H "Accept-Language: en-US" --compressed -H "Referer: https://discordapp.com/channels/$channelid" -H "Content-Type: application/json" -H "Authorization: $auth" -H "Cookie: __cfduid=d6fa896e3cb4d9ce5a05e36e3c845ada11531595067" -H "DNT: 1" -H "Connection: keep-alive" --data "{\"content\":\"$finishmessage\",\"nonce\":\"46776845$RANDOM$RANDOM$RANDOM\",\"tts\":false}";
    fi
}

original_parameters="$0"

for parameter in "$@"
do
    original_parameters="$original_parameters '$parameter'"
done

starttime=`date +%s%N`
currentdir=`pwd`
parameters=`getopt -o c:C:e:E:u:U:w:W:hHfFnN -a -l config-file:,max-filesize:,export-filename:,uber-pack:,uber-standalone:,webhook:,webhook-username:,webhook-avatarurl:,help,force-pack,nitro -- "$@"`

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
        -w | -W | --webhook)
            webhookurl="$2"
            shift 2
            ;;
        --webhook-username)
            username="$2"
            shift 2
            ;;
        --webhook-avatarurl)
            avatarurl="$2"
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
            echo "  -f or -F or --force-pack: pack all files with rar even if they're smaller than max file size"
            echo "  -n or -N or --nitro: equals to --max-filesize 50"
            echo "  -e or -E or --export-filename <filename>: customize filename of discord link file"
            echo "  -u or -U or --uber-pack <filename>: pack generated discord link file, an aria2c.exe and a batch file into an .rar (well, you don't need to type .rar again bruh) so windows users would be happy to use, and most importantly it would be uploaded to discord and have a link aswell, you can instantly copy this link elsewhere as if it's the key to million of files:funny_v2:"
            echo "      --uber-standalone <filename>: pack and upload only, in case this shitty script has an unexpected error at this paticular moment"
            echo "  -w or -W or --webhook <webhook url>: use webhook to upload files, well, unless your guild is \"boosted\" by at least 10 \"advanced\" nitro users by a total of fockin' $100/mo, you can never upload files exceedin' 8MB without rar"
            echo "      --webhook-username <username>: customize webhook bot's username"
            echo "      --webhook-avatarurl <avatar url>: customize webhook bot's avatar"
            echo
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

if [ "$uber2" ]
then
    response=`[ "$webhookurl" ] && curl -F "payload_json={\"content\":\"link file **$exportfilename** ready to fire$leftfunny$rightfunny\",\"username\":\"$username\",\"avatar_url\":\"$avatarurl\"}" -F "filename=@$exportfilename" "$webhookurl" || curl "https://discordapp.com/api/v6/channels/$purechannelid/messages" -H "User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:61.0) Gecko/20100101 Firefox/61.0" -H "Accept: */*" -H "Accept-Language: en-US" --compressed -H "Referer: https://discordapp.com/channels/$channelid" -H "Authorization: $auth" -H "Content-Type: multipart/form-data; boundary=---------------------------32345443330436" -H "Cookie: __cfduid=d7be2f6bf6a3c09f82cd952f554ea2cb31531625199" -H "DNT: 1" -H "Connection: keep-alive" -F "payload_json={\"content\":\"link file **$exportfilename** ready to fire$leftfunny$rightfunny\",\"nonce\":\"46776845$RANDOM$RANDOM$RANDOM\",\"tts\":false}" -F "filename=@$exportfilename"`
    discordlink=`echo "$response" | sed 's/,/\n/g' | grep '"attachments"' | grep '"url"' | sed 's/,/\n/g' | grep '"attachments"' | sed 's/"/\n/g' | grep 'http'`
    echo -e "your link file's link: \e[36m$discordlink\e[0m"
    echo "aria2c -x 128 -s 128 -j 128 -k 1M -R -c --auto-file-renaming=false -i $exportfilename" > direct.download.bat
    echo "aria2c -x 128 -s 128 -j 128 -k 1M -R -c --auto-file-renaming=false -i %1" > drag.list.file.and.download.bat
    rar a -ep1 -htb -m5 -ma5 -rr5 -ts -ol "/tmp/$uber2.rar" "$exportfilename" "$aria2location" "direct.download.bat" "drag.list.file.and.download.bat"
    rm "direct.download.bat" "drag.list.file.and.download.bat" -f
    response=`[ "$webhookurl" ] && curl -F "payload_json={\"content\":\"über pack **$uber2.rar** ready to fire$leftfunny$rightfunny\",\"username\":\"$username\",\"avatar_url\":\"$avatarurl\"}" -F "filename=@/tmp/$uber2.rar" "$webhookurl" || curl "https://discordapp.com/api/v6/channels/$purechannelid/messages" -H "User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:61.0) Gecko/20100101 Firefox/61.0" -H "Accept: */*" -H "Accept-Language: en-US" --compressed -H "Referer: https://discordapp.com/channels/$channelid" -H "Authorization: $auth" -H "Content-Type: multipart/form-data; boundary=---------------------------32345443330436" -H "Cookie: __cfduid=d7be2f6bf6a3c09f82cd952f554ea2cb31531625199" -H "DNT: 1" -H "Connection: keep-alive" -F "payload_json={\"content\":\"über pack **$uber2.rar** ready to fire$leftfunny$rightfunny\",\"nonce\":\"46776845$RANDOM$RANDOM$RANDOM\",\"tts\":false}" -F "filename=@/tmp/$uber2.rar"`
    discordlink=`echo "$response" | sed 's/,/\n/g' | grep '"attachments"' | grep '"url"' | sed 's/,/\n/g' | grep '"attachments"' | sed 's/"/\n/g' | grep 'http'`
    echo -e "your über pack's link: \e[36m$discordlink\e[0m"
    rm "/tmp/$uber2.rar" -f
    exit
fi

echo "" > "$exportfilename"
recursiveUploadv3 "$basedir" "$channelid"

if [ "$uber" ]
then
    response=`[ "$webhookurl" ] && curl -F "payload_json={\"content\":\"link file **$exportfilename** ready to fire$leftfunny$rightfunny\",\"username\":\"$username\",\"avatar_url\":\"$avatarurl\"}" -F "filename=@$exportfilename" "$webhookurl" || curl "https://discordapp.com/api/v6/channels/$purechannelid/messages" -H "User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:61.0) Gecko/20100101 Firefox/61.0" -H "Accept: */*" -H "Accept-Language: en-US" --compressed -H "Referer: https://discordapp.com/channels/$channelid" -H "Authorization: $auth" -H "Content-Type: multipart/form-data; boundary=---------------------------32345443330436" -H "Cookie: __cfduid=d7be2f6bf6a3c09f82cd952f554ea2cb31531625199" -H "DNT: 1" -H "Connection: keep-alive" -F "payload_json={\"content\":\"link file **$exportfilename** ready to fire$leftfunny$rightfunny\",\"nonce\":\"46776845$RANDOM$RANDOM$RANDOM\",\"tts\":false}" -F "filename=@$exportfilename"`
    discordlink=`echo "$response" | sed 's/,/\n/g' | grep '"attachments"' | grep '"url"' | sed 's/,/\n/g' | grep '"attachments"' | sed 's/"/\n/g' | grep 'http'`
    echo -e "your link file's link: \e[36m$discordlink\e[0m"
    echo "aria2c -x 128 -s 128 -j 128 -k 1M -R -c --auto-file-renaming=false -i $exportfilename" > direct.download.bat
    echo "aria2c -x 128 -s 128 -j 128 -k 1M -R -c --auto-file-renaming=false -i %1" > drag.list.file.and.download.bat
    rar a -ep1 -htb -m5 -ma5 -rr5 -ts -ol "/tmp/$uber.rar" "$exportfilename" "$aria2location" "direct.download.bat" "drag.list.file.and.download.bat"
    rm "direct.download.bat" "drag.list.file.and.download.bat" -f
    response=`[ "$webhookurl" ] && curl -F "payload_json={\"content\":\"über pack **$uber.rar** ready to fire$leftfunny$rightfunny\",\"username\":\"$username\",\"avatar_url\":\"$avatarurl\"}" -F "filename=@/tmp/$uber.rar" "$webhookurl" || curl "https://discordapp.com/api/v6/channels/$purechannelid/messages" -H "User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:61.0) Gecko/20100101 Firefox/61.0" -H "Accept: */*" -H "Accept-Language: en-US" --compressed -H "Referer: https://discordapp.com/channels/$channelid" -H "Authorization: $auth" -H "Content-Type: multipart/form-data; boundary=---------------------------32345443330436" -H "Cookie: __cfduid=d7be2f6bf6a3c09f82cd952f554ea2cb31531625199" -H "DNT: 1" -H "Connection: keep-alive" -F "payload_json={\"content\":\"über pack **$uber.rar** ready to fire$leftfunny$rightfunny\",\"nonce\":\"46776845$RANDOM$RANDOM$RANDOM\",\"tts\":false}" -F "filename=@/tmp/$uber.rar"`
    discordlink=`echo "$response" | sed 's/,/\n/g' | grep '"attachments"' | grep '"url"' | sed 's/,/\n/g' | grep '"attachments"' | sed 's/"/\n/g' | grep 'http'`
    echo -e "your über pack's link: \e[36m$discordlink\e[0m"
    rm "/tmp/$uber.rar" -f
fi
