#!/bin/bash
# copyrekt die deutsche Orthopädiespezialist 2018
# multi-site rule34 fully automatic masspostin' bot for discord
# you can either use a webhook or your own account or alt account if you don't have permissions to create webhooks
# here we fockin' go

######################################################################################################################################################################
# need to be changed
webhookinterval=3
naturalinterval=2
# hentai update interval

webhook_url="<paste your webhook url here>"

function nanako() { # use webhooks
    if [ $messagemode ]
    then
        username="$cutie"
    else
        username="$cutie_name Hentai Bot"
    fi
    # curl -d "content=$1&username=$username&avatar_url=$avatarurl" "$webhook_url"
    curl -d "{\"content\":\"$1\",\"username\":\"$username\",\"avatar_url\":\"$avatarurl\"}" "$webhook_url"
}

function hifumi() { # use webhooks to upload files
    if [ $messagemode ]
    then
        username="$cutie"
    else
        username="$cutie_name Hentai Bot"
    fi
    curl -F "payload_json={\"content\":\"$1\",\"username\":\"$username\",\"avatar_url\":\"$avatarurl\"}" -F "filename=@$2" "$webhook_url"
}

function futaba() { # use your own accounts
    if [ $configmode ]
    then
        eval $curl_command
    else
        # <login your discord account usin' firefox, use F12 to open developer mode, use "network" tab to monitor network activities, send a message in your desired channel, find the "messages" request and use "Copy" -> "Copy as cURL to get the cURL command and replace your message with a $1 and replace all '""' with '\"', then you're good to go! >
        # it will look like the cURL command below, but pls do yourself a fockin' favor and change it to yours
        curl "https://discordapp.com/api/v6/channels/XXXXXXXXXXXXXXXXX/messages" -H "XXXXXXXXXXXXXXXXX" -H "Accept: */*" -H "Accept-Language: en-US" --compressed -H "Referer: https://discordapp.com/channels/XXXXXXXXXXXXXXXXX" -H "Content-Type: application/json" -H "Authorization: XXXXXXXXXXXXXXXXX" -H "X-Super-Properties: XXXXXXXXXXXXXXXXX" -H "Cookie:XXXXXXXXXXXXXXXXX" -H "DNT: X" -H "Connection: keep-alive" --data "{\"content\":\"$1\",\"nonce\":\"XXXXXXXXXXXXXXXXX\",\"tts\":false}"
    fi
}

function makoto() { # use your own accounts to upload files
    if [ $configmode ]
    then
        eval $curl_command_upload
    else
        # <login your discord account usin' firefox, use F12 to open developer mode, use "network" tab to monitor network activities, send a message in your desired channel, find the "messages" request and use "Copy" -> "Copy as cURL to get the cURL command, but this time you'll need to change the enitre --data into '-F "payload_json={\"content\":\"$1\",\"nonce\":\"XXXXXXXXXXXXXXXXX\",\"tts\":false}" -F "filename=@$2"', then you're good to go! >
        # it will look like the cURL command below, but pls do yourself a fockin' favor and change it to yours
        curl "https://discordapp.com/api/v6/channels/XXXXXXXXXXXXXXXXX/messages" -H "XXXXXXXXXXXXXXXXX" -H "Accept: */*" -H "Accept-Language: en-US" --compressed -H "Referer: https://discordapp.com/channels/XXXXXXXXXXXXXXXXX" -H "Content-Type: multipart/form-data; boundary=---------------------------XXXXXXXXXXXXXXXXX" -H "Authorization: XXXXXXXXXXXXXXXXX" -H "X-Super-Properties: XXXXXXXXXXXXXXXXX" -H "Cookie:XXXXXXXXXXXXXXXXX" -H "DNT: X" -H "Connection: keep-alive" -F "payload_json={\"content\":\"$1\",\"nonce\":\"XXXXXXXXXXXXXXXXX\",\"tts\":false}" -F "filename=@$2"
    fi
}
######################################################################################################################################################################


######################################################################################################################################################################
# DO NOT CHANGE UNLESS NECESSARY

parameters=`getopt -o S:s:WwA:a:NnM:m:C:c:DdL:l:hH -a -l site:,webhook,avatar-url:,natural-mode,message:,config-file:,download,link-only:,troll:,silent,help -- "$@"`

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
    case "$1" in
        -s | -S | --site)
            site=$2
            shift 2
            ;;
        -w | -W | --webhook)
            mode=0
            shift
            ;;
        -a | -A | --avatar-url)
            avatarurl=$2
            shift 2
            ;;
        -n | -N | --natural-mode)
            mode=1
            shift
            ;;
        -m | -M | --message)
            messagemode=1
            message=$2
            shift 2
            ;;
        -c | -C | --config-file)
            configmode=1
            configfile=$2
            shift 2
            ;;
        -d | -D | --download)
            downloadmode=1
            shift
            ;;
        -l | -L | --link-only)
            linkonlymode=1
            exportfile=$2
            shift 2
            ;;
        --troll)
            trollname=$2
            shift 2
            ;;
        --silent)
            silentmode=1
            shift
            ;;
        -h | -H | --help)
            echo "copyrekt die deutsche Orthopädiespezialist 2018"
            echo "multi-site rule34 fully automatic masspostin' bot for discord"
            echo "you can either use a webhook or your own account or alt account if you don't have permissions to create webhooks"
            echo
            echo "Usage: "
            echo "futaba.sh [options] cutie cutie_name"
            echo
            echo "Options: "
            echo "    -s or -S or --site: input site name, currently supported: paheal, gelbooru"
            echo "        use localmachine to post or upload pics in local file (like bein' generated in link-only mode) to discord, in this case \$cutie will be your filename"
            echo "    -w or -W or --webhook: use discord webhook to upload hentai, need to paste webhook url into nanako() function"
            echo "        and when you use this mode, you must use -a or -A or --avatar-url to set your avatar, you need to make one yourself and upload to discord and get the link via \"Copy Link\""
            echo "    -n or -N or --natural-mode: use your own account to upload hentai, need to follow the instructions in futaba() function"
            echo "    -m or -M or --message: send a message usin' either methods, in this mode the cutie name will become your bot's name (if you use webhook)"
            echo "    -c or -C or --config-file: load a configuration file which contains three lines of webhook url, account curl command and account curl command (used to upload); if you don't load one it will use default values in the script"
            echo "    -d or -D or --download: download pics and upload to discord instead of just postin' links"
            echo "    -l or -L or --link-only: only export hentai pics links to file"
            echo "    --troll: replace die deutsche Orthopädiespezialist in the copyrekt message to something else"
            echo "    --silent: omit all of messages except pics, may be useful in some cases"
            echo "    -h or -H or --help: this shit"
            echo
            echo "Cutie: "
            echo "    pls input an ACTUALLY EXISTED name or tag, you can look up by addin' \"site:<your site>\" on Google to make sure it exists. And pls include \"_\" if it has one"
            echo "    eg. futaba's page on gelbooru.com is https://gelbooru.com/index.php?page=post&s=list&tags=sakura_futaba and what you need to input is \"sakura_futaba\""
            echo "        the display name for your cutie (\$cutie_name) can be different from the search name or tag (\$cutie), but if you don't input one it will be automatically generated from the tag"
            exit
            shift
            ;;
        --)
            cutie=$2
            cutie_name=$3
            shift 2
            break
            ;;
        *)
            echo "Internal error!"
            exit 255
            ;;
    esac
done

if [ $mode == 0 ] && [ ! "$avatarurl" ]
then
    echo "Houston, we have an arsefockin' problem: Avatar url required when usin' Webhook mode" >&2
    exit 3
fi

if [ ! $messagemode ]
then
    if [ ! "$cutie" ]
    then 
        echo "Houston, we have an arsefockin' problem: Cutie required" >&2
        exit 4
    fi
else
    case "$mode" in
    0)
        nanako "$message"
        ;;
    1)
        futaba "$message"
        ;;
    esac
    exit
fi

if [ ! $site ]
then
    echo "Houston, we have an arsefockin' problem: You need to input a hentai site" >&2
    exit 5
fi

if [ $configmode ]
then
    webhook_url=`sed -n 1p "$configfile"`
    curl_command=`sed -n 2p "$configfile"`
    curl_command_upload=`sed -n 3p "$configfile"`
fi

######################################################################################################################################################################

######################################################################################################################################################################
# info-message-related functions start here
function initmessage() {
    if [ ! $silentmode ] && [ ! $linkonlymode ]
    then
        if [ "$trollname" ]
        then
            author="$trollname"
        else
            author="die deutsche Orthopädiespezialist"
        fi
        case "$site" in
            paheal)
                sitename="paheal.net"
                ;;
            gelbooru)
                sitename="gelbooru.com"
                ;;
            localmachine)
                sitename="idkwhatitis.com"
                ;;
            *)
                echo "fock it" >&2
                exit 6
        esac
        message="$sitename rule34 fully automatic masspostin' bot developed by **$author**"
        case "$mode" in
            0)
                nanako "$message"
                ;;
            1)
                futaba "$message"
                ;;
        esac

        case "$mode" in
            0)
                nein="$webhookinterval"
                ;;
            1)
                nein="$naturalinterval"
                ;;
        esac
        case "$site" in
            paheal)
                message="FYI, the cutie's name is **$cutie_name**, and this hentai has **$totalfish** page(s), and the hentai update interval is set to **$nein** second(s), so enjoy your fockin' hentai <:funny_v1:449451139063218177><:funny_v1:449451139063218177><:funny_v1:449451139063218177><:funny_v1:449451139063218177><:funny_v1:449451139063218177>"
                ;;
            gelbooru)
                message="FYI, the cutie's name is **$cutie_name**, and this hentai has more than **$finalfish** pic(s), and the hentai update interval is set to **$nein** second(s), so enjoy your fockin' hentai <:funny_v1:449451139063218177><:funny_v1:449451139063218177><:funny_v1:449451139063218177><:funny_v1:449451139063218177><:funny_v1:449451139063218177>"
                ;;
            localmachine)
                message="FYI, the cutie's name is **$cutie_name**, and idk how many pics does this hentai have, and the hentai update interval is set to **$nein** second(s), so enjoy your fockin' hentai <:funny_v1:449451139063218177><:funny_v1:449451139063218177><:funny_v1:449451139063218177><:funny_v1:449451139063218177><:funny_v1:449451139063218177>"
                ;;
            *)
                echo "fock it" >&2
                exit 6
        esac
        case "$mode" in
            0)
                nanako "$message"
                ;;
            1)
                futaba "$message"
                ;;
        esac
    fi
}

function finalmessage() {
    if [ ! $silentmode ] && [ ! $linkonlymode ]
    then
        message="Thanks for usin' this shitty arse bot, see u next time<:funny_v1:449451139063218177><:funny_v1:449451139063218177><:funny_v1:449451139063218177><:funny_v1:449451139063218177><:funny_v1:449451139063218177>"
        case "$mode" in
            0)
                nanako "$message"
                ;;
            1)
                futaba "$message"
                ;;
        esac
    fi
}

######################################################################################################################################################################

######################################################################################################################################################################
# site-related functions start here

function download() {
    mkdir temp
    cd temp
    rm *.* -f
    wget "$hentai"
    for file in `ls | sed 's/ /|/g'`
    do
        file=`echo $file | sed 's/|/ /g'`
        case "$mode" in
            0)
                hifumi "" "$file"
                # sleep "$webhookinterval"
                ;;
            1)
                makoto "" "$file"
                # sleep "$naturalinterval"
                ;;
        esac
    done
    rm *.* -f
    cd ..
}

function post2discord() {
    case "$mode" in
        0)
            nanako "$hentai"
            sleep "$webhookinterval"
            ;;
        1)
            futaba "$hentai"
            sleep "$naturalinterval"
            ;;
    esac
}

function processhentai() {
    if [ ! $linkonlymode ]
    then
        if [ $downloadmode ]
        then
            download
        else
            post2discord
        fi
    else
        echo "$hentai" >> "$exportfile"
    fi
}

function localmachine() {
    initmessage

    for file in `cat "$cutie" | sed 's/ /|/g'`
    do
        hentai=`echo $file | sed 's/|/_/g'`
        if [ $downloadmode ]
        then
            download
        else
            post2discord
        fi
    done
    
    finalmessage
}

function paheal() {
    url="https://rule34.paheal.net/post/list/$cutie/"
    totalfish=`curl "$url" | grep -Eo "Next.*Last" | grep -Eo "[0-9]*"`
    #totalfish=2 # in some cases you just can't use script to find out pages, you'll have to make it manually
    if [ ! "$cutie_name" ]
    then
        cutie_name=`echo $cutie | sed 's/_/ /g'`
    fi

    initmessage

    for fish in `seq 1 $totalfish`
    do 
        for hentai in `curl "$url/$fish" | sed 's/<br/\n/g' | grep "Image Only" | grep -Eo "http://.*>Image" | sed 's/">Image//g'`
        do
            processhentai
        done
    done

    finalmessage
}

function gelbooru() {
    url="https://gelbooru.com/index.php?page=post&s=list&tags=$cutie"
    finalfish=`curl "$url" | grep -Eo "pid=[0-9]*\" alt=\"last page\"" | sed 's/pid=//g' | sed 's/" alt="last page"//g'`
    if [ ! "$cutie_name" ]
    then
        cutie_name=`echo $cutie | sed 's/_/ /g'`
    fi

    initmessage

    for fish in `seq 0 42 $finalfish`
    do
        url="https://gelbooru.com/index.php?page=post&s=list&tags=$cutie&pid=$fish"
        url=${url%$'\r'}
        for hentailink in `curl "$url" | sed 's/>/\n/g' |  grep -Eo "view&amp;id=[0-9]*" |  sed 's/view&amp;id=//g'` # find id's
        do
            hentai=`curl "https://gelbooru.com/index.php?page=post&s=view&id=$hentailink" | sed 's/\/li/\n/g' | grep -Eo "<li><a href=\".*\" style=\"font-weight: bold;\">Original image" | sed 's/<li><a href="//g' | sed 's/" style="font-weight: bold;">Original image//g' | sed 's/" target="_blank//g'`
            processhentai
        done
    done

    finalmessage
}

case "$site" in
    paheal)
        paheal
        ;;
    gelbooru)
        gelbooru
        ;;
    localmachine)
        if [ $linkonlymode ]
        then
            echo "Houston, we have an arsefockin' problem: For arsefockin' obvious reason, you cannot use link-only mode when usin' local pic source " >&2
            exit 7
        else
            localmachine
        fi
        ;;
    *)
        echo "Houston, we have an arsefockin' problem: Site currently not supported" >&2
        exit 6
esac
