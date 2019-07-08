#!/bin/bash
# copyrekt die deutsche Orthopädiespezialist 201⑨
# channel archive bot for discord
# archive a discord channel before it's deleted by its arsehole mods
# both futaba.sh config file and auth are accepted, default = futaba.sh config file, add --auth before usin' auth

function nein { # #1 = "before" message id, no if not given
    if [ "$1" ]
    then
        url="https://discordapp.com/api/v6/channels/$rpurechannelid/messages?before=$1&limit=50"
    else
        url="https://discordapp.com/api/v6/channels/$rpurechannelid/messages?limit=50"
    fi
    original=`curl "$url" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:66.0) Gecko/20100101 Firefox/66.0" -H "Accept: */*" --compressed -H "Referer: https://discordapp.com/channels/$rchannel" -H "Authorization: $rauth" -H "DNT: 1" -H "Connection: keep-alive" -H "Cookie: __cfduid=d5654e7ddceb28663e0d4ee79adbf39e81538640920" -H "TE: Trailers"`
    echo "$original" >> "$filename"
    echo "$original" | sed 's/"type": [0-9]*}, {"attachments"/"type": "nein"}, \n\n{"attachments"/g' | sed 's/"author"/\n"author"/g' | sed 's/"mention_everyone"/\n"mention_everyone"/g' | grep '"mention_everyone"' | sed 's/,/\n/g' | grep '"id"' | sed 's/"/\n/g' | grep -Eo '[0-9]*' | tail -1 > /tmp/messageid
}

function archivechannel { # $1 = channel id, $2 = receiver config filename / auth, $3 = filename, $4 = troll
    if [ "$1" == "-H" ] || [ "$1" == "-h" ] || [ "$1" == "--help" ]
    then
        echo "copyrekt die deutsche Orthopädiespezialist 201⑨"
        echo "channel archive bot for discord"
        echo "archive a discord channel before it's deleted by its arsehole mods"
        echo
        echo "Usage: "
        echo "./repostpics.sh channel_id [--auth] receiver_config_filename/auth filename"
        echo
        echo "channel id should be <chatroom id/channel id> format"
        echo "without --auth it uses futaba.sh config file to get auth; add --auth before usin' auth directly"
        exit
    fi
    rchannel="$1"
    if [ "$2" == "--auth" ]
    then
        rauth="$2"
        shift
    else
        rconf="$2"
        rauth=`cat "$rconf" | grep '"Authorization: ' | head -1 | sed 's/"/\n/g' | grep "Authorization: " | sed 's/Authorization: //g'`
    fi
    OLD_IFS=$IFS
    IFS=$'\n'
    rpurechannelid=`echo "$rchannel" | cut -d/ -f2`
    if [ "$3" ]
    then
        filename="$3"
    else
        temp=`echo "$rchannel" | sed 's/\//./g'`
        time=`date +%y.%m.%d`
        filename="$temp.$time.json"
    fi

    nein
    
    messageid=`cat /tmp/messageid`
    while [ "$messageid" ]
    do
        nein "$messageid"
        messageid=`cat /tmp/messageid`
    done
    
    IFS=$OLD_IFS
    
    if [ "$4" == "--troll" ]
    then
        curl "https://discordapp.com/api/v6/channels/$rpurechannelid/messages" -H "User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:61.0) Gecko/20100101 Firefox/61.0" -H "Accept: */*" -H "Accept-Language: en-US" --compressed -H "Referer: https://discordapp.com/channels/$rchannel" -H "Authorization: $rauth" -H "Content-Type: multipart/form-data; boundary=---------------------------32345443330436" -H "Cookie: __cfduid=d7be2f6bf6a3c09f82cd952f554ea2cb31531625199" -H "DNT: 1" -H "Connection: keep-alive" -F "payload_json={\"content\":\"<:funny_v2_right:530321527908859907><:funny_v2_right:530321527908859907><:funny_v2_right:530321527908859907><:funny_v2_right:530321527908859907><:funny_v2_right:530321527908859907><:thonkaho_v2:575910346590781441>**a r c h i v e d**<:thonkaho_v2:575910346590781441><:funny_v2:530321446338035742><:funny_v2:530321446338035742><:funny_v2:530321446338035742><:funny_v2:530321446338035742><:funny_v2:530321446338035742>\",\"nonce\":\"46776845$RANDOM$RANDOM$RANDOM\",\"tts\":false}" -F "filename=@$filename"
    fi
}

archivechannel "$@"
