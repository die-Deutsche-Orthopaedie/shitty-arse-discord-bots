#!/bin/bash
# copyrekt die deutsche Orthopädiespezialist 2020
# channel archive bot for discord, but improved
# archive a discord channel before it's deleted by its arsehole mods
# only auth are accepted, and add image re-upload feature to re-upload pics and perhaps replace pics links in original dumped messages into our repuloaded pics
# and perhaps upload via nitro account instead of webhooks or normal accounts if pics exceeded a certain size:futabruh:

function nein { # #1 = "before" message id, no if not given
    original=`curl "https://discordapp.com/api/v6/channels/$rpurechannelid/messages?limit=50" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:66.0) Gecko/20100101 Firefox/66.0" -H "Accept: */*" --compressed -H "Referer: https://discordapp.com/channels/$rchannel" -H "Authorization: $rauth" -H "DNT: 1" -H "Connection: keep-alive" -H "Cookie: __cfduid=d5654e7ddceb28663e0d4ee79adbf39e81538640920" -H "TE: Trailers"`
    
    while [ "$original" != "[]" ]
    do
        local bruh=0
        for singlemessage in `echo $original | sed 's/^\[//g' | sed 's/\]$//g' | sed 's/}, {"id":/}\n{"id":/g'`
        do
            let bruh++
            messageid=`echo $singlemessage | grep -Eo '{"id": "[0-9]*", "type"' | grep -Eo '[0-9]*'`
            echo -e "processin' messages $bruh/50, message id: \e[36m$messageid\e[0m"
            if [ `echo $singlemessage | grep -Eo '"attachments": \[.{1,}\], "embeds"'` ]
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

function archivechannel { # $1 = channel id, $2 = receiver config filename / auth, $3 = filename, $4 = troll
    if [ "$1" == "-H" ] || [ "$1" == "-h" ] || [ "$1" == "--help" ]
    then
        echo "copyrekt die deutsche Orthopädiespezialist 2020"
        echo "channel archive bot for discord, but improved"
        echo "archive a discord channel before it's deleted by its arsehole mods"
        echo
        echo "Usage: "
        echo "./repostpics.sh channel_id auth picarchive_channel_id webhookurl nitro filename [--troll]"
        echo
        echo "channel id should be <chatroom id/channel id> format"
        echo "picarchive_channel_id is the channel to reupload pics from source channel"
        echo "by default it shall use a webhook to upload smol pics, but big pics shall be uploaded by a nitro account"
        echo "if --troll is added into parameters, dumped message file would be uploaded into source channel, to mock its arsehole mod of its failure against fegelein's antics:wiebitte:"
        exit
    fi
    tmpdir="/tmp/wiebitte"
    currentdir=`pwd`
    let maxfilesize=8*1024*1024-114514 # discord's filesize limit is as barbarian as yajuu senpai, so i used 114514 to limit filesize:wiebitte:
    rchannel="$1"
    rauth="$2"
    OLD_IFS=$IFS
    IFS=$'\n'
    rpurechannelid=`echo "$rchannel" | cut -d/ -f2`
    schannel="$3"
    spurechannelid=`echo "$schannel" | cut -d/ -f2`
    swebhookurl="$4"
    sauth="$5"
    if [ "$6" ]
    then
        filename="$6"
    else
        temp=`echo "$rchannel" | sed 's/\//./g'`
        time=`date +%y.%m.%d`
        filename="$temp.$time.json"
    fi
    echo "" > "$filename"

    nein
    
    if [ "$7" == "--troll" ]
    then
        rar a -htb -m5 -ma5 -rr5 -ol -ts "/tmp/wiebitte.rar" "$filename"
        curl "https://discordapp.com/api/v6/channels/$rpurechannelid/messages" -H "User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:61.0) Gecko/20100101 Firefox/61.0" -H "Accept: */*" -H "Accept-Language: en-US" --compressed -H "Referer: https://discordapp.com/channels/$rchannel" -H "Authorization: $rauth" -H "Content-Type: multipart/form-data; boundary=---------------------------32345443330436" -H "Cookie: __cfduid=d7be2f6bf6a3c09f82cd952f554ea2cb31531625199" -H "DNT: 1" -H "Connection: keep-alive" -F "payload_json={\"content\":\"<:funny_v2_right:530321527908859907><:funny_v2_right:530321527908859907><:funny_v2_right:530321527908859907><:funny_v2_right:530321527908859907><:funny_v2_right:530321527908859907><:thonkaho_v2:575910346590781441>**a r c h i v e d**<:thonkaho_v2:575910346590781441><:funny_v2:530321446338035742><:funny_v2:530321446338035742><:funny_v2:530321446338035742><:funny_v2:530321446338035742><:funny_v2:530321446338035742>\",\"nonce\":\"46776845$RANDOM$RANDOM$RANDOM\",\"tts\":false}" -F "filename=@/tmp/wiebitte.rar"
        rm "/tmp/wiebitte.rar" -f
    fi
    
    IFS=$OLD_IFS
}

archivechannel "$@"
