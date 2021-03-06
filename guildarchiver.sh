#!/bin/bash
# copyrekt die deutsche Orthopädiespezialist 2020
# a fegelscript to get metadata of a guild and automatically analyze which channels can be dumped and generate sh files to call archivechannels.v5.sh to do the channel archivin' jobs

# constants
function acp {
    archivechannelsparameters="/path/to/your/archivechannels.v5.sh -E -m -o \"$sourceguildid/[insert_channel_id_here]\" \"$sourceauth\" /path/to/your/conf/file.conf \"$guildfilename.[insert_channel_name_here].$(date +%y.%m.%d).json\"" # just an example, you need to change it to fit your own needs
    threshold=20
}

function sourceguilddump {
    # dump source guild's metadata
    curl "https://discordapp.com/api/v6/guilds/$sourceguildid" -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:75.0) Gecko/20100101 Firefox/75.0' -H 'Accept: */*' -H 'Accept-Language: en-US' --compressed -H "Authorization: $sourceauth" -H 'Connection: keep-alive' -H "Referer: https://discordapp.com/channels/$sourceguildid" -H 'Cookie: __cfduid=d5cbe884783a0de963fc8d759dc20bac81584154417; locale=en-US; __cfruid=fbb94801fd7711173f37ee00dc0c71986d86f1c1-1586022016' -H 'TE: Trailers' > "bruh.metadata.json"
    guildid=`cat bruh.metadata.json | grep -Po '^{"id": "[0-9]*", ' | sed 's/^{"id": "\([0-9]*\)", /\1/g'`
    [ "$guildfilename" ] || guildfilename=`cat bruh.metadata.json | grep -Po '^{"id": "[0-9]*", "name": ".*?", ' | sed 's/^{"id": "[0-9]*", "name": "\(.*\)", /\1/g'`
    mv "bruh.metadata.json" "$guildfilename.metadata.json"
    
    # dump source guild's channel data
    curl "https://discordapp.com/api/v6/guilds/$sourceguildid/channels" -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:75.0) Gecko/20100101 Firefox/75.0' -H 'Accept: */*' -H 'Accept-Language: en-US' --compressed -H "Authorization: $sourceauth" -H 'Connection: keep-alive' -H "Referer: https://discordapp.com/channels/$sourceguildid" -H 'Cookie: __cfduid=d5cbe884783a0de963fc8d759dc20bac81584154417; locale=en-US; __cfruid=fbb94801fd7711173f37ee00dc0c71986d86f1c1-1586022016' -H 'TE: Trailers' > "$guildfilename.channels.json"
}

function processchannels {
    for channel in `cat "$guildfilename.channels.json" | sed 's/^\[//g' | sed 's/\]$//g' | sed 's/\]$//g' | sed 's/}, {"id": "\([0-9]*\)", "last_message_id"/}\n{"id": "\1", "last_message_id"/g' | sed 's/}, {"id": "\([0-9]*\)", "type": \([0-9]\)/}\n{"id": "\1", "type": \2/g'`
    do
        type=`echo $channel | grep -Eo '"type": [0-9]*' | grep -Eo "[0-9]*"`
        if [ "$type" == "0" ]
        then
            id=`echo $channel | grep -Eo '"id".*"name"' | grep -Eo '"id": "[0-9]*",' | grep -Eo "[0-9]*"`
            name=`echo $channel | grep -Po '"id".*"name": ".*?", ' | sed 's/"id".*"name": "\(.*\)", /\1/g'`
            echo -e "found a channel \"\033[36m$name\033[0m\" with id \033[36m$id\033[0m"
            # det1=`curl "https://discordapp.com/api/v6/channels/$id/messages?limit=50" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:66.0) Gecko/20100101 Firefox/66.0" -H "Accept: */*" --compressed -H "Referer: https://discordapp.com/channels/$id" -H "Authorization: $sourceauth" -H "DNT: 1" -H "Connection: keep-alive" -H "Cookie: __cfduid=d5654e7ddceb28663e0d4ee79adbf39e81538640920" -H "TE: Trailers"`
            det2=`curl "https://discordapp.com/api/v6/guilds/$guildid/messages/search?channel_id=$id&include_nsfw=true" -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:74.0) Gecko/20100101 Firefox/74.0' -H 'Accept: */*' -H 'Accept-Language: en-US' --compressed -H "Authorization: $sourceauth" -H 'Connection: keep-alive' -H "Referer: https://discordapp.com/channels/$id" -H 'Cookie: __cfduid=d440293169c3730ee2beff170518c1cb31565407611; locale=en-US; __cfruid=cd69440a7f7f42175065bc6d8aaeaf9e61ec8171-1585334844' -H 'TE: Trailers'`
            
            if [ "$det2" != '{"message": "Missing Access", "code": 50001}' ]
            then
                totalresults=`echo "$det2" | grep -Eo '"total_results": [0-9]*,' | grep -Eo "[0-9]*"`
                echo -e "\033[36maddin' this channel into archive queue...\033[0m"
                output="${archivechannelsparameters/\[insert_channel_id_here\]/$id}"
                output="${output/\[insert_channel_name_here\]/$name}"
                [ "$totalresults" -gt "$threshold" ] && output="${output/\[-o\]/-o}" || output="${output/\[-o\]/}"
                echo "$output"
                echo "$output" >> "$guildfilename.queue.sh"
            else
                echo -e "\033[31myou don't have permission for this channel, and this channel will NOT be added into archive queue\033[0m"
            fi
        fi
    done
}

OLD_IFS=$IFS
IFS=$'\n'

if [ "$1" == "-H" ] || [ "$1" == "-h" ] || [ "$1" == "--help" ]
then
    echo "copyrekt die deutsche Orthopädiespezialist 2020"
    echo "guild archive bot for discord"
    echo "a fegelscript to get metadata of a guild and automatically analyze which channels can be dumped and generate sh file to call archivechannels.v5.sh to do the channel archivin' jobs"
    echo
    echo "Usage: "
    echo "./archiveguild.sh sourceauth sourceguildid [guildfilename]"
    echo
    echo "if you don't add a guild file name, it would name it after guild's name (might be a long arse one)"
    echo "you need to fill or change the $archivechannelsparameters as you see fit, the generated sh file would use this template for commands of each channel; use [insert_channel_id_here] for the script to insert channel id, and use [insert_channel_name_here] to insert channel name, and use [-o] to set the switch for optimized mode, since if a channel has two few messages, the optimized mode might not work properly (it should be more than 2*processes messages)"
    exit
fi

sourceauth="$1"
sourceguildid="$2"
[ "$3" ] && guildfilename="$3"
sourceguilddump
acp
processchannels

IFS=$OLD_IFS
