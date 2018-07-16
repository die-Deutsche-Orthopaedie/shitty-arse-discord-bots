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

shitty_arse_pixiv_parameter='<get it yourself>'
shitty_arse_pixiv_parameter=${shitty_arse_pixiv_parameter//--compressed /} # otherwise you cannot use it on wget

webhook_url="<paste your webhook url here>"

function nanako() { # use webhooks [ with one parameter <message> ]
    if [ $messagemode ]
    then
        username="$cutie"
    else
        username="$cutie_name Hentai Bot"
    fi
    # curl -d "content=$1&username=$username&avatar_url=$avatarurl" "$webhook_url"
    curl -d "{\"content\":\"$1\",\"username\":\"$username\",\"avatar_url\":\"$avatarurl\"}" "$webhook_url"
}

function hifumi() { # use webhooks to upload files [ with two parameters <message> <filepath> ]
    if [ $messagemode ]
    then
        username="$cutie"
    else
        username="$cutie_name Hentai Bot"
    fi
    curl -F "payload_json={\"content\":\"$1\",\"username\":\"$username\",\"avatar_url\":\"$avatarurl\"}" -F "filename=@$2" "$webhook_url"
}

function futaba() { # use your own accounts [ with one parameter <message> ]
    if [ $configmode ]
    then
        eval $curl_command
    else
        # <login your discord account usin' firefox, use F12 to open developer mode, use "network" tab to monitor network activities, send a message in your desired channel, find the "messages" request and use "Copy" -> "Copy as cURL to get the cURL command and replace your message with a $1 and replace all '""' with '\"', then you're good to go! >
        # it will look like the cURL command below, but pls do yourself a fockin' favor and change it to yours
        curl "https://discordapp.com/api/v6/channels/XXXXXXXXXXXXXXXXX/messages" -H "XXXXXXXXXXXXXXXXX" -H "Accept: */*" -H "Accept-Language: en-US" --compressed -H "Referer: https://discordapp.com/channels/XXXXXXXXXXXXXXXXX" -H "Content-Type: application/json" -H "Authorization: XXXXXXXXXXXXXXXXX" -H "X-Super-Properties: XXXXXXXXXXXXXXXXX" -H "Cookie:XXXXXXXXXXXXXXXXX" -H "DNT: X" -H "Connection: keep-alive" --data "{\"content\":\"$1\",\"nonce\":\"XXXXXXXXXXXXXXXXX\",\"tts\":false}"
    fi
}

function makoto() { # use your own accounts to upload files [ with two parameters <message> <filepath> ]
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

currentdir=`pwd`
parameters=`getopt -o S:s:WwA:a:NnM:m:U:u:C:c:DdL:l:hH -a -l site:,webhook,avatar-url:,natural-mode,message:,upload:,config-file:,download,link-only:,troll:,silent,webhookinterval:,naturalinterval:,pixiv-fast-mode,pixiv-halfspeed-mode,help -- "$@"`
# parameters=`getopt -o S:s:WwA:a:NnM:m:C:c:DdL:l:hH -a -l site:,webhook,avatar-url:,natural-mode,message:,config-file:,download,link-only:,troll:,silent,webhookinterval:,naturalinterval:,help -- "$@"`

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
        -u | -U | --upload)
            uploadmode=1
            filepath=$2
            message=$4
            echo "$filepath, $message"
            shift 2
            ;;
        -c | -C | --config-file)
            configmode=1
            configfilepath=$2
            shift 2
            ;;
        -d | -D | --download)
            downloadmode=1
            shift
            ;;
        -l | -L | --link-only)
            linkonlymode=1
            exportfilepath=$2
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
        --webhookinterval)
            webhookinterval=$2
            shift 2
            ;;
        --naturalinterval)
            naturalinterval=$2
            shift 2
            ;;
        --pixiv-fast-mode)
            pixivmode=1
            shift
            ;;
        --pixiv-halfspeed-mode)
            pixivmode=0
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
            echo "    -s or -S or --site <sitename>: input site name, currently supported: paheal, gelbooru"
            echo "        use localmachine to post or upload pics in local file (like bein' generated in link-only mode) to discord, in this case \$cutie will be your filename"
            echo "    -w or -W or --webhook: use discord webhook to upload hentai, need to paste webhook url into nanako() function"
            echo "        and when you use this mode, you must use -a or -A or --avatar-url to set your avatar, you need to make one yourself and upload to discord and get the link via \"Copy Link\""
            echo "    -n or -N or --natural-mode: use your own account to upload hentai, need to follow the instructions in futaba() function"
            echo "    -m or -M or --message <message>: send a message usin' either methods, in this mode the cutie name will become your bot's name (if you use webhook)"
            echo "    -u or -U or --upload <filepath> <message>: upload a file usin' either methods, in this mode the cutie name will become your bot's name (if you use webhook)"
            echo "        and i've found a strange bug out here, now it would be better if you put -u or -U or --upload as the last parameter and all will be fine"
            echo "    -c or -C or --config-file <configfilepath>: load a configuration file which contains three lines of webhook url, account curl command and account curl command (used to upload); if you don't load one it will use default values in the script"
            echo "    -d or -D or --download: download pics and upload to discord instead of just postin' links"
            echo "    -l or -L or --link-only <exportfilepath>: only export hentai pics links to file"
            echo "    --troll <trollname>: replace die deutsche Orthopädiespezialist in the copyrekt message to something else"
            echo "    --silent: omit all of messages except pics, may be useful in some cases"
            echo "    --webhookinterval <newinterval>: override webhook mode hentei interval in the script"
            echo "    --naturalinterval <newinterval>: override natural mode hentei interval in the script"
            echo "    --pixiv-fast-mode: only use the list page info to dump pixiv pics"
            echo "    --pixiv-halfspeed-mode: use id page info to dump pixiv pics, but faster than full mode"

            echo "    -h or -H or --help: this shit"
            echo
            echo "Cutie: "
            echo "    pls input an ACTUALLY EXISTED search term or tag, you can look up by addin' \"site:<your site>\" on Google to make sure it exists. And pls include \"_\" if it has one"
            echo "    eg. futaba's page on gelbooru.com is https://gelbooru.com/index.php?page=post&s=list&tags=sakura_futaba and what you need to input is \"sakura_futaba\""
            echo "        the display name for your cutie (\$cutie_name) can be different from the search term or tag (\$cutie), but if you don't input one it will be automatically generated from the tag"
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

if [ ! $mode ]
then
    echo "Houston, we have an arsefockin' problem: Webbook mode or Natural mode? " >&2
    exit -1
fi

if [ $mode == 0 ] && [ ! "$avatarurl" ]
then
    echo "Houston, we have an arsefockin' problem: Avatar url required while usin' Webhook mode" >&2
    exit 3
fi

if [ $configmode ]
then
    webhook_url=`sed -n 1p "$configfilepath"`
    curl_command=`sed -n 2p "$configfilepath"`
    curl_command_upload=`sed -n 3p "$configfilepath"`
fi

if [ ! $messagemode ] && [ ! $uploadmode ]
then
    if [ ! "$cutie" ]
    then 
        echo "Houston, we have an arsefockin' problem: Cutie required" >&2
        exit 4
    fi
else
    if [ $messagemode ]
    then
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
    if [ $uploadmode ]
    then
        case "$mode" in
        0)
            hifumi "$message" "$filepath"
            ;;
        1)
            makoto "$message" "$filepath"
            ;;
        esac
        exit
    fi
fi

if [ ! $site ]
then
    echo "Houston, we have an arsefockin' problem: You need to input a hentai site" >&2
    exit 5
fi

######################################################################################################################################################################

######################################################################################################################################################################
# info-message-related functions start here

function message_general() { # [ with one parameter <message> ]
    if [ ! $silentmode ] && [ ! $linkonlymode ]
    then
        case "$mode" in
            0)
                nanako "$1"
                ;;
            1)
                futaba "$1"
                ;;
        esac
    else
        echo -e "\e[36m$1\e[0m"
    fi
}

function initmessage() {
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
        pixiv)
            sitename="pixiv.net"
            ;;
        localmachine)
            sitename="idk.what.it.is"
            ;;
        localmachine_pixiv)
            sitename="pixiv.net"
            ;;
        *)
            echo "fock it" >&2
            exit 6
    esac
    message="$sitename rule34 fully automatic masspostin' bot developed by **$author**"
    message_general "$message"

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
        pixiv)
            message="FYI, the cutie's name is **$cutie_name**, and this hentai has exactly **$finalfish** post(s), and the hentai update interval is set to **$nein** second(s), so enjoy your fockin' hentai <:funny_v1:449451139063218177><:funny_v1:449451139063218177><:funny_v1:449451139063218177><:funny_v1:449451139063218177><:funny_v1:449451139063218177>"
                ;;
        localmachine)
            message="FYI, the cutie's name is **$cutie_name**, and idk how many pics does this hentai have (and idc either<:funny_v1:449451139063218177>), and the hentai update interval is set to **$nein** second(s), so enjoy your fockin' hentai <:funny_v1:449451139063218177><:funny_v1:449451139063218177><:funny_v1:449451139063218177><:funny_v1:449451139063218177><:funny_v1:449451139063218177>"
                ;;
        localmachine_pixiv)
            message="FYI, the cutie's name is **$cutie_name**, but idk how many pics does this hentai have (and idc either<:funny_v1:449451139063218177>), and the hentai update interval is set to **$nein** second(s), so enjoy your fockin' hentai <:funny_v1:449451139063218177><:funny_v1:449451139063218177><:funny_v1:449451139063218177><:funny_v1:449451139063218177><:funny_v1:449451139063218177>"
                ;;
        *)
            echo "fock it" >&2
            exit 6
    esac
    message_general "$message"
}

function finalmessage() {
    message="Thanks for usin' this shitty arse bot, see u next time<:funny_v1:449451139063218177><:funny_v1:449451139063218177><:funny_v1:449451139063218177><:funny_v1:449451139063218177><:funny_v1:449451139063218177>"
    message_general "$message"
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
        echo "$hentai" >> "$exportfilepath"
    fi
}

function processhentai_pixiv() {
    if [ ! $linkonlymode ]
    then
        mkdir temp
        cd temp
        rm *.* -f
        message_general "uploadin' $hentai"
        eval "wget ${shitty_arse_pixiv_parameter//-H /--header=} '$hentai'"
        for file in `ls | sed 's/ /|/g'`
        do
            file=`echo $file | sed 's/|/ /g'`
            case "$mode" in
                0)
                    hifumi "$hentai" "$file"
                    # sleep "$webhookinterval"
                    ;;
                1)
                    makoto "$hentai" "$file"
                    # sleep "$naturalinterval"
                    ;;
            esac >> "$currentdir/$cutie.pixivlog.txt"
        done
        rm *.* -f
        cd ..
    else
        echo "wget ${shitty_arse_pixiv_parameter//-H /--header=} '$hentai'" >> "$exportfilepath" # just an example, idk if it's useful any fockin' way
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

function localmachine_pixiv() {
    initmessage

    for file in `cat "$cutie" | sed 's/ /|/g'`
    do
        mkdir temp
        cd temp
        rm *.* -f
        eval `echo $file | sed 's/|/ /g'`
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
            esac >> "$currentdir/$cutie.pixivlog.txt"
        done
        rm *.* -f
        cd ..
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
        for hentailink in `curl "$url" | sed 's/>/\n/g' |  grep -Eo "view&amp;id=[0-9]*" |  sed 's/view&amp;id=//g'` # find id's
        do
            hentai=`curl "https://gelbooru.com/index.php?page=post&s=view&id=$hentailink" | sed 's/\/li/\n/g' | grep -Eo "<li><a href=\".*\" style=\"font-weight: bold;\">Original image" | sed 's/<li><a href="//g' | sed 's/" style="font-weight: bold;">Original image//g' | sed 's/" target="_blank//g'`
            processhentai
        done
    done

    finalmessage
}

function pixiv() {
    url="https://www.pixiv.net/search.php?word=$cutie&order=date_d&mode=r18" # it would be better if use japanese keyword
    finalfish=`eval "curl '$url' $shitty_arse_pixiv_parameter" | grep "og.*に関する作品は[0-9]*件投稿" | grep -Eo [0-9]*`
    if [ ! "$cutie_name" ]
    then
        cutie_name=`echo $cutie | sed 's/_/ /g'`
    fi

    initmessage

    finalfish=`expr $finalfish / 40 + 1`
    for fish in `seq 1 $finalfish`
    do
        url="https://www.pixiv.net/search.php?word=$cutie&order=date_d&mode=r18&p=$fish"
        for hentaiinfo in `eval "curl '$url' $shitty_arse_pixiv_parameter" | sed 's/ /|/g' | sed 's/&quot;/"/g' | sed 's/{"illustId"/\n{"illustId"/g' | grep "illustId"` # find id's and pagecounts
        do
            hentaiid=`echo "$hentaiinfo" | sed 's/|/ /g' | grep -Eo '"illustId":"[0-9]*"' | grep -Eo [0-9]*`
            hentaipages=`echo "$hentaiinfo" | sed 's/|/ /g' | grep -Eo '"pageCount":[0-9]*' | grep -Eo [0-9]*`
            message_general "Analyin' https://www.pixiv.net/member_illust.php?mode=medium&illust_id=$hentaiid"
            message_general "Found **$hentaipages** pic(s)"
            message_general "https://www.pixiv.net/member_illust.php?mode=medium&illust_id=$hentaiid processin' started"
            if [ $hentaipages -eq 1 ]
            then # single-pic page cumfirmed
                hentai=`eval "curl 'https://www.pixiv.net/member_illust.php?mode=medium&illust_id=$hentaiid' $shitty_arse_pixiv_parameter" | sed 's/,/\n/g' | grep -Eo "original.*" | sed 's/\\\//g' | grep -Eo "https.*" | sed 's/"}//g'`
                processhentai_pixiv # needs $hentai AND $hentaiid to work
            else # multi-pic page cumfirmed
                for bighentai in `eval "curl 'https://www.pixiv.net/member_illust.php?mode=manga&illust_id=$hentaiid' $shitty_arse_pixiv_parameter" | sed 's/\&amp;/\&/g' | sed 's/"/\n/g' | grep "page=[0-9]*"`
                do
                    hentai=`eval "curl 'https://www.pixiv.net$bighentai' $shitty_arse_pixiv_parameter" | grep -Eo "img src.*\" " | sed 's/img src="//g' | sed 's/" //g'`
                    processhentai_pixiv
                done
            fi
            message_general "https://www.pixiv.net/member_illust.php?mode=medium&illust_id=$hentaiid done processin'"
        done
    done
    
    finalmessage
}

function pixiv_half() {
    url="https://www.pixiv.net/search.php?word=$cutie&order=date_d&mode=r18" # it would be better if use japanese keyword
    finalfish=`eval "curl '$url' $shitty_arse_pixiv_parameter" | grep "og.*に関する作品は[0-9]*件投稿" | grep -Eo [0-9]*`
    if [ ! "$cutie_name" ]
    then
        cutie_name=`echo $cutie | sed 's/_/ /g'`
    fi

    initmessage

    finalfish=`expr $finalfish / 40 + 1`
    for fish in `seq 1 $finalfish`
    do
        url="https://www.pixiv.net/search.php?word=$cutie&order=date_d&mode=r18&p=$fish"
        for hentaiinfo in `eval "curl '$url' $shitty_arse_pixiv_parameter" | sed 's/ /|/g' | sed 's/&quot;/"/g' | sed 's/{"illustId"/\n{"illustId"/g' | grep "illustId"` # find id's and pagecounts
        do
            hentaiid=`echo "$hentaiinfo" | sed 's/|/ /g' | grep -Eo '"illustId":"[0-9]*"' | grep -Eo [0-9]*`
            hentaipages=`echo "$hentaiinfo" | sed 's/|/ /g' | grep -Eo '"pageCount":[0-9]*' | grep -Eo [0-9]*`
            message_general "Analyin' https://www.pixiv.net/member_illust.php?mode=manga&illust_id=$hentaiid"
            message_general "Found **$hentaipages** pic(s)"
            message_general "https://www.pixiv.net/member_illust.php?mode=medium&illust_id=$hentaiid processin' started"
            if [ $hentaipages -eq 1 ]
            then # single-pic page cumfirmed
                hentai=`eval "curl 'https://www.pixiv.net/member_illust.php?mode=medium&illust_id=$hentaiid' $shitty_arse_pixiv_parameter" | sed 's/,/\n/g' | grep -Eo "original.*" | sed 's/\\\//g' | grep -Eo "https.*" | sed 's/"}//g'`
                processhentai_pixiv # needs $hentai AND $hentaiid to work
            else # multi-pic page cumfirmed
                hentaitemp=`eval "curl 'https://www.pixiv.net/member_illust.php?mode=manga_big&illust_id=$hentaiid&page=0' $shitty_arse_pixiv_parameter" | grep -Eo "img src.*\" " | sed 's/img src="//g' | sed 's/" //g'`
                extension=${hentaitemp##*.}
                hentaitemp="${hentaitemp%p[0-9]*}p"
                hentaipages=`expr $hentaipages - 1`
                for fegelein in `seq 0 $hentaipages`
                do
                    hentai="$hentaitemp$fegelein.$extension"
                    processhentai_pixiv # needs $hentai AND $hentaiid to work
                done
            fi
            message_general "https://www.pixiv.net/member_illust.php?mode=medium&illust_id=$hentaiid done processin'"
        done
    done
    
    finalmessage
    echo
}

function pixiv_fast() {
    url="https://www.pixiv.net/search.php?word=$cutie&order=date_d&mode=r18" # it would be better if use japanese keyword
    finalfish=`eval "curl '$url' $shitty_arse_pixiv_parameter" | grep "og.*に関する作品は[0-9]*件投稿" | grep -Eo [0-9]*`
    if [ ! "$cutie_name" ]
    then
        cutie_name=`echo $cutie | sed 's/_/ /g'`
    fi

    initmessage

    finalfish=`expr $finalfish / 40 + 1`
    for fish in `seq 1 $finalfish`
    do
        url="https://www.pixiv.net/search.php?word=$cutie&order=date_d&mode=r18&p=$fish"
        for hentaiinfo in `eval "curl '$url' $shitty_arse_pixiv_parameter" | sed 's/ /|/g' | sed 's/&quot;/"/g' | sed 's/{"illustId"/\n{"illustId"/g' | grep "illustId"` # find id's and pagecounts
        do
            hentaiid=`echo "$hentaiinfo" | sed 's/|/ /g' | grep -Eo '"illustId":"[0-9]*"' | grep -Eo [0-9]*`
            hentaipages=`echo "$hentaiinfo" | sed 's/|/ /g' | grep -Eo '"pageCount":[0-9]*' | grep -Eo [0-9]*`
            hentaitemp="https://i.pximg.net/img-original/`echo "$hentaiinfo" | sed 's/|/ /g' | sed 's/\\\//g' | sed 's/,/\n/g' | grep -Eo '"url":".*"' | sed 's/"/\n/g' | grep "http" | grep -Eo "img/.*p[0-9]" | grep -Eo "img/.*p"`"
            message_general "Analyin' https://www.pixiv.net/member_illust.php?mode=manga&illust_id=$hentaiid"
            message_general "Found **$hentaipages** pic(s)"
            message_general "https://www.pixiv.net/member_illust.php?mode=medium&illust_id=$hentaiid processin' started"
            hentaipages=`expr $hentaipages - 1`
            for fegelein in `seq 0 $hentaipages`
            do
                hentai="$hentaitemp$fegelein.jpg"
                processhentai_pixiv # needs $hentai AND $hentaiid to work
                hentai="$hentaitemp$fegelein.png"
                processhentai_pixiv # needs $hentai AND $hentaiid to work
            done
            message_general "https://www.pixiv.net/member_illust.php?mode=medium&illust_id=$hentaiid done processin'"
        done
    done
    
    finalmessage
}

echo $site

case "$site" in
    paheal)
        paheal
        ;;
    gelbooru)
        gelbooru
        ;;
    pixiv)
        if [ ! $downloadmode ]
        then
            echo "Houston, we have an arsefockin' problem: pivix.net MUST use download mode to process, because hentai pics of it cannot be processed by discord" >&2
            exit 7
        else
            case "$pixivmode" in
                1)
                    pixiv_fast
                    ;;
                0)
                    pixiv_half
                    ;;
                *)
                    pixiv
                    ;;
            esac
        fi
        ;;
    localmachine)
        if [ $linkonlymode ]
        then
            echo "Houston, we have an arsefockin' problem: For arsefockin' obvious reason, you cannot use link-only mode when usin' local pic source" >&2
            exit 7
        else
            localmachine
        fi
        ;;
    localmachine_pixiv)
        if [ $linkonlymode ]
        then
            echo "Houston, we have an arsefockin' problem: For arsefockin' obvious reason, you cannot use link-only mode when usin' local pic source" >&2
            exit 7
        else
            localmachine_pixiv
        fi
        ;;
    *)
        echo "Houston, we have an arsefockin' problem: Site currently not supported" >&2
        exit 6
esac
