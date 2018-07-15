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

function nanako(){ # use webhooks
    if [ $configemode ]
    then
        magic=`cat "$configfile"`
    else
        magic="<paste your webhook url here>"
    fi
    if [ $messagemode ]
    then
        username="$cutie"
    else
        username="$cutie_name Hentai Bot"
    fi
    curl -d "content=$1&username=$username&avatar_url=$avatarurl" "$magic"
}

function futaba(){ # use your own accounts
    if [ $configemode ]
    then
        eval `cat "$configfile"`
    else
        # <login your discord account usin' firefox, use F12 to open developer mode, use "network" tab to monitor network activities, send a message in your desired channel, find the "messages" request and use "Copy" -> "Copy as cURL to get the cURL command and replace your message with a $1 and replace all '""' with '\"', then you're good to go! >
        # it will look like the cURL command below, but pls do yourself a fockin' favor and change it to yours
        curl "https://discordapp.com/api/v6/channels/XXXXXXXXXXXXXXXXX/messages" -H "XXXXXXXXXXXXXXXXX" -H "Accept: */*" -H "Accept-Language: en-US" --compressed -H "Referer: https://discordapp.com/channels/XXXXXXXXXXXXXXXXX" -H "Content-Type: application/json" -H "Authorization: XXXXXXXXXXXXXXXXX" -H "X-Super-Properties: XXXXXXXXXXXXXXXXX" -H "Cookie:XXXXXXXXXXXXXXXXX" -H "DNT: X" -H "Connection: keep-alive" --data "{\"content\":\"$1\",\"nonce\":\"XXXXXXXXXXXXXXXXX\",\"tts\":false}"
    fi
}
######################################################################################################################################################################


######################################################################################################################################################################
# DO NOT CHANGE UNLESS NECESSARY

parameters=`getopt -o S:s:WwA:a:NnM:m:C:c:hH -a -l site:,webhook,avatar-url:,natural-mode,message:,config-file:,help -- "$@"`

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
			configemode=1
            configfile=$2
            shift 2
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
            echo "    -w or -W or --webhook: use discord webhook to upload hentai, need to paste webhook url into nanako() function"
            echo "        and when you use this mode, you must use -a or -A or --avatar-url to set your avatar, you need to make one yourself and upload to discord and get the link via \"Copy Link\""
            echo "    -n or -N or --natural-mode: use your own account to upload hentai, need to follow the instructions in futaba() function"
            echo "    -m or -M or --message: send a message usin' either methods, in this mode the cutie name will become your bot's name (if you use webhook)"
            echo "    -c or -C or --config-file: load a config file which contains one line of webhook link / account curl commands; if you don't load one it will use default values in the script"
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

if [ $mode == 0 ] && [ ! $avatarurl ]
then
    echo "Houston, we have an arsefockin' problem: Avatar url required when usin' Webhook mode" >&2  
    exit 3
fi

if [ ! $messagemode ]
then
    # if [ ! "$cutie" ] || [ ! "$cutie_name" ]
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
######################################################################################################################################################################

######################################################################################################################################################################
# site-related functions start here

function paheal(){
    url="https://rule34.paheal.net/post/list/$cutie/"
    totalfish=`curl "$url" | grep -Eo "Next.*Last" | grep -Eo "[0-9]*"`
    #totalfish=2 # in some cases you just can't use script to find out pages, you'll have to make it manually
    if [ ! "$cutie_name" ]
    then
        cutie_name=`echo $cutie | sed 's/_/ /g'`
    fi
    
    message="paheal.net rule34 fully automatic masspostin' bot developed by **die deutsche Orthopädiespezialist**"
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
    message="FYI, the cutie's name is **$cutie_name**, and this hentai has **$totalfish** page(s), and the hentai update interval is set to **$nein** second(s), so enjoy your fockin' hentai <:funny_v1:449451139063218177><:funny_v1:449451139063218177><:funny_v1:449451139063218177><:funny_v1:449451139063218177><:funny_v1:449451139063218177>"
    case "$mode" in
        0)
            nanako "$message"
            ;;
        1)
            futaba "$message"
            ;;
    esac

    for fish in `seq 1 $totalfish`
    do 
        for hentai in `curl "$url/$fish" | sed 's/<br/\n/g' | grep "Image Only" | grep -Eo "http://.*>Image" | sed 's/">Image//g'`
        do 
            case "$mode" in
                0)
                    nanako "$hentai"
                    sleep "$webhookinterval"
                    ;;
                1)
                    futaba "${hentai//%20/ }"
                    sleep "$naturalinterval"
                    ;;
            esac
        done
    done

    message="Thanks for usin' this shitty arse bot, see u next time<:funny_v1:449451139063218177><:funny_v1:449451139063218177><:funny_v1:449451139063218177><:funny_v1:449451139063218177><:funny_v1:449451139063218177>"
    case "$mode" in
        0)
            nanako "$message"
            ;;
        1)
            futaba "$message"
            ;;
    esac
}

function gelbooru(){
    url="https://gelbooru.com/index.php?page=post&s=list&tags=$cutie"
    finalfish=`curl "$url" | grep -Eo "pid=[0-9]*\" alt=\"last page\"" | sed 's/pid=//g' | sed 's/" alt="last page"//g'`
    if [ ! "$cutie_name" ]
    then
        cutie_name=`echo $cutie | sed 's/_/ /g'`
    fi

    message="gelbooru.com rule34 fully automatic masspostin' bot developed by **die deutsche Orthopädiespezialist**"
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
    message="FYI, the cutie's name is **$cutie_name**, and this hentai has more than **$finalfish** pic(s), and the hentai update interval is set to **$nein** second(s), so enjoy your fockin' hentai <:funny_v1:449451139063218177><:funny_v1:449451139063218177><:funny_v1:449451139063218177><:funny_v1:449451139063218177><:funny_v1:449451139063218177>"
    case "$mode" in
        0)
            nanako "$message"
            ;;
        1)
            futaba "$message"
            ;;
    esac

    for fish in `seq 0 42 $finalfish`
    do
        url="https://gelbooru.com/index.php?page=post&s=list&tags=$cutie&pid=$fish"
        for hentai in `curl "$url" | sed 's/>/\n/g' |  grep -Eo "view&amp;id=[0-9]*" |  sed 's/view&amp;id=//g'` # find id's
        do
            hentaipic=`curl "https://gelbooru.com/index.php?page=post&s=view&id=$hentai" | sed 's/\/li/\n/g' | grep -Eo "<li><a href=\".*\" style=\"font-weight: bold;\">Original image" | sed 's/<li><a href="//g' | sed 's/" style="font-weight: bold;">Original image//g' | sed 's/" target="_blank//g'`
            case "$mode" in
                0)
                    nanako "$hentaipic"
                    sleep "$webhookinterval"
                    ;;
                1)
                    futaba "${hentaipic//%20/ }"
                    sleep "$naturalinterval"
                    ;;
            esac
        done
    done

    message="Thanks for usin' this shitty arse bot, see u next time<:funny_v1:449451139063218177><:funny_v1:449451139063218177><:funny_v1:449451139063218177><:funny_v1:449451139063218177><:funny_v1:449451139063218177>"
    case "$mode" in
        0)
            nanako "$message"
            ;;
        1)
            futaba "$message"
            ;;
    esac
}

case "$site" in
    paheal)
        paheal
        ;;
    gelbooru)
        gelbooru
        ;;
    *)
        echo "Houston, we have an arsefockin' problem: Site currently not supported" >&2  
        exit 6
esac
