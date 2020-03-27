#!/bin/bash
# copyrekt die deutsche Orthopädiespezialist 2020
# channel archive bot for discord, but fegelly improved
# archive a discord channel before it's deleted by its arsehole mods
# only auth are accepted, and add image re-upload feature to re-upload pics and perhaps replace pics links in original dumped messages into our repuloaded pics
# and perhaps upload via nitro account instead of webhooks or normal accounts if pics exceeded a certain size:futabruh:
# and now continue and incremental modes are also made and it just futabruhin' works

tmpdir="/tmp/wiebitte"
currentdir=`pwd`
let maxfilesize=8*1024*1024-114514 # discord's filesize limit is as barbarian as yajuu senpai, so i used 114514 to limit filesize:wiebitte:

function nein { # #1 = "before" message id, no if not given
    if [ "$messageid" ]
    then
        url="https://discordapp.com/api/v6/channels/$rpurechannelid/messages?before=$messageid&limit=50"
    else
        url="https://discordapp.com/api/v6/channels/$rpurechannelid/messages?limit=50"
    fi
    original=`curl "$url" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:66.0) Gecko/20100101 Firefox/66.0" -H "Accept: */*" --compressed -H "Referer: https://discordapp.com/channels/$rchannel" -H "Authorization: $rauth" -H "DNT: 1" -H "Connection: keep-alive" -H "Cookie: __cfduid=d5654e7ddceb28663e0d4ee79adbf39e81538640920" -H "TE: Trailers"`
    
    local bruh2=0
    while [ "$original" != "[]" ]
    do
        local bruh=0
        for singlemessage in `echo $original | sed 's/^\[//g' | sed 's/\]$//g' | sed 's/}, {"id":/}\n{"id":/g'`
        do
            let bruh++
            let bruh2++
            messageid=`echo $singlemessage | grep -Eo '{"id": "[0-9]*", "type"' | grep -Eo '[0-9]*'`
            if [ "$messageid" -eq "$lastmessageid" ] 
            then
                IFS=$OLD_IFS
                exit
            fi
            
            if [ "$estimation" ]
            then
                echo -e "processin' messages \e[36m$bruh\e[0m/50, outta total progress of \e[36m$bruh2\e[32m/$totalresults\e[0m, message id: \e[36m$messageid\e[0m"
            else
                echo -e "processin' messages \e[36m$bruh\e[0m/50, message id: \e[36m$messageid\e[0m"
            fi
            
            if [ `echo $singlemessage | grep -Eo '"attachments": \[.{1,}\], "embeds"'` ] && [ "$reupload" ]
            then
                attachmenturl=`echo $singlemessage | grep -Eo '"attachments": \[.{1,}\], "embeds"' | grep -Eo '"url": ".{1,}", "proxy_url"' | sed 's/"/\n/g' | grep "http"`
                attachmentproxyurl=`echo $singlemessage | grep -Eo '"attachments": \[.{1,}\], "embeds"' | grep -Eo '"proxy_url": ".{1,}"' | sed 's/"/\n/g' | grep "http"`
                echo -e "\e[36mdetected attachment, url: \e[32m$attachmenturl\e[0m"
                cd "$tmpdir"
                wget "$attachmenturl"
                for file in `ls "$tmpdir"`
                do
                    filesize=`ls -l "$tmpdir/$file" | awk '{print $5}'`
                    if [ "$filesize" -lt "$maxfilesize" ]
                    then
                        response=`curl -F "payload_json={\"content\":\"attachment for message id $messageid\",\"username\":\"kawaii yukari chan\",\"avatar_url\":\"https://cdn.discordapp.com/attachments/524633631012945922/693099262237736960/yukari_v3.png\"}" -F "filename=@$file" "$swebhookurl"`
                        sleep 2
                    else
                        echo -e "\e[33mattachment file size exceeded evil discord webhook filesize limit, would upload via nitro account\e[0m"
                        response=`curl "https://discordapp.com/api/v6/channels/$spurechannelid/messages" -H "User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:61.0) Gecko/20100101 Firefox/61.0" -H "Accept: */*" -H "Accept-Language: en-US" --compressed -H "Referer: https://discordapp.com/channels/$schannel" -H "Authorization: $sauth" -H "Content-Type: multipart/form-data; boundary=---------------------------32345443330436" -H "Cookie: __cfduid=d7be2f6bf6a3c09f82cd952f554ea2cb31531625199" -H "DNT: 1" -H "Connection: keep-alive" -F "payload_json={\"content\":\"$singlemessage\",\"tts\":false}" -F "filename=@$file"`
                        sleep 2
                    fi
                    newattachmenturl=`echo $response | grep -Eo '"attachments": \[.{1,}\], "embeds"' | grep -Eo '"url": ".{1,}", "proxy_url"' | sed 's/"/\n/g' | grep "http"`
                    echo -e "\e[36mreuploaded, new url: \e[32m$newattachmenturl\e[0m"
                    newattachmentproxyurl=`echo $response | grep -Eo '"attachments": \[.{1,}\], "embeds"' | grep -Eo '"proxy_url": ".{1,}"' | sed 's/"/\n/g' | grep "http"`
                    singlemessage=${singlemessage/$attachmenturl/$newattachmenturl}
                    singlemessage=${singlemessage/$attachmentproxyurl/$newattachmentproxyurl}
                    if [ "$store" ]
                    then
                        mv "$file" "$storelocaion/$messageid.$file"
                    fi
                done
                rm "$tmpdir"/* -f
                cd "$currentdir"
                echo "$singlemessage" >> "$filename"
                echo
            else
                echo "$singlemessage" >> "$filename"
                echo
            fi
        done
        sleep 5    
        
        original=`curl "https://discordapp.com/api/v6/channels/$rpurechannelid/messages?before=$messageid&limit=50" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:66.0) Gecko/20100101 Firefox/66.0" -H "Accept: */*" --compressed -H "Referer: https://discordapp.com/channels/$rchannel" -H "Authorization: $rauth" -H "DNT: 1" -H "Connection: keep-alive" -H "Cookie: __cfduid=d5654e7ddceb28663e0d4ee79adbf39e81538640920" -H "TE: Trailers"`
    done
}

OLD_IFS=$IFS
IFS=$'\n'

original_parameters="$0"

for parameter in "$@"
do
    original_parameters="$original_parameters '$parameter'"
done

currentdir=`pwd`
parameters=`getopt -o c:C:i:I:a:A:eEuUs:S:hH -a -l continue:,incremental:,antics:,estimation,reupload,store:help -- "$@"`

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
        -c | -C | --continue)
            messageid=`cat $2 | tail -1 | grep -Eo '{"id": "[0-9]*", "type"' | grep -Eo '[0-9]*'`
            shift 2
            ;;
        -i | -I | --incremental)
            lastmessageid=`cat $2 | head -1 | grep -Eo '{"id": "[0-9]*", "type"' | grep -Eo '[0-9]*'`
            shift 2
            ;;
        -a | -A | --antics)
            antics="JAJAJAJAJA"
            rarfilename="$2"
            shift 2
            ;;
        -e | -E | --estimation)
            estimation="JAJAJAJAJA"
            shift
            ;;
        -u | -U | --reupload)
            reupload="JAJAJAJAJA"
            shift
            ;;
        -s | -S | --store)
            store="JAJAJAJAJA"
            storelocaion="$2"
            shift 2
            ;;
        -h | -H | --help)
            echo "copyrekt die deutsche Orthopädiespezialist 2020"
            echo "channel archive bot for discord, but improved"
            echo "archive a discord channel before it's deleted by its arsehole mods"
            echo
            echo "Usage: "
            echo "./repostpics.sh [options] channel_id auth filename [picarchive_channel_id] [webhookurl] [nitro] "
            echo
            echo "Options: "
            echo "  -c or -C or --continue <filename>: read message id from the last line of an existing archive file, and continue dumpin' from there"
            echo "  -i or -I or --incremental <filename>: read message id from the first line of an existing archive file, and dump from the latest message to there"
            echo "    in both cases newer dumps would be stored in a new file, you can use any file merge commands to merge them"
            echo "  -a or -A or --antics <rarfilename>: compress and upload dumped message file right into source channel to furtherly humiliate its arsehole mod of its failure against fegelein's antics:wiebitte:"
            echo "  -e or -E or --estimation: use discord search feature to estimate how many posts source channel have"
            echo "  -u or -U or --reupload: reupload attachments in source channel into another channel given"
            echo "    -s or -S or --store <location>: downloaded attachments would be renamed and stored into local folder instead of bein' deleted"
            echo
            echo "channel id should be <chatroom id/channel id> format"
            echo "picarchive_channel_id is the channel to reupload pics from source channel"
            echo "by default it shall use a webhook to upload smol pics, but big pics shall be uploaded by a nitro account"
            exit
            shift
            ;;
        --)
            if [ "$antics" ]
            then
                rchannel="$2"
                rauth="$3"
                rpurechannelid=`echo "$rchannel" | cut -d/ -f2`
                filename="$4"
                rm "$tmpdir"/* -f
                rar a -v8M -htb -m5 -ma5 -rr5 -ol -ts "$tmpdir/$rarfilename.rar" "$filename"
                for file in `ls $tmpdir`
                do
                    curl "https://discordapp.com/api/v6/channels/$rpurechannelid/messages" -H "User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:61.0) Gecko/20100101 Firefox/61.0" -H "Accept: */*" -H "Accept-Language: en-US" --compressed -H "Referer: https://discordapp.com/channels/$rchannel" -H "Authorization: $rauth" -H "Content-Type: multipart/form-data; boundary=---------------------------32345443330436" -H "Cookie: __cfduid=d7be2f6bf6a3c09f82cd952f554ea2cb31531625199" -H "DNT: 1" -H "Connection: keep-alive" -F "payload_json={\"content\":\"<:funny_v2_right:530321527908859907><:funny_v2_right:530321527908859907><:funny_v2_right:530321527908859907><:funny_v2_right:530321527908859907><:funny_v2_right:530321527908859907><:thonkaho_v2:575910346590781441>**a r c h i v e d**<:thonkaho_v2:575910346590781441><:funny_v2:530321446338035742><:funny_v2:530321446338035742><:funny_v2:530321446338035742><:funny_v2:530321446338035742><:funny_v2:530321446338035742>\",\"nonce\":\"46776845$RANDOM$RANDOM$RANDOM\",\"tts\":false}" -F "filename=@$tmpdir/$file"
                done
                rm "$tmpdir"/* -f
                exit
            else
                if [ "$reupload" ]
                then
                    rchannel="$2"
                    rauth="$3"
                    rpurechannelid=`echo "$rchannel" | cut -d/ -f2`
                    schannel="$4"
                    spurechannelid=`echo "$schannel" | cut -d/ -f2`
                    swebhookurl="$5"
                    sauth="$6"
                    if [ "$7" ]
                    then
                        filename="$7"
                    else
                        temp=`echo "$rchannel" | sed 's/\//./g'`
                        time=`date +%y.%m.%d`
                        filename="$temp.$time.json"
                    fi
                    break
                else
                    rchannel="$2"
                    rauth="$3"
                    rpurechannelid=`echo "$rchannel" | cut -d/ -f2`
                    if [ "$4" ]
                    then
                        filename="$4"
                    else
                        temp=`echo "$rchannel" | sed 's/\//./g'`
                        time=`date +%y.%m.%d`
                        filename="$temp.$time.json"
                    fi
                    break
                fi
                if [ "$estimation" ]
                then
                    rguildid=`echo "$rchannel" | cut -d/ -f1`
                    totalresults=`curl "https://discordapp.com/api/v6/guilds/$rguildid/messages/search?channel_id=$rpurechannelid" -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:74.0) Gecko/20100101 Firefox/74.0' -H 'Accept: */*' -H 'Accept-Language: en-US' --compressed -H "Authorization: $rauth" -H 'Connection: keep-alive' -H "Referer: https://discordapp.com/channels/$rchannel" -H 'Cookie: __cfduid=d440293169c3730ee2beff170518c1cb31565407611; locale=en-US; __cfruid=cd69440a7f7f42175065bc6d8aaeaf9e61ec8171-1585334844' -H 'TE: Trailers' | grep -Eo '"total_results": [0-9]*,' | grep -Eo "[0-9]*"`
                fi
            fi
            ;;
        *)
            echo "Internal error!"
            exit 255
            ;;
    esac
done

if [ "$messageid" ] && [ "$lastmessageid" ]
then
    echo "Houston, we have an arsefockin' problem: continue mode and incremental mode can't be used together:bruhsette:" >&2
    exit 2
fi

if [ ! "$lastmessageid" ]
then
    lastmessageid=0
fi

if [ ! "$reupload" ] && [ "$store" ]
then
    echo "Houston, we have an arsefockin' problem: no file to store if they're not donwloaded first:bruhsette:" >&2
    exit 3
fi

nein

IFS=$OLD_IFS
