#!/bin/bash
# copyrekt die deutsche Orthopädiespezialist 201⑨
# pic repost bot for discord
# get all pics from one discord channel and repost them to another channel
# receiver account and transmitter account could be different
# both futaba.sh config file and auth are accepted, default = futaba.sh config file, add --auth before usin' auth

function getmessages { # $1 =  channel id 449411937055277066/565918501114740747
    curl "https://discordapp.com/api/v6/channels/`echo "$1" | cut -d/ -f2`/messages?limit=100" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:66.0) Gecko/20100101 Firefox/66.0" -H "Accept: */*" --compressed -H "Referer: https://discordapp.com/channels/$1" -H "Authorization: $auth" -H "DNT: 1" -H "Connection: keep-alive" -H "Cookie: __cfduid=d5654e7ddceb28663e0d4ee79adbf39e81538640920" -H "TE: Trailers" | sed 's/,/\n/g' | grep '"url"' | sed 's/"/\n/g' | grep 'http' # only 100 max, might need a way to discover the 100th message's id
}

function getmessages_v2 { # $1 =  channel id, $2 = config filename
    OLD_IFS=$IFS
    IFS=$'\n'
    purechannelid=`echo "$1" | cut -d/ -f2`
    auth=`cat "$2" | grep '"Authorization: ' | head -1 | sed 's/"/\n/g' | grep "Authorization: " | sed 's/Authorization: //g'`
    original=`curl "https://discordapp.com/api/v6/channels/$purechannelid/messages?limit=100" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:66.0) Gecko/20100101 Firefox/66.0" -H "Accept: */*" --compressed -H "Referer: https://discordapp.com/channels/$1" -H "Authorization: $auth" -H "DNT: 1" -H "Connection: keep-alive" -H "Cookie: __cfduid=d5654e7ddceb28663e0d4ee79adbf39e81538640920" -H "TE: Trailers"`
    for messages in `echo "$original" | sed 's/"type": [0-9]*}, {"attachments"/"type": "nein"}, \n\n{"attachments"/g'`
    do
        messageid=`echo "$messages" | sed 's/"author"/\n"author"/g' | sed 's/"mention_everyone"/\n"mention_everyone"/g' | grep '"mention_everyone"' | sed 's/,/\n/g' | grep '"id"' | sed 's/"/\n/g' | grep -Eo '[0-9]*'` 
        if [ `echo "$messages" | sed 's/,/\n/g' | grep '"attachments"' | grep '"url"'` ]
        then
            # echo -e "\e[36m$messageid\e[0m"
            echo "$messages" | sed 's/,/\n/g' | grep '"attachments"' | sed 's/"/\n/g' | grep 'http'
            # echo
        elif [ `echo "$messages" | sed 's/,/\n/g' | grep '"embeds"' | grep '"url"'` ]
        then
            # echo "$messages" | sed 's/,/\n/g' | grep '"embeds"' | sed 's/"/\n/g' | grep 'http' # only for single embeds
            # echo -e "\e[36m$messageid\e[0m"
            echo "$messages" | grep -Eo '"embeds": \[.*\], "timestamp"' | sed 's/}, {/}, \n{/g' | sed 's/,/\n/g' | grep '"thumbnail"' | sed 's/"/\n/g' | grep 'http' # embeds might have more than one, so must use context-based mathod to extract them, s0rry
            # echo
        fi
    done
    
    while [ "$messageid" ]
    do
        # echo
        # echo -e "\e[36ms w a p p a g e, $messageid\e[0m" 
        original=`curl "https://discordapp.com/api/v6/channels/$purechannelid/messages?before=$messageid&limit=100" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:66.0) Gecko/20100101 Firefox/66.0" -H "Accept: */*" --compressed -H "Referer: https://discordapp.com/channels/$1" -H "Authorization: $auth" -H "DNT: 1" -H "Connection: keep-alive" -H "Cookie: __cfduid=d5654e7ddceb28663e0d4ee79adbf39e81538640920" -H "TE: Trailers"`
        for messages in `echo "$original" | sed 's/"type": [0-9]*}, {"attachments"/"type": "nein"}, \n\n{"attachments"/g'`
        do
            messageid=`echo "$messages" | sed 's/"author"/\n"author"/g' | sed 's/"mention_everyone"/\n"mention_everyone"/g' | grep '"mention_everyone"' | sed 's/,/\n/g' | grep '"id"' | sed 's/"/\n/g' | grep -Eo '[0-9]*'` 
            if [ `echo "$messages" | sed 's/,/\n/g' | grep '"attachments"' | grep '"url"'` ]
            then
                # echo -e "\e[36m$messageid\e[0m"
                echo "$messages" | sed 's/,/\n/g' | grep '"attachments"' | sed 's/"/\n/g' | grep 'http'
                # echo
            elif [ `echo "$messages" | sed 's/,/\n/g' | grep '"embeds"' | grep '"url"'` ]
            then
                # echo "$messages" | sed 's/,/\n/g' | grep '"embeds"' | sed 's/"/\n/g' | grep 'http' 
                # echo -e "\e[36m$messageid\e[0m"
                echo "$messages" | grep -Eo '"embeds": \[.*\], "timestamp"' | sed 's/}, {/}, \n{/g' | sed 's/,/\n/g' | grep '"thumbnail"' | sed 's/"/\n/g' | grep 'http' # embeds might have more than one, so must use context-based mathod to extract them, s0rry
                # echo
            fi
        done
    done
    IFS=$OLD_IFS
}
# getmessages_v2 449411937055277066/565918501114740747
# getmessages_v2 449411937055277066/449412366237564929
# getmessages_v2 449411937055277066/565918501114740747

function repostpics { # $1 = channel id, $2 = new channel id, $3 = config filename, $4 = delimiter
    mcount=0
    combined=`echo ""`
    if [ "$4" ]
    then
        delimiter="$4"
    else
        delimiter=4
    fi
    for messages in `getmessages_v2 $1`
    do
        let mcount++
        case $(($mcount%$delimiter)) in
            0)
                combined=${combined}${messages}
                # echo $mcount
                # echo "$combined"
                # echo
                ./futaba.sh -N -c "$3" --channel-id "$2" -M "$combined"
                combined=`echo ""`
                ;;
            *)
                combined=${combined}${messages}" "
                # echo $mcount
                # echo "$combined"
                # echo
        esac
    done
    [ $(($mcount%$delimiter)) -eq 0 ] || ./futaba.sh -N -c "$3" --channel-id "$2" -M "$combined"
}
 
function repostpics_v2 { # $1 = channel id, $2 = new channel id, $3 = receiver config filename / auth, $4 = transmitter config filename / auth, $5 = delimiter
    if [ "$1" == "-H" ] || [ "$1" == "-h" ] || [ "$1" == "--help" ]
    then
        echo "copyrekt die deutsche Orthopädiespezialist 201⑨"
        echo "pic repost bot for discord"
        echo "get all pics from one discord channel and repost them to another channel"
        echo
        echo "Usage: "
        echo "./repostpics.sh source_channel_id dest_channel_id [--auth] receiver_config_filename/auth [--auth] transmitter_config_filename/auth [delimiter]"
        echo
        echo "source and dest channel id should be <chatroom id/channel id> format"
        echo "without --auth it uses futaba.sh config file to get auth; add --auth before usin' auth directly"
        echo "delimiter: the amount of pics it sends in one message, default value is 4, max 5"
        exit
    fi
    mcount=0
    combined=`echo ""`
    rchannel="$1"
    tchannel="$2"
    if [ "$3" == "--auth" ]
    then
        rauth="$4"
        shift
    else
        rconf="$3"
        rauth=`cat "$rconf" | grep '"Authorization: ' | head -1 | sed 's/"/\n/g' | grep "Authorization: " | sed 's/Authorization: //g'`
    fi
    if [ "$4" == "--auth" ]
    then
        tauth="$5"
        shift
    else
        tconf="$4"
        tauth=`cat "$tconf" | grep '"Authorization: ' | head -1 | sed 's/"/\n/g' | grep "Authorization: " | sed 's/Authorization: //g'`
    fi
    if [ "$5" ]
    then
        delimiter="$5"
    else
        delimiter=4
    fi
    OLD_IFS=$IFS
    IFS=$'\n'
    rpurechannelid=`echo "$rchannel" | cut -d/ -f2`
    tpurechannelid=`echo "$tchannel" | cut -d/ -f2`
    
    original=`curl "https://discordapp.com/api/v6/channels/$rpurechannelid/messages?limit=100" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:66.0) Gecko/20100101 Firefox/66.0" -H "Accept: */*" --compressed -H "Referer: https://discordapp.com/channels/$rchannel" -H "Authorization: $auth" -H "DNT: 1" -H "Connection: keep-alive" -H "Cookie: __cfduid=d5654e7ddceb28663e0d4ee79adbf39e81538640920" -H "TE: Trailers"`
    messages2=$(for messages in `echo "$original" | sed 's/"type": [0-9]*}, {"attachments"/"type": "nein"}, \n\n{"attachments"/g'`
    do
        messageid=`echo "$messages" | sed 's/"author"/\n"author"/g' | sed 's/"mention_everyone"/\n"mention_everyone"/g' | grep '"mention_everyone"' | sed 's/,/\n/g' | grep '"id"' | sed 's/"/\n/g' | grep -Eo '[0-9]*'` 
        echo "$messageid" > /tmp/messageid
        if [ `echo "$messages" | sed 's/,/\n/g' | grep '"attachments"' | grep '"url"'` ]
        then
            # echo -e "\e[36m$messageid\e[0m"
            echo "$messages" | sed 's/,/\n/g' | grep '"attachments"' | sed 's/"/\n/g' | grep 'http'
            # echo
        elif [ `echo "$messages" | sed 's/,/\n/g' | grep '"embeds"' | grep '"url"'` ]
        then
            # echo "$messages" | sed 's/,/\n/g' | grep '"embeds"' | sed 's/"/\n/g' | grep 'http' # only for single embeds
            # echo -e "\e[36m$messageid\e[0m"
            echo "$messages" | grep -Eo '"embeds": \[.*\], "timestamp"' | sed 's/}, {/}, \n{/g' | sed 's/,/\n/g' | grep '"thumbnail"' | sed 's/"/\n/g' | grep 'http' # embeds might have more than one, so must use context-based mathod to extract them, s0rry
            # echo
        fi
    done)
    # mcount=0
    for pic in `echo "$messages2"`
    do
        let mcount++
        case $(($mcount%$delimiter)) in
            0)
                combined=${combined}${pic}
                # echo $mcount
                # echo "$combined"
                # echo
                # ./futaba.sh -N -c "$tconf" --channel-id "$tchannel" -M "$combined"
                curl "https://discordapp.com/api/v6/channels/$tpurechannelid/messages" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:64.0) Gecko/20100101 Firefox/64.0" -H "Accept: */*" --compressed -H "Referer: https://discordapp.com/channels/$tchannel" -H "Content-Type: application/json" -H "Authorization: $tauth" -H "DNT: 1" -H "Connection: keep-alive" -H "Cookie: __cfduid=dcd1664bb4ff31505860e60c383226c1e1546910522" -H "TE: Trailers" --data "{\"content\":\"$combined\",\"nonce\":\"52614265$RANDOM$RANDOM$RANDOM\",\"tts\":false}";
                sleep 2
                combined=`echo ""`
                ;;
            *)
                combined=${combined}${pic}" "
                # echo $mcount
                # echo "$combined"
                # echo
        esac
    done
    # [ $(($mcount%$delimiter)) -eq 0 ] || ./futaba.sh -N -c "$tconf" --channel-id "$2" -M "$combined"
    # [ $(($mcount%$delimiter)) -eq 0 ] || curl "https://discordapp.com/api/v6/channels/$tpurechannelid/messages" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:64.0) Gecko/20100101 Firefox/64.0" -H "Accept: */*" --compressed -H "Referer: https://discordapp.com/channels/$tchannel" -H "Content-Type: application/json" -H "Authorization: $tauth" -H "DNT: 1" -H "Connection: keep-alive" -H "Cookie: __cfduid=dcd1664bb4ff31505860e60c383226c1e1546910522" -H "TE: Trailers" --data "{\"content\":\"$combined\",\"nonce\":\"52614265$RANDOM$RANDOM$RANDOM\",\"tts\":false}";
    # combined=`echo ""`
    
    messageid=`cat /tmp/messageid`
    while [ "$messageid" ]
    do
        # echo
        # echo -e "\e[36ms w a p p a g e, $messageid\e[0m" 
        original=`curl "https://discordapp.com/api/v6/channels/$rpurechannelid/messages?before=$messageid&limit=100" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:66.0) Gecko/20100101 Firefox/66.0" -H "Accept: */*" --compressed -H "Referer: https://discordapp.com/channels/$rchannel" -H "Authorization: $auth" -H "DNT: 1" -H "Connection: keep-alive" -H "Cookie: __cfduid=d5654e7ddceb28663e0d4ee79adbf39e81538640920" -H "TE: Trailers"`
        messages2=$(for messages in `echo "$original" | sed 's/"type": [0-9]*}, {"attachments"/"type": "nein"}, \n\n{"attachments"/g'`
        do
            messageid=`echo "$messages" | sed 's/"author"/\n"author"/g' | sed 's/"mention_everyone"/\n"mention_everyone"/g' | grep '"mention_everyone"' | sed 's/,/\n/g' | grep '"id"' | sed 's/"/\n/g' | grep -Eo '[0-9]*'`
            echo "$messageid" > /tmp/messageid
            if [ `echo "$messages" | sed 's/,/\n/g' | grep '"attachments"' | grep '"url"'` ]
            then
                # echo -e "\e[36m$messageid\e[0m"
                echo "$messages" | sed 's/,/\n/g' | grep '"attachments"' | sed 's/"/\n/g' | grep 'http'
                # echo
            elif [ `echo "$messages" | sed 's/,/\n/g' | grep '"embeds"' | grep '"url"'` ]
            then
                # echo "$messages" | sed 's/,/\n/g' | grep '"embeds"' | sed 's/"/\n/g' | grep 'http' 
                # echo -e "\e[36m$messageid\e[0m"
                echo "$messages" | grep -Eo '"embeds": \[.*\], "timestamp"' | sed 's/}, {/}, \n{/g' | sed 's/,/\n/g' | grep '"thumbnail"' | sed 's/"/\n/g' | grep 'http' # embeds might have more than one, so must use context-based mathod to extract them, s0rry
                # echo
            fi
        done)
        # mcount=0
        for pic in `echo "$messages2"`
        do
            let mcount++
            case $(($mcount%$delimiter)) in
                0)
                    combined=${combined}${pic}
                    # echo $mcount
                    # echo "$combined"
                    # echo
                    # ./futaba.sh -N -c "$tconf" --channel-id "$tchannel" -M "$combined"
                    curl "https://discordapp.com/api/v6/channels/$tpurechannelid/messages" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:64.0) Gecko/20100101 Firefox/64.0" -H "Accept: */*" --compressed -H "Referer: https://discordapp.com/channels/$tchannel" -H "Content-Type: application/json" -H "Authorization: $tauth" -H "DNT: 1" -H "Connection: keep-alive" -H "Cookie: __cfduid=dcd1664bb4ff31505860e60c383226c1e1546910522" -H "TE: Trailers" --data "{\"content\":\"$combined\",\"nonce\":\"52614265$RANDOM$RANDOM$RANDOM\",\"tts\":false}";
                    sleep 2
                    combined=`echo ""`
                    ;;
                *)
                    combined=${combined}${pic}" "
                    # echo $mcount
                    # echo "$combined"
                    # echo
            esac
        done
        # [ $(($mcount%$delimiter)) -eq 0 ] || ./futaba.sh -N -c "$tconf" --channel-id "$2" -M "$combined"
        # [ $(($mcount%$delimiter)) -eq 0 ] || curl "https://discordapp.com/api/v6/channels/$tpurechannelid/messages" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:64.0) Gecko/20100101 Firefox/64.0" -H "Accept: */*" --compressed -H "Referer: https://discordapp.com/channels/$tchannel" -H "Content-Type: application/json" -H "Authorization: $tauth" -H "DNT: 1" -H "Connection: keep-alive" -H "Cookie: __cfduid=dcd1664bb4ff31505860e60c383226c1e1546910522" -H "TE: Trailers" --data "{\"content\":\"$combined\",\"nonce\":\"52614265$RANDOM$RANDOM$RANDOM\",\"tts\":false}";
        # combined=`echo ""`
        messageid=`cat /tmp/messageid`
    done
    # [ $(($mcount%$delimiter)) -eq 0 ] || ./futaba.sh -N -c "$tconf" --channel-id "$tchannel" -M "$combined"
    [ $(($mcount%$delimiter)) -eq 0 ] || curl "https://discordapp.com/api/v6/channels/$tpurechannelid/messages" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:64.0) Gecko/20100101 Firefox/64.0" -H "Accept: */*" --compressed -H "Referer: https://discordapp.com/channels/$tchannel" -H "Content-Type: application/json" -H "Authorization: $tauth" -H "DNT: 1" -H "Connection: keep-alive" -H "Cookie: __cfduid=dcd1664bb4ff31505860e60c383226c1e1546910522" -H "TE: Trailers" --data "{\"content\":\"$combined\",\"nonce\":\"52614265$RANDOM$RANDOM$RANDOM\",\"tts\":false}";
    
    IFS=$OLD_IFS
}

function nein { # #1 = "before" message id, no if not given
    if [ "$1" ]
    then
        url="https://discordapp.com/api/v6/channels/$rpurechannelid/messages?before=$1&limit=100"
    else
        url="https://discordapp.com/api/v6/channels/$rpurechannelid/messages?limit=100"
    fi
    original=`curl "$url" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:66.0) Gecko/20100101 Firefox/66.0" -H "Accept: */*" --compressed -H "Referer: https://discordapp.com/channels/$rchannel" -H "Authorization: $rauth" -H "DNT: 1" -H "Connection: keep-alive" -H "Cookie: __cfduid=d5654e7ddceb28663e0d4ee79adbf39e81538640920" -H "TE: Trailers"`
    messages2=$(for messages in `echo "$original" | sed 's/"type": [0-9]*}, {"attachments"/"type": "nein"}, \n\n{"attachments"/g'`
    do
        messageid=`echo "$messages" | sed 's/"author"/\n"author"/g' | sed 's/"mention_everyone"/\n"mention_everyone"/g' | grep '"mention_everyone"' | sed 's/,/\n/g' | grep '"id"' | sed 's/"/\n/g' | grep -Eo '[0-9]*'` 
        echo "$messageid" > /tmp/messageid
        if [ `echo "$messages" | sed 's/,/\n/g' | grep '"attachments"' | grep '"url"'` ]
        then
            # echo -e "\e[36m$messageid\e[0m"
            echo "$messages" | sed 's/,/\n/g' | grep '"attachments"' | sed 's/"/\n/g' | grep 'http'
            # echo
        elif [ `echo "$messages" | sed 's/,/\n/g' | grep '"embeds"' | grep '"url"'` ]
        then
            # echo "$messages" | sed 's/,/\n/g' | grep '"embeds"' | sed 's/"/\n/g' | grep 'http' # only for single embeds
            # echo -e "\e[36m$messageid\e[0m"
            echo "$messages" | grep -Eo '"embeds": \[.*\], "timestamp"' | sed 's/}, {/}, \n{/g' | sed 's/,/\n/g' | grep '"thumbnail"' | sed 's/"/\n/g' | grep 'http' # embeds might have more than one, so must use context-based mathod to extract them, s0rry
            # echo
        fi
    done)
    # mcount=0
    for pic in `echo "$messages2"`
    do
        let mcount++
        case $(($mcount%$delimiter)) in
            0)
                combined=${combined}${pic}
                # echo $mcount
                # echo "$combined"
                # echo
                # ./futaba.sh -N -c "$tconf" --channel-id "$tchannel" -M "$combined"
                curl "https://discordapp.com/api/v6/channels/$tpurechannelid/messages" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:64.0) Gecko/20100101 Firefox/64.0" -H "Accept: */*" --compressed -H "Referer: https://discordapp.com/channels/$tchannel" -H "Content-Type: application/json" -H "Authorization: $tauth" -H "DNT: 1" -H "Connection: keep-alive" -H "Cookie: __cfduid=dcd1664bb4ff31505860e60c383226c1e1546910522" -H "TE: Trailers" --data "{\"content\":\"$combined\",\"nonce\":\"52614265$RANDOM$RANDOM$RANDOM\",\"tts\":false}";
                sleep 2
                combined=`echo ""`
                ;;
            *)
                combined=${combined}${pic}" "
                # echo $mcount
                # echo "$combined"
                # echo
        esac
    done
    # [ $(($mcount%$delimiter)) -eq 0 ] || ./futaba.sh -N -c "$tconf" --channel-id "$2" -M "$combined"
    # [ $(($mcount%$delimiter)) -eq 0 ] || curl "https://discordapp.com/api/v6/channels/$tpurechannelid/messages" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:64.0) Gecko/20100101 Firefox/64.0" -H "Accept: */*" --compressed -H "Referer: https://discordapp.com/channels/$tchannel" -H "Content-Type: application/json" -H "Authorization: $tauth" -H "DNT: 1" -H "Connection: keep-alive" -H "Cookie: __cfduid=dcd1664bb4ff31505860e60c383226c1e1546910522" -H "TE: Trailers" --data "{\"content\":\"$combined\",\"nonce\":\"52614265$RANDOM$RANDOM$RANDOM\",\"tts\":false}";
    # combined=`echo ""`
}

function repostpics_v3 { # $1 = channel id, $2 = new channel id, $3 = receiver config filename / auth, $4 = transmitter config filename / auth, $5 = delimiter
    if [ "$1" == "-H" ] || [ "$1" == "-h" ] || [ "$1" == "--help" ]
    then
        echo "copyrekt die deutsche Orthopädiespezialist 201⑨"
        echo "pic repost bot for discord"
        echo "get all pics from one discord channel and repost them to another channel"
        echo
        echo "Usage: "
        echo "./repostpics.sh source_channel_id dest_channel_id [--auth] receiver_config_filename/auth [--auth] transmitter_config_filename/auth [delimiter]"
        echo
        echo "source and dest channel id should be <chatroom id/channel id> format"
        echo "without --auth it uses futaba.sh config file to get auth; add --auth before usin' auth directly"
        echo "delimiter: the amount of pics it sends in one message, default value is 4, max 5"
        exit
    fi
    mcount=0
    combined=`echo ""`
    rchannel="$1"
    tchannel="$2"
    if [ "$3" == "--auth" ]
    then
        rauth="$4"
        shift
    else
        rconf="$3"
        rauth=`cat "$rconf" | grep '"Authorization: ' | head -1 | sed 's/"/\n/g' | grep "Authorization: " | sed 's/Authorization: //g'`
    fi
    if [ "$4" == "--auth" ]
    then
        tauth="$5"
        shift
    else
        tconf="$4"
        tauth=`cat "$tconf" | grep '"Authorization: ' | head -1 | sed 's/"/\n/g' | grep "Authorization: " | sed 's/Authorization: //g'`
    fi
    if [ "$5" ]
    then
        delimiter="$5"
    else
        delimiter=4
    fi
    OLD_IFS=$IFS
    IFS=$'\n'
    rpurechannelid=`echo "$rchannel" | cut -d/ -f2`
    tpurechannelid=`echo "$tchannel" | cut -d/ -f2`

    nein
    
    messageid=`cat /tmp/messageid`
    while [ "$messageid" ]
    do
        nein "$messageid"
        messageid=`cat /tmp/messageid`
    done
    # [ $(($mcount%$delimiter)) -eq 0 ] || ./futaba.sh -N -c "$tconf" --channel-id "$tchannel" -M "$combined"
    [ $(($mcount%$delimiter)) -eq 0 ] || curl "https://discordapp.com/api/v6/channels/$tpurechannelid/messages" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:64.0) Gecko/20100101 Firefox/64.0" -H "Accept: */*" --compressed -H "Referer: https://discordapp.com/channels/$tchannel" -H "Content-Type: application/json" -H "Authorization: $tauth" -H "DNT: 1" -H "Connection: keep-alive" -H "Cookie: __cfduid=dcd1664bb4ff31505860e60c383226c1e1546910522" -H "TE: Trailers" --data "{\"content\":\"$combined\",\"nonce\":\"52614265$RANDOM$RANDOM$RANDOM\",\"tts\":false}";
    
    IFS=$OLD_IFS
}

repostpics_v3 "$@"
