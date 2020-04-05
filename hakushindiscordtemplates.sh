#!/bin/bash
# copyrekt die deutsche Orthopädiespezialist 2020
# a fegelscript to hakushin replicate discord's "template" feature to replicate a guild into a new guild with the same roles, channels and permissions, but you don't need any fockin' permission or role to do it

function sourceguilddump {
    # dump source guild's metadata
    curl "https://discordapp.com/api/v6/guilds/$sourceguildid" -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:75.0) Gecko/20100101 Firefox/75.0' -H 'Accept: */*' -H 'Accept-Language: en-US' --compressed -H "Authorization: $sourceauth" -H 'Connection: keep-alive' -H "Referer: https://discordapp.com/channels/$sourceguildid" -H 'Cookie: __cfduid=d5cbe884783a0de963fc8d759dc20bac81584154417; locale=en-US; __cfruid=fbb94801fd7711173f37ee00dc0c71986d86f1c1-1586022016' -H 'TE: Trailers' > "$guildfilename.metadata.json"
    cp -p "$guildfilename.metadata.json" "$guildfilename.metadata.temp.json"

    # dump source guild's channel data
    curl "https://discordapp.com/api/v6/guilds/$sourceguildid/channels" -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:75.0) Gecko/20100101 Firefox/75.0' -H 'Accept: */*' -H 'Accept-Language: en-US' --compressed -H "Authorization: $sourceauth" -H 'Connection: keep-alive' -H "Referer: https://discordapp.com/channels/$sourceguildid" -H 'Cookie: __cfduid=d5cbe884783a0de963fc8d759dc20bac81584154417; locale=en-US; __cfruid=fbb94801fd7711173f37ee00dc0c71986d86f1c1-1586022016' -H 'TE: Trailers' > "$guildfilename.channels.json"
    cp -p "$guildfilename.channels.json" "$guildfilename.channels.temp.json"
}

function changeguild {
    # slim metadata until it could just be put into requests to change overall metadata
    metadata=`cat "$guildfilename.metadata.json" | sed 's/"emojis": \[.*\], "banner"/"banner"/g' | sed 's/"roles": \[.*\], //g'`
    sourceguildname=`echo $metadata | grep -Po '"name": ".*", "icon"' | sed 's/"name": "//g' | sed 's/", "icon"//g'`

    # change temp guild's metadata into $guildfilename's
    curl "https://discordapp.com/api/v6/guilds/$targetguildid" -X PATCH -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:75.0) Gecko/20100101 Firefox/75.0' -H 'Accept: */*' -H 'Accept-Language: en-US' --compressed -H 'Content-Type: application/json' -H "Authorization: $targetauth" -H 'Origin: https://discordapp.com' -H 'Connection: keep-alive' -H "Referer: https://discordapp.com/channels/$targetguildid" -H 'Cookie: __cfduid=d5a33608e55b75b1fc02781bd0757b7bb1584254754; locale=en-US; __cfruid=ab4456c57ce54d16c8074476942497279958d6fd-1586022017' -H 'TE: Trailers' --data "$metadata"
}

function processroles {
    # delete all existin' roles
    for role in `curl "https://discordapp.com/api/v6/guilds/$targetguildid/roles" -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:75.0) Gecko/20100101 Firefox/75.0' -H 'Accept: */*' -H 'Accept-Language: en-US' --compressed -H "Authorization: $targetauth" -H 'Origin: https://discordapp.com' -H 'Connection: keep-alive' -H "Referer: https://discordapp.com/channels/$targetguildid" -H 'Cookie: __cfduid=d5a33608e55b75b1fc02781bd0757b7bb1584254754; locale=en-US; __cfruid=ab4456c57ce54d16c8074476942497279958d6fd-1586022017' -H 'TE: Trailers' | sed 's/^\[//g' | sed 's/\]$//g' | sed 's/}, {/}\n{/g' | grep -Eo '"id": "[0-9]*",' | grep -Eo "[0-9]*"`
    do
        curl "https://discordapp.com/api/v6/guilds/696032031754158081/roles/$role" -X DELETE -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:75.0) Gecko/20100101 Firefox/75.0' -H 'Accept: */*' -H 'Accept-Language: en-US' --compressed -H "Authorization: $targetauth" -H 'Origin: https://discordapp.com' -H 'Connection: keep-alive' -H "Referer: https://discordapp.com/channels/$targetguildid" -H 'Cookie: __cfduid=d5a33608e55b75b1fc02781bd0757b7bb1584254754; locale=en-US; __cfruid=2d0368f44e7ccd79f5dbeac6d0527ad2b140f2c6-1586054039' -H 'TE: Trailers'
    done

    # check @everyone's id, assumin' there's only one role in there
    everyoneid=`curl "https://discordapp.com/api/v6/guilds/$targetguildid/roles" -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:75.0) Gecko/20100101 Firefox/75.0' -H 'Accept: */*' -H 'Accept-Language: en-US' --compressed -H "Authorization: $targetauth" -H 'Origin: https://discordapp.com' -H 'Connection: keep-alive' -H "Referer: https://discordapp.com/channels/$targetguildid" -H 'Cookie: __cfduid=d5a33608e55b75b1fc02781bd0757b7bb1584254754; locale=en-US; __cfruid=ab4456c57ce54d16c8074476942497279958d6fd-1586022017' -H 'TE: Trailers' | grep -Eo '"id": "[0-9]*",' | grep -Eo "[0-9]*"`

    # add roles and set metadata
    pos="["
    for role in `cat "$guildfilename.metadata.json" | sed 's/"emojis": \[.*\], "banner"/"banner"/g' | grep -Eo '"roles": \[.*\], ' | sed 's/"roles": \[//g' | sed 's/], //g' | sed 's/}, {/}\n{/g'`
    do
        oldid=`echo $role | grep -Eo '"id": "[0-9]*",' | grep -Eo "[0-9]*"`
        position=`echo $role | grep -Eo '"position": [0-9]*' | grep -Eo "[0-9]*"`
        name=`echo $role | grep -Eo '"name": ".*", "permissions"' | sed 's/"name": "//g' | sed 's/", "permissions"//g'`
        [ "$name" = "@everyone" ] && id="$everyoneid" || id=`curl "https://discordapp.com/api/v6/guilds/$targetguildid/roles" -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:75.0) Gecko/20100101 Firefox/75.0' -H 'Accept: */*' -H 'Accept-Language: en-US' --compressed -H "Authorization: $targetauth" -H 'Origin: https://discordapp.com' -H 'Connection: keep-alive' -H 'Referer: https://discordapp.com/channels/$targetguildid' -H 'Cookie: __cfduid=d5a33608e55b75b1fc02781bd0757b7bb1584254754; locale=en-US; __cfruid=ab4456c57ce54d16c8074476942497279958d6fd-1586022017' -H 'TE: Trailers' --data '' | grep -Eo '"id": "[0-9]*",' | grep -Eo "[0-9]*"`
        pos="$pos{\"id\":\"$id\",\"position\":$position},"
        curl "https://discordapp.com/api/v6/guilds/$targetguildid/roles/$id" -X PATCH -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:75.0) Gecko/20100101 Firefox/75.0' -H 'Accept: */*' -H 'Accept-Language: en-US' --compressed -H 'Content-Type: application/json' -H "Authorization: $targetauth" -H 'Origin: https://discordapp.com' -H 'Connection: keep-alive' -H "Referer: https://discordapp.com/channels/$targetguildid" -H 'Cookie: __cfduid=d5a33608e55b75b1fc02781bd0757b7bb1584254754; locale=en-US; __cfruid=ab4456c57ce54d16c8074476942497279958d6fd-1586022017' -H 'TE: Trailers' --data "$role"
        sed -i "s/$oldid/$id/g" "$guildfilename.metadata.temp.json"
        sed -i "s/$oldid/$id/g" "$guildfilename.channels.temp.json"
    done
    pos="${pos%,}]"
    curl "https://discordapp.com/api/v6/guilds/$targetguildid/roles" -X PATCH -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:75.0) Gecko/20100101 Firefox/75.0' -H 'Accept: */*' -H 'Accept-Language: en-US' --compressed -H 'Content-Type: application/json' -H "Authorization: $targetauth" -H 'Origin: https://discordapp.com' -H 'Connection: keep-alive' -H "Referer: https://discordapp.com/channels/$targetguildid" -H 'Cookie: __cfduid=d5a33608e55b75b1fc02781bd0757b7bb1584254754; locale=en-US; __cfruid=ab4456c57ce54d16c8074476942497279958d6fd-1586022017' -H 'TE: Trailers' --data "$pos"
}

function processchannels {
    # delete all existin' channels
    for oldchannelid in `curl "https://discordapp.com/api/v6/guilds/$targetguildid/channels" -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:75.0) Gecko/20100101 Firefox/75.0' -H 'Accept: */*' -H 'Accept-Language: en-US' --compressed -H "Authorization: $targetauth" -H 'Connection: keep-alive' -H "Referer: https://discordapp.com/channels/$targetguildid" -H 'Cookie: __cfduid=d5cbe884783a0de963fc8d759dc20bac81584154417; locale=en-US; __cfruid=fbb94801fd7711173f37ee00dc0c71986d86f1c1-1586022016' -H 'TE: Trailers' | sed 's/^\[//g' | sed 's/\]$//g' | sed 's/\]$//g' | sed 's/}, {"id": "\([0-9]*\)", "last_message_id"/}\n{"id": "\1", "last_message_id"/g' | sed 's/}, {"id": "\([0-9]*\)", "type": \([0-9]\)/}\n{"id": "\1", "type": \2/g' | grep -Eo '"id".*"name"' | grep -Eo '"id": "[0-9]*",' | grep -Eo "[0-9]*"`
    do
        curl "https://discordapp.com/api/v6/channels/$oldchannelid" -X DELETE -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:75.0) Gecko/20100101 Firefox/75.0' -H 'Accept: */*' -H 'Accept-Language: en-US' --compressed -H "Authorization: $targetauth" -H 'Origin: https://discordapp.com' -H 'Connection: keep-alive' -H "Referer: https://discordapp.com/channels/$oldchannelid" -H 'Cookie: __cfduid=d5a33608e55b75b1fc02781bd0757b7bb1584254754; locale=en-US; __cfruid=c935f99c1d20d3ddaa8be063560c1520172aac59-1586053062' -H 'TE: Trailers'
    done

    # first pass: create categories and sort them perhaps
    pos="["
    for category in `cat "$guildfilename.channels.temp.json" | sed 's/^\[//g' | sed 's/\]$//g' | sed 's/\]$//g' | sed 's/}, {"id": "\([0-9]*\)", "last_message_id"/}\n{"id": "\1", "last_message_id"/g' | sed 's/}, {"id": "\([0-9]*\)", "type": \([0-9]\)/}\n{"id": "\1", "type": \2/g'`
    do
        type=`echo $category | grep -Eo '"type": [0-9]*' | grep -Eo "[0-9]*"`
        # echo $type
        if [ "$type" = "4" ]
        then
            oldid=`echo $category | grep -Eo '"id".*"name"' | grep -Eo '"id": "[0-9]*",' | grep -Eo "[0-9]*"`
            position=`echo $category | grep -Eo '"position": [0-9]*' | grep -Eo "[0-9]*"`
            category=`echo $category | sed 's/"position": [0-9]*,//g'` # it needs to sort later
            id=`curl "https://discordapp.com/api/v6/guilds/$targetguildid/channels" -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:75.0) Gecko/20100101 Firefox/75.0' -H 'Accept: */*' -H 'Accept-Language: en-US' --compressed -H 'Content-Type: application/json' -H "Authorization: $targetauth" -H "Referer: https://discordapp.com/channels/$targetguildid" -H 'Cookie: __cfduid=d5a33608e55b75b1fc02781bd0757b7bb1584254754; locale=en-US; __cfruid=58efb68f1978fdc77169607782d80baea04a2eb6-1586055840' -H 'TE: Trailers' --data "$category" | grep -Eo '"id".*"name"' | grep -Eo '"id": "[0-9]*",' | grep -Eo "[0-9]*"`
            pos="$pos{\"id\":\"$id\",\"position\":$position},"
            sed -i "s/$oldid/$id/g" "$guildfilename.metadata.temp.json"
            sed -i "s/$oldid/$id/g" "$guildfilename.channels.temp.json"
        fi
    done
    pos="${pos%,}]"
    curl "https://discordapp.com/api/v6/guilds/$targetguildid/channels" -X PATCH -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:75.0) Gecko/20100101 Firefox/75.0' -H 'Accept: */*' -H 'Accept-Language: en-US' --compressed -H 'Content-Type: application/json' -H "Authorization: $targetauth" -H 'Origin: https://discordapp.com' -H 'Connection: keep-alive' -H "Referer: https://discordapp.com/channels/$targetguildid" -H 'Cookie: __cfduid=d5a33608e55b75b1fc02781bd0757b7bb1584254754; locale=en-US; __cfruid=58efb68f1978fdc77169607782d80baea04a2eb6-1586055840' -H 'TE: Trailers' --data "$pos"

    # second pass: create other channels and sort them
    pos="["
    for channel in `cat "$guildfilename.channels.temp.json" | sed 's/^\[//g' | sed 's/\]$//g' | sed 's/\]$//g' | sed 's/}, {"id": "\([0-9]*\)", "last_message_id"/}\n{"id": "\1", "last_message_id"/g' | sed 's/}, {"id": "\([0-9]*\)", "type": \([0-9]\)/}\n{"id": "\1", "type": \2/g'`
    do
        type=`echo $channel | grep -Eo '"type": [0-9]*' | grep -Eo "[0-9]*"`
        # echo $type
        if [ "$type" != "4" ]
        then
            oldid=`echo $channel | grep -Eo '"id".*"name"' | grep -Eo '"id": "[0-9]*",' | grep -Eo "[0-9]*"`
            position=`echo $channel | grep -Eo '"position": [0-9]*' | grep -Eo "[0-9]*"`
            channel=`echo $channel | sed 's/"position": [0-9]*,//g'` # it needs to sort later
            id=`curl "https://discordapp.com/api/v6/guilds/$targetguildid/channels" -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:75.0) Gecko/20100101 Firefox/75.0' -H 'Accept: */*' -H 'Accept-Language: en-US' --compressed -H 'Content-Type: application/json' -H "Authorization: $targetauth" -H "Referer: https://discordapp.com/channels/$targetguildid" -H 'Cookie: __cfduid=d5a33608e55b75b1fc02781bd0757b7bb1584254754; locale=en-US; __cfruid=58efb68f1978fdc77169607782d80baea04a2eb6-1586055840' -H 'TE: Trailers' --data "$channel" | grep -Eo '"id".*"name"' | grep -Eo '"id": "[0-9]*",' | grep -Eo "[0-9]*"`
            pos="$pos{\"id\":\"$id\",\"position\":$position},"
            sed -i "s/$oldid/$id/g" "$guildfilename.metadata.temp.json"
            sed -i "s/$oldid/$id/g" "$guildfilename.channels.temp.json"
        fi
    done
    pos="${pos%,}]"
    curl "https://discordapp.com/api/v6/guilds/$targetguildid/channels" -X PATCH -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:75.0) Gecko/20100101 Firefox/75.0' -H 'Accept: */*' -H 'Accept-Language: en-US' --compressed -H 'Content-Type: application/json' -H "Authorization: $targetauth" -H 'Origin: https://discordapp.com' -H 'Connection: keep-alive' -H "Referer: https://discordapp.com/channels/$targetguildid" -H 'Cookie: __cfduid=d5a33608e55b75b1fc02781bd0757b7bb1584254754; locale=en-US; __cfruid=58efb68f1978fdc77169607782d80baea04a2eb6-1586055840' -H 'TE: Trailers' --data "$pos"
}

function reuploademojis { # reupload emojis (optional
    echo "work in progress"
}

function template { # use discord's own template fearture to create a template:wiebitte:
    [ "$templatename" ] || templatename="$sourceguildname (hakushin"
    [ "$templatedescription" ] || templatedescription="hakushin template of \"$sourceguildname\" (guild id: $sourceguildid)"
    curl "https://discordapp.com/api/v6/guilds/$targetguildid/templates" -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:75.0) Gecko/20100101 Firefox/75.0' -H 'Accept: */*' -H 'Accept-Language: en-US' --compressed -H 'Content-Type: application/json' -H "Authorization: $targetauth" -H 'Origin: https://discordapp.com' -H 'Connection: keep-alive' -H 'Referer: https://discordapp.com/channels/@me' -H 'Cookie: __cfduid=df41e8118768333089a09c6d25a75d6171584154593; locale=en-US; __cfruid=98f8f406fed3a550169dd14af8d568b3a8cf0c04-1586067677' -H 'TE: Trailers' --data '{"name":"$templatename","description":"$templatedescription"}'
}

OLD_IFS=$IFS
IFS=$'\n'

original_parameters="$0"

for parameter in "$@"
do
    original_parameters="$original_parameters '$parameter'"
done

currentdir=`pwd`
parameters=`getopt -o tT -a -l template, template-title:,template-description: -- "$@"`

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
        -t | -A | --antics)
            template="JAJAJAJAJA"
            shift
            ;;
        --template-title)
            templatename="$2"
            shift 2
            ;;
        --template-description)
            templatedescription="$2"
            shift 2
            ;;
        -h | -H | --help)
            echo "copyrekt die deutsche Orthopädiespezialist 2020"
            echo "a fegelscript to hakushin replicate discord's \"template\" feature to replicate a guild into a new guild with the same roles, channels and permissions, but you don't need any fockin' permission or role to do it"
            echo
            echo "Usage: "
            echo "./hakushindiscordtemplates.sh [options] guildfile sourceauth sourceguildid targetauth [targetguildid]"
            echo
            echo "Options: "
            echo "  -t or -T or --template <filename>: use discord's template feature to make a template for replicated guild"
            echo "    --template-title <filename>: custom template title"
            echo "    --template-description <filename>: custom template description"
            echo
            echo "if target guild id is not given, a new guild would be created"
            exit
            shift
            ;;
        --)
            guildfilename="$2"
            sourceauth="$3"
            sourceguildid="$4"
            targetauth="$5"
            [ "$6" ] && targetguildid="$6" || targetguildid=`curl 'https://discordapp.com/api/v6/guilds' -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:75.0) Gecko/20100101 Firefox/75.0' -H 'Accept: */*' -H 'Accept-Language: en-US' --compressed -H 'Content-Type: application/json' -H "Authorization: $targetauth" -H 'Origin: https://discordapp.com' -H 'Connection: keep-alive' -H 'Referer: https://discordapp.com/channels/@me' -H 'Cookie: __cfduid=d5a33608e55b75b1fc02781bd0757b7bb1584254754; locale=en-US; __cfruid=88aeb55eb0a8d28a41017b02ece60520142c92f8-1586063772' -H 'TE: Trailers' --data '{"name":"Gretaganger Chat Central","region":"us-south","icon":null,"channels":null}' | grep -o '^{"id": "[0-9]*"' | grep -Eo "[0-9]*"`
            ;;
        *)
            echo "Internal error!"
            exit 255
            ;;
    esac
done

sourceguilddump
changeguild
processroles
processchannels
reuploademojis
[ "$template" ] && template

IFS=$OLD_IFS
