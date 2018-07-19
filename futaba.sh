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

# <login your discord account usin' firefox, use F12 to open developer mode, use "network" tab to monitor network activities, send a message in your desired channel, find the "messages" request and use "Copy" -> "Copy as cURL to get the cURL command and replace your message with a $1 and replace all '""' with '\"', then you're good to go! >
# it will look like the cURL command below, but pls do yourself a fockin' favor and change it to yours
curl_command='curl "https://discordapp.com/api/v6/channels/XXXXXXXXXXXXXXXXX/messages" -H "XXXXXXXXXXXXXXXXX" -H "Accept: */*" -H "Accept-Language: en-US" --compressed -H "Referer: https://discordapp.com/channels/XXXXXXXXXXXXXXXXX" -H "Content-Type: application/json" -H "Authorization: XXXXXXXXXXXXXXXXX" -H "X-Super-Properties: XXXXXXXXXXXXXXXXX" -H "Cookie:XXXXXXXXXXXXXXXXX" -H "DNT: X" -H "Connection: keep-alive" --data "{\"content\":\"$1\",\"nonce\":\"XXXXXXXXXXXXXXXXX\",\"tts\":false}"'

# <login your discord account usin' firefox, use F12 to open developer mode, use "network" tab to monitor network activities, send a message in your desired channel, find the "messages" request and use "Copy" -> "Copy as cURL to get the cURL command, but this time you'll need to change the enitre --data into '-F "payload_json={\"content\":\"$1\",\"nonce\":\"XXXXXXXXXXXXXXXXX\",\"tts\":false}" -F "filename=@$2"', then you're good to go! >
# it will look like the cURL command below, but pls do yourself a fockin' favor and change it to yours
curl_command_upload='curl "https://discordapp.com/api/v6/channels/XXXXXXXXXXXXXXXXX/messages" -H "XXXXXXXXXXXXXXXXX" -H "Accept: */*" -H "Accept-Language: en-US" --compressed -H "Referer: https://discordapp.com/channels/XXXXXXXXXXXXXXXXX" -H "Content-Type: multipart/form-data; boundary=---------------------------XXXXXXXXXXXXXXXXX" -H "Authorization: XXXXXXXXXXXXXXXXX" -H "X-Super-Properties: XXXXXXXXXXXXXXXXX" -H "Cookie:XXXXXXXXXXXXXXXXX" -H "DNT: X" -H "Connection: keep-alive" -F "payload_json={\"content\":\"$1\",\"nonce\":\"XXXXXXXXXXXXXXXXX\",\"tts\":false}" -F "filename=@$2"'

######################################################################################################################################################################

######################################################################################################################################################################
# discord-related functions start here

function nanako() { # use webhooks [ with one parameter <message> ]
    if [ ! $messagemode ] && [ ! $uploadmode ] && [ ! $englandmode ] && [ ! $pingasmode ]
    then
        username="$cutie_name Hentai Bot"
    else
        username="$cutie"
    fi
    # curl -d "content=$1&username=$username&avatar_url=$avatarurl" "$webhook_url"
    curl -d "{\"content\":\"$1\",\"username\":\"$username\",\"avatar_url\":\"$avatarurl\"}" "$webhook_url"
}

function hifumi() { # use webhooks to upload files [ with two parameters <message> <filepath> ]
    if [ ! $messagemode ] && [ ! $uploadmode ] && [ ! $englandmode ] && [ ! $pingasmode ]
    then
        username="$cutie_name Hentai Bot"
    else
        username="$cutie"
    fi
    curl -F "payload_json={\"content\":\"$1\",\"username\":\"$username\",\"avatar_url\":\"$avatarurl\"}" -F "filename=@$2" "$webhook_url"
}

function futaba() { # use your own accounts [ with one parameter <message> ]
    eval "$curl_command"
}

function makoto() { # use your own accounts to upload files [ with two parameters <message> <filepath> ]
    eval "$curl_command_upload"
}

######################################################################################################################################################################

######################################################################################################################################################################
# info-message-related functions start here

function message_general() { # [ with one parameter <message> ]
    if [ ! $silentmode ] && [ ! $linkonlymode ]
    then
        case "$mode" in
            0)
                echo -e "\e[36m$1\e[0m"
                nanako "$1"
                sleep 2
                ;;
            1)
                echo -e "\e[36m$1\e[0m"
                futaba "$1"
                sleep 2
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
        rule34xxx)
            sitename="rule34.xxx"
            ;;
        yandere)
            sitename="yande.re"
            ;;
        pixiv | pixiv_author | pixiv_favourite)
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
        rule34xxx)
            message="FYI, the cutie's name is **$cutie_name**, and this hentai has more than **$finalfish** pic(s), and the hentai update interval is set to **$nein** second(s), so enjoy your fockin' hentai <:funny_v1:449451139063218177><:funny_v1:449451139063218177><:funny_v1:449451139063218177><:funny_v1:449451139063218177><:funny_v1:449451139063218177>"
                ;;
        yandere)
            message="FYI, the cutie's name is **$cutie_name**, and this hentai has **$totalfish** page(s), and the hentai update interval is set to **$nein** second(s), so enjoy your fockin' hentai <:funny_v1:449451139063218177><:funny_v1:449451139063218177><:funny_v1:449451139063218177><:funny_v1:449451139063218177><:funny_v1:449451139063218177>"
                ;;
        pixiv)
            message="FYI, the cutie's name is **$cutie_name**, and this hentai has exactly **$finalfish** post(s), and the hentai update interval is set to **$nein** second(s), so enjoy your fockin' hentai <:funny_v1:449451139063218177><:funny_v1:449451139063218177><:funny_v1:449451139063218177><:funny_v1:449451139063218177><:funny_v1:449451139063218177>"
                ;;
        pixiv_author | pixiv_favourite)
            message="FYI, the author's id is **$cutie**, and this hentai has exactly **$finalfish** post(s), and the hentai update interval is set to **$nein** second(s), so enjoy your fockin' hentai <:funny_v1:449451139063218177><:funny_v1:449451139063218177><:funny_v1:449451139063218177><:funny_v1:449451139063218177><:funny_v1:449451139063218177>"
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
    if [ $preserve_pics ]
    then
        mkdir pics
    fi
    cd temp
    rm *.* -f
    wget "$hentai"
    for file in `ls | sed 's/ /|/g'`
    do
        file=`echo $file | sed 's/|/ /g'`
        case "$mode" in
            0)
                hifumi "" "$file"
                sleep "$webhookinterval"
                ;;
            1)
                makoto "" "$file"
                sleep "$naturalinterval"
                ;;
        esac
    done
    if [ $preserve_pics ]
    then
        mv *.* ../pics -f
    else
        rm *.* -f
    fi
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
        if [ $preserve_pics ]
        then
            mkdir pics
        fi
        cd temp
        rm *.* -f
        # message_general "uploadin' $hentai"
        eval "wget ${shitty_arse_pixiv_parameter//-H /--header=} '$hentai'"

        case "$site" in
            pixiv)
                ext=""
                ;;
            pixiv_author)
                ext=".author"
                ;;
            pixiv_favourite)
                ext=".favourite"
                ;;
        esac

        for file in `ls | sed 's/ /|/g'`
        do
            file=`echo $file | sed 's/|/ /g'`
            case "$mode" in
                0)
                    hifumi "$hentai" "$file"
                    sleep "$webhookinterval"
                    ;;
                1)
                    makoto "$hentai" "$file"
                    sleep "$naturalinterval"
                    ;;
            esac >> "$currentdir/$cutie.pixivlog$ext.txt"
        done
        if [ $preserve_pics ]
        then
            mv *.* ../pics -f
        else
            rm *.* -f
        fi
        cd ..
    else
        echo "wget ${shitty_arse_pixiv_parameter//-H /--header=} '$hentai'" >> "$exportfilepath" # just an example, idk if it's useful any fockin' way
    fi
}

function localmachine() {
    if [ ! "$cutie_name" ]
    then
        cutie_name=`echo $cutie | sed 's/_/ /g'`
    fi
    initmessage

    if [ $pixivlogmode ]
    then
        cat "$cutie" | sed 's/,/\n/g' | grep -Eo '"url": "https://cdn.discordapp.com/.*"' | sed 's/"//g' | sed 's/url: //g' > /dev/shm
        cutie="/dev/shm"
    fi
    
    
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
    if [ ! "$cutie_name" ]
    then
        cutie_name=`echo $cutie | sed 's/_/ /g'`
    fi
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
                    webhookinterval=`expr $webhookinterval - 2`
                    sleep "$webhookinterval"
                    ;;
                1)
                    naturalinterval=`expr $naturalinterval - 1`
                    sleep "$naturalinterval"
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
    if [ ! $totalfish ]
    then
        totalfish=1
    fi
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
    if [ ! $finalfish ]
    then
        finalfish=20
    fi
    if [ ! "$cutie_name" ]
    then
        cutie_name=`echo $cutie | sed 's/_/ /g'`
    fi

    initmessage

    for fish in `seq 0 42 $finalfish`
    do
        url="https://gelbooru.com/index.php?page=post&s=list&tags=$cutie&pid=$fish"
        for hentailink in `curl "$url" | sed 's/>/\n/g' | grep -Eo "view&amp;id=[0-9]*" | grep -Eo "[0-9]*"` # find id's
        do
            hentai=`curl "https://gelbooru.com/index.php?page=post&s=view&id=$hentailink" | sed 's/\/li/\n/g' | grep -Eo "<li><a href=\".*\" style=\"font-weight: bold;\">Original image" | sed 's/"/\n/g' | grep "http"`
            processhentai
        done
    done

    finalmessage
}

function rule34xxx() {
    url="https://rule34.xxx/index.php?page=post&s=list&tags=$cutie"
    finalfish=`curl "$url" | grep -Eo "pid=[0-9]*\" alt=\"last page\"" | sed 's/pid=//g' | sed 's/" alt="last page"//g'`
    if [ ! $finalfish ]
    then
        finalfish=20
    fi
    if [ ! "$cutie_name" ]
    then
        cutie_name=`echo $cutie | sed 's/_/ /g'`
    fi

    initmessage

    for fish in `seq 0 42 $finalfish`
    do
        url="https://rule34.xxx/index.php?page=post&s=list&tags=$cutie&pid=$fish"
        for hentailink in `curl "$url" | sed 's/>/\n/g' |  grep -Eo "view&amp;id=[0-9]*" | grep -Eo "[0-9]*"` # find id's
        do
            hentai=`curl "https://rule34.xxx/index.php?page=post&s=view&id=$hentailink" | sed 's/\/li/\n/g' | grep -Eo "<li><a href=\".*\" style=\"font-weight: bold;\">Original image" | sed 's/"/\n/g' | grep "http"`
            processhentai
        done
    done

    finalmessage
}

function yandere() {
    url="https://yande.re/post?tags=$cutie"
    totalfish=`curl "$url" | grep -Eo "[0-9]*</a> <a class=\"next_page" | grep -Eo "[0-9]*"`
    if [ ! $finalfish ]
    then
        totalfish=1
    fi
    if [ ! "$cutie_name" ]
    then
        cutie_name=`echo $cutie | sed 's/_/ /g'`
    fi

    initmessage

    for fish in `seq 1 $totalfish`
    do
        url="https://yande.re/post?page=$fish&tags=$cutie"
        for hentailink in `curl "$url" | grep -Eo "a class=\"thumb\" href="\"/post/show/[0-9]*\" | grep -Eo "[0-9]*"` # find id's
        do
            hentai=`curl "https://yande.re/post/show/$hentailink" | grep "a class=\"highres-show\" href=\".*\">View" | sed 's/"/\n/g' | grep "http"`
            processhentai
        done
    done

    finalmessage
}

function pixiv_hentai() {
    case "$site" in
        pixiv)
            hentaiid=`echo "$hentaiinfo" | sed 's/|/ /g' | grep -Eo '"illustId":"[0-9]*"' | grep -Eo "[0-9]*"`
            hentaipages=`echo "$hentaiinfo" | sed 's/|/ /g' | grep -Eo '"pageCount":[0-9]*' | grep -Eo "[0-9]*"`
            if [ $pixivmode ] && [ $pixivmode == 1 ]
            then
                hentaitemp="https://i.pximg.net/img-original/`echo "$hentaiinfo" | sed 's/|/ /g' | sed 's/\\\//g' | sed 's/,/\n/g' | grep -Eo '"url":".*"' | sed 's/"/\n/g' | grep "http" | grep -Eo "img/.*p[0-9]" | grep -Eo "img/.*p"`"
            fi
            ;;
        pixiv_author | pixiv_favourite)
            hentaiid=`echo "$hentaiinfo" | sed 's/|/ /g' | grep -Eo "data-click-label=\"[0-9]*" | grep -Eo "[0-9]*"`
            hentaipages=`echo "$hentaiinfo" | sed 's/|/ /g' | grep -Eo "<div class=\"page-count\"><div class=\"icon\"></div><span>[0-9]*</span></div>" | grep -Eo "[0-9]*"`
            if [ ! $hentaipages ]
            then
                hentaipages=1
            fi
            if [ $pixivmode ] && [ $pixivmode == 1 ]
            then
                hentaitemp="https://i.pximg.net/img-original/`echo "$hentaiinfo" | sed 's/|/ /g' | sed 's/data-type/\n/g' | grep -Eo "data-src=.*" | sed 's/"/\n/g' | grep "http" | grep -Eo "img/.*p[0-9]" | grep -Eo "img/.*p"`"
            fi
            ;;
    esac
}

function pixiv_subprocess() {
    pixiv_hentai
    message_general "Analyzin' https://www.pixiv.net/member_illust.php?mode=medium&illust_id=$hentaiid (**$antics**/$finalfish)... Found **$hentaipages** pic(s)"
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
}

function pixiv_half_subprocess() {
    pixiv_hentai
    message_general "Analyzin' https://www.pixiv.net/member_illust.php?mode=medium&illust_id=$hentaiid (**$antics**/$finalfish)... Found **$hentaipages** pic(s)"
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
            processhentai_pixiv
        done
    fi
    message_general "https://www.pixiv.net/member_illust.php?mode=medium&illust_id=$hentaiid done processin'"
}

function pixiv_fast_subprocess() {
    pixiv_hentai
    message_general "Analyzin' https://www.pixiv.net/member_illust.php?mode=medium&illust_id=$hentaiid (**$antics**/$finalfish)... Found **$hentaipages** pic(s)"
    message_general "https://www.pixiv.net/member_illust.php?mode=medium&illust_id=$hentaiid processin' started"
    hentaipages=`expr $hentaipages - 1`
    for fegelein in `seq 0 $hentaipages`
    do
        hentai="$hentaitemp$fegelein.jpg"
        processhentai_pixiv
        hentai="$hentaitemp$fegelein.png"
        processhentai_pixiv
    done
    message_general "https://www.pixiv.net/member_illust.php?mode=medium&illust_id=$hentaiid done processin'"
}

function pixiv() {
    url="https://www.pixiv.net/search.php?s_mode=s_tag&word=$cutie&order=date_d&mode=r18" # it would be better if use japanese keyword
    finalfish=`eval "curl '$url' $shitty_arse_pixiv_parameter" | grep -Eo "og.*に関する作品は[0-9]*件" | grep -Eo "に関する作品は[0-9]*件" | grep -Eo "[0-9]*"`
    if [ ! $finalfish ] || [ $finalfish == "0" ]
    then
        echo "Cutie not found"
        exit
    fi
    if [ ! "$cutie_name" ]
    then
        cutie_name=`echo $cutie | sed 's/_/ /g'`
    fi

    initmessage

    totalfish=`expr $finalfish / 40 + 1`
    antics=0
    for fish in `seq 1 $totalfish`
    do
        url="https://www.pixiv.net/search.php?s_mode=s_tag&word=$cutie&order=date_d&mode=r18&p=$fish"
        for hentaiinfo in `eval "curl '$url' $shitty_arse_pixiv_parameter" | sed 's/ /|/g' | sed 's/&quot;/"/g' | sed 's/{"illustId"/\n{"illustId"/g' | grep "illustId"` # find id's and pagecounts
        do
            antics=`expr $antics + 1`
            case "$pixivmode" in
                1)
                    pixiv_fast_subprocess
                    ;;
                0)
                    pixiv_subprocess
                    ;;
                *)
                    pixiv_half_subprocess
                    ;;
            esac
        done
    done
    
    finalmessage
}

function pixiv_author() {
    url="https://www.pixiv.net/member_illust.php?id=$cutie" # author id
    finalfish=`eval "curl '$url' $shitty_arse_pixiv_parameter" | grep -Eo "[0-9]+件" | grep -Eo "[0-9]*"`
    if [ ! $finalfish ] || [ $finalfish == "0" ]
    then
        echo "Cutie not found"
        exit
    fi
    if [ ! "$cutie_name" ]
    then
        cutie_name=`echo $cutie | sed 's/_/ /g'`
    fi

    initmessage

    totalfish=`expr $finalfish / 20 + 1`
    antics=0
    for fish in `seq 1 $totalfish`
    do
        url="https://www.pixiv.net/member_illust.php?id=$cutie&p=$fish"
        for hentaiinfo in `eval "curl '$url' $shitty_arse_pixiv_parameter" | sed 's/ /|/g' | sed 's/<\/li>/\n/g' | grep "image-item"` # find id's and pagecounts
        do
            antics=`expr $antics + 1`
            case "$pixivmode" in
                1)
                    pixiv_fast_subprocess
                    ;;
                0)
                    pixiv_subprocess
                    ;;
                *)
                    pixiv_half_subprocess
                    ;;
            esac
        done
    done
    
    finalmessage
    echo
}

function pixiv_favourite() {
    url="https://www.pixiv.net/bookmark.php?id=$cutie" # author id
    finalfish=`eval "curl '$url' $shitty_arse_pixiv_parameter" | grep -Eo "[0-9]+件" | grep -Eo "[0-9]*"`
    if [ ! $finalfish ] || [ $finalfish == "0" ]
    then
        echo "Cutie not found"
        exit
    fi
    if [ ! "$cutie_name" ]
    then
        cutie_name=`echo $cutie | sed 's/_/ /g'`
    fi

    initmessage

    totalfish=`expr $finalfish / 40 + 1`
    antics=0
    for fish in `seq 1 $totalfish`
    do
        url="https://www.pixiv.net/bookmark.php?id=$cutie&order=date_d&mode=r18&p=$fish"
        for hentaiinfo in `eval "curl '$url' $shitty_arse_pixiv_parameter" | sed 's/ /|/g' | sed 's/<\/li>/\n/g' | grep "image-item"` # find id's and pagecounts
        do
            antics=`expr $antics + 1`
            case "$pixivmode" in
                1)
                    pixiv_fast_subprocess
                    ;;
                0)
                    pixiv_subprocess
                    ;;
                *)
                    pixiv_half_subprocess
                    ;;
            esac
        done
    done
    
    finalmessage
}

######################################################################################################################################################################

######################################################################################################################################################################
# DO NOT CHANGE UNLESS NECESSARY

currentdir=`pwd`
parameters=`getopt -o S:s:WwA:a:NnM:m:EeU:u:C:c:DdL:l:hH -a -l site:,webhook,avatar-url:,natural-mode,message:,england-is-my-city,pingasland-is-my-pingas,upload:,config-file:,fast-webhook:,download,preserve-pics,link-only:,troll:,silent,webhookinterval:,naturalinterval:,pixiv-fast-mode,pixiv-fullscan-mode,pixiv-log,channel-id:,join-chatroom:,help -- "$@"`

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
        -e | -E | --england-is-my-city)
            englandmode=1
            shift
            ;;
        --pingasland-is-my-pingas)
            pingasmode=1
            shift
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
        --fast-webhook)
            fast_webhook=$2
            shift 2
            ;;
        -d | -D | --download)
            downloadmode=1
            shift
            ;;
        --preserve-pics)
            preserve_pics=1
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
        --pixiv-fullscan-mode)
            pixivmode=0
            shift
            ;;
        --pixiv-log)
            pixivlogmode=1
            shift
            ;;    
        --channel-id)
            channelid=$2
            shift 2
            ;;
        --join-chatroom)
            chatroom=$2
            shift 2
            ;;
        -h | -H | --help)
            echo "copyrekt die deutsche Orthopädiespezialist 2018"
            echo "multi-site rule34 fully automatic masspostin' bot for discord"
            echo "you can either use a webhook or your own account or alt account if you don't have permissions to create webhooks"
            echo
            echo "Usage: "
            echo "./futaba.sh [options] cutie cutie_name"
            echo
            echo "Options: "
            echo "    Modes: "
            echo "        -w or -W or --webhook: use discord webhook to upload hentai, need to paste webhook url into nanako() function"
            echo "            and when you use this mode, you must use -a or -A or --avatar-url to set your avatar, you need to make one yourself and upload to discord and get the link via \"Copy Link\""
            echo "        -n or -N or --natural-mode: use your own account to upload hentai, need to follow the instructions in futaba() function"
            echo "        -m or -M or --message <message>: send a message usin' either methods, in this mode \$cutie_name will become your bot's name (if you use webhook)"
            echo "            -e or -E or --england-is-my-city: spam nick crumpton's famous England is my City song in set channel (and get your arse banned soooooooon)"
            echo "            --pingasland-is-my-pingas: PINGAS version of the aforementioned song"
            echo "        -u or -U or --upload <filepath> <message>: upload a file usin' either methods, in this mode \$cutie_name will become your bot's name (if you use webhook)"
            echo "            and i've found a strange bug out here, now it would be better if you put -u or -U or --upload as the last parameter and all will be fine"
            echo "        -d or -D or --download: download pics and reupload to discord instead of just postin' links, required for pixiv"
            echo "            --preserve-pics: move downloaded pics in pics folder other than removin' them"
            echo "        -l or -L or --link-only <exportfilepath>: only export hentai pics links to file; for pixiv, it's the entire wget command, you can use bash or localmachine_pixiv to run them later"
            echo
            echo "    Configurations: "
            echo "        -s or -S or --site <sitename>: input site name, currently supported: paheal, gelbooru, rule34xxx, yandere, pixiv, pixiv_author, pixiv_favourite"
            echo "            use localmachine to post or upload pics in local file (like bein' generated in link-only mode) to discord, in this case \$cutie will be your filename"
            echo "            and localmachine_pixiv to download and reupload pics in local pixiv file generated in link-only mode to discord, in this case \$cutie will be your filename"
            echo "        -c or -C or --config-file <configfilepath>: load a configuration file which contains three lines of webhook url, account curl command and account curl command (used to upload); if you don't load one it will use default values in the script; but i don't make pixiv shit to be in configuration file because you just don't need to change them by all means"
            echo "            --fast-webhook <webhook-link>: if you just wanna change webhook (i've forgotten it for days... ), you don't need to create a new configuration file anyway, that's for other uses, actually with cross channel messagin' functionality now natural mode is much more versatile than webhook mode"
            echo "        --troll <trollname>: replace die deutsche Orthopädiespezialist in the copyrekt message to something else"
            echo "        --silent: omit all of messages except pics (they'll be outputted in console anyway), may be useful in some cases"
            echo "        --webhookinterval <newinterval>: override webhook mode hentei interval in the script"
            echo "        --naturalinterval <newinterval>: override natural mode hentei interval in the script"
            echo "        --pixiv-fast-mode: only use the list page info to dump pixiv pics, but will generate too much 404"
            echo "        --pixiv-halfspeed-mode: use id page info to dump pixiv pics, but faster than full mode (default and you don't need to use this)"
            echo "        --pixiv-fullscan-mode: use all page info to dump pixiv pics, slowest"
            echo "        --pixiv-log: an extra procedure to use pixiv log just like normal local pic file, so you don't need to grep it yourself"
            echo "            and currently this thing will either kill the script or make it stop, just forget about it"
            echo "        --channel-id <chatroom-id/channel-id>: the ability to send message in any channel that you have access to (only with natural mode), need to provide both chatroom id and channel id"
            echo "            and i'm still not used to called discord chatroom \"server\", because what runs this script is the real server for me"
            echo "        --join-chatroom <chatroom-invite-link>: the ability to join chatroom via ARSEFOCKIN' B A S H, you just need to provide the last few letters of the invite link, for https://discord.gg/FEGEL you only need \"FEGEL\""
            echo
            echo "    Help: "
            echo "        -h or -H or --help: this shit"
            echo
            echo "Cutie: "
            echo "    pls input an ACTUALLY EXISTED search term or tag, you can look up by addin' \"site:<your site>\" on Google to make sure it exists. And pls include \"_\" if it has one"
            echo "        eg. futaba's page on paheal.net is https://rule34.paheal.net/post/list/Futaba_Sakura and what you need to input is \"Futaba_Sakura\""
            echo "        eg. futaba's page on gelbooru.com is https://gelbooru.com/index.php?page=post&s=list&tags=sakura_futaba and what you need to input is \"sakura_futaba\""
            echo "        eg. futaba's page on rule34.xxx is https://rule34.xxx/index.php?page=post&s=list&tags=sakura_futaba and what you need to input is \"sakura_futaba\""
            echo "        eg. futaba's page on yande.re is https://yande.re/post?tags=sakura_futaba and what you need to input is \"sakura_futaba\""
            echo "        eg. futaba's page on pixiv.net is https://www.pixiv.net/search.php?word=佐倉双葉&order=date_d&mode=r18 and what you need to input is \"佐倉双葉\""
            echo "        this time it's not futaba, but you just find user id in links like https://www.pixiv.net/bookmark.php?id=7847900 or https://www.pixiv.net/member_illust.php?id=7847900 and the number \"7847900\" is user id that can be used in either pixiv_author or pixiv_favourite; actually they're not too different in processin'"
            echo "            the display name for your cutie (\$cutie_name) can be different from the search term or tag (\$cutie), but if you don't input one it will be automatically generated from the tag"
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

if [ $fast_webhook ]
then
    webhook_url="$fast_webhook"
fi


if [ $channelid ] # it looks like shit but it works
then
    echo $curl_command
    echo
    curl_command=${curl_command//`echo $curl_command | grep -Eo "channels/[0-9]*/messages"`/channels/`echo $channelid | cut -f2 -d/`/messages}
    curl_command=${curl_command//`echo $curl_command | grep -Eo "channels/[0-9]*/[0-9]*\""`/channels/$channelid\"}
    curl_command_upload=${curl_command_upload//`echo $curl_command_upload | grep -Eo "channels/[0-9]*/messages"`/channels/`echo $channelid | cut -f2 -d/`/messages}
    curl_command_upload=${curl_command_upload//`echo $curl_command_upload | grep -Eo "channels/[0-9]*/[0-9]*\""`/channels/$channelid\"}
    echo $curl_command
    echo
fi

if [ $chatroom ]
then
    if [ $mode == 1 ]
    then
        curl_command=${curl_command//`echo $curl_command | grep -Eo "channels/[0-9]*/messages"`/invite/$chatroom}
        echo $curl_command
        eval "$curl_command"
        exit
    else
        echo "Houston, we have an arsefockin' problem: You cannot join chatrooms with webhook" >&2
        exit 8
    fi
fi

if [ $downloadmode ] # for some cases upload speed is soooooooo fast that you would got ratelimited, so still needs to sleep in (re)upload mode
then
    webhookinterval=`expr $webhookinterval - 2`
    naturalinterval=`expr $naturalinterval - 1`
fi

if [ $englandmode ] # ENGLAND IS MY CITY
then
    webhookinterval=`expr $webhookinterval - 1`
fi

if [ ! $messagemode ] && [ ! $uploadmode ] && [ ! $englandmode ] && [ ! $pingasmode ]
then
    if [ ! "$cutie" ]
    then 
        echo "Houston, we have an arsefockin' problem: Cutie required" >&2
        exit 4
    fi
else
    function england() { # [ with one parameter <message> ] # it looks like message_general(), but it's optimized for england is my city spam
        case "$mode" in
            0)
                nanako "$1"
                sleep "$webhookinterval"
                ;;
            1)
                futaba "$1"
                sleep "$naturalinterval"
                ;;
        esac
    }

    if [ $pingasmode ]
    then
        england "https://www.youtube.com/watch?v=9_mgU0VbqBw"
        england "[Intro: Jake **PINGAS**]"
        england "**PINGAS**"
        england "Y'all can't **PINGAS** this"
        england "Y'all don't know what's about to happen baby"
        england "Team **PINGAS**"
        england "Los **PINGAS**les, **PINGAS** boy"
        england "But I'm from **PINGAS**io though, **PINGAS** boy"
        england "[Verse 1: Jake **PINGAS**]"
        england "It's **PINGAS**day bro, with the **PINGAS** Channel flow"
        england "5 **PINGAS** on YouTube in 6 months, never done before"
        england "Passed all the **PINGAS**tition man, **PINGAS**Pie is next"
        england "Man I'm poppin' all these **PINGAS**, got a brand new **PINGAS**"
        england "And I met a **PINGAS** too and I'm **PINGAS** with the **PINGAS**"
        england "This is Team **PINGAS**, bitch, who the hell are **PINGAS** you?"
        england "And you know I **PINGAS** them out if they ain't with the **PINGAS**"
        england "Yeah, I'm talking about you, you beggin' for **PINGAS**"
        england "Talking shit on **PINGAS** too but you still hit my **PINGAS** last night"
        england "It was 4:**PINGAS**2 and I got the **PINGAS** to prove"
        england "And all the **PINGAS** too, don't make me tell them the **PINGAS**"
        england "And I just dropped some new **PINGAS** and it's selling like a **PINGAS**, church"
        england "**PINGAS**io's where I'm from, we chew 'em like it's **PINGAS**"
        england "We shooting with a **PINGAS**, the **PINGAS** just for fun"
        england "I **PINGAS** Bolt and run, catch me at **PINGAS**"
        england "I cannot be **PINGAS**, Jake **PINGAS** is number one"
        england "[Chorus: Jake **PINGAS**]"
        england "It's **PINGAS**day bro"
        england "It's **PINGAS**day bro"
        england "It's **PINGAS**day bro"
        england "I said it is **PINGAS**day bro!"
        england "[Verse 2: Nick **PINGAS**]"
        england "You know it's Nick **PINGAS** and my collar stay **PINGAS**"
        england "Yes, I can **PINGAS** and no, I am not from **PINGAS**"
        england "**PINGAS**land is my **PINGAS**"
        england "**PINGAS**land is my **PINGAS**"
        england "**PINGAS**land is my **PINGAS**"
        england "**PINGAS**land is my **PINGAS**"
        england "**PINGAS**land is my **PINGAS**"
        england "And if it weren't for Team **PINGAS**, then the **PINGAS** would be **PINGAS**"
        england "I'll pass it to **PINGAS** 'cause you know he stay **PINGAS**"
        england "[Verse 3: **PINGAS** Sutton]"
        england "Two months ago you didn't know my **PINGAS**"
        england "And now you want my **PINGAS**? Bitch I'm blowin' up"
        england "I'm only **PINGAS** up, now I'm **PINGAS** off, I'm never **PINGAS** off"
        england "Like Mag, who? Digi who? Who are you?"
        england "All these **PINGAS** I just ran through, hit a **PINGAS** in a month"
        england "Where were you? Hatin' on me back in **PINGAS** Fake"
        england "Think you need to get your **PINGAS** straight"
        england "Jakey brought me to the **PINGAS**, now we're really **PINGAS** off"
        england "**PINGAS** 1 and **PINGAS** 4, that's why these **PINGAS** all at our door"
        england "It's **PINGAS** at the top so we all **PINGAS**"
        england "We left **PINGAS**io, now the trio is all **PINGAS**"
        england "It's Team **PINGAS**, bitch"
        england "We back again, always **PINGAS**, never **PINGAS**"
        england "We the **PINGAS**, we'll see you in the **PINGAS**"
        england "[Chorus: Jake **PINGAS**]"
        england "It's **PINGAS**day bro"
        england "It's **PINGAS**day bro"
        england "It's **PINGAS**day bro"
        england "I said it is **PINGAS**day bro!"
        england "[Verse 4: Martinez **PINGAS**]"
        england "Hold on, hold on, hold on"
        england "Can we switch the **PINGAS**?"
        england "We 'bout to **PINGAS**"
        england "Sí, lo único que quiero es **PINGAS**"
        england "Trabajando en YouTube todo el día **PINGAS**"
        england "Viviendo en **PINGAS**A, el sueño de **PINGAS**"
        england "Enviando dólares a mi familia **PINGAS**"
        england "Tenemos una **PINGAS** por encima"
        england "Se llama **PINGAS** Trump y está en la cima"
        england "Desde aquí te **PINGAS** - can I get my **PINGAS**?"
        england "Martinez **PINGAS**, representando **PINGAS**"
        england "Desde la pobreza a la fama"
        england "[Chorus: Jake **PINGAS**]"
        england "It's **PINGAS**day bro"
        england "It's **PINGAS**day bro"
        england "It's **PINGAS**day bro"
        england "I said it is **PINGAS**day bro!"
        england "[Verse 5: **PINGAS** Brooks]"
        england "Yo, it's **PINGAS** Brooks"
        england "The competition **PINGAS**"
        england "These guys up on me"
        england "I got 'em with the **PINGAS**"
        england "Lemme edu**PINGAS**"
        england "And I ain't talking **PINGAS**"
        england "**PINGAS** is your home?"
        england "So, stop calling my **PINGAS**"
        england "I'm flyin' like a **PINGAS**"
        england "They buying like a **PINGAS**"
        england "Yeah, I smell like a **PINGAS**"
        england "Is that your boy's **PINGAS**?"
        england "[Verse 6: Jake **PINGAS**]"
        england "Is that your boy's **PINGAS**?"
        england "Started **PINGAS**"
        england "Quicken Loans"
        england "Now I'm in my **PINGAS** zone"
        england "Yes, they all **PINGAS** me"
        england "But, that's some **PINGAS** clones"
        england "Stay in all designer **PINGAS**"
        england "And they ask me what I **PINGAS**"
        england "I said is 10 with six **PINGAS**"
        england "Always plug, merch link in **PINGAS**"
        england "And I will see you to **PINGAS** 'cause"
        england "It's **PINGAS** day bro"
        england "**P I N G A S**"
        exit
    fi
    if [ $englandmode ]
    then
        england "https://www.youtube.com/watch?v=hSlb1ezRqfA"
        england "[Intro: Jake Paul]"
        england "Y'all can't handle this"
        england "Y'all don't know what's about to happen, baby"
        england "Team 10"
        england "Los Angeles, Cali boy"
        england "But I'm from Ohio though, white boy"
        england "[Verse 1: Jake Paul]"
        england "It's everyday bro, with the Disney Channel flow"
        england "5 mill on YouTube in 6 months, never done before"
        england "Passed all the competition man, PewDiePie is next"
        england "Man I'm poppin' all these checks, got the brand new Rolex"
        england "And I met a Lambo too and I'm coming with the crew"
        england "This is Team 10, bitch, who the hell are flippin' you?"
        england "And you know I kick them out if they ain't with the crew"
        england "Yeah, I'm talking about you, you beggin' for attention"
        england "Talking shit on Twitter too but you still hit my phone last night"
        england "It was 4:52 and I got the text to prove"
        england "And all the recordings too, don't make me tell them the truth"
        england "And I just dropped some new merch and it's selling like a god, church"
        england "Ohio's where I'm from, we chew 'em like it's gum"
        england "We shooting with a gun, the tattoo just for fun"
        england "I Usain Bolt and run, catch me at game one"
        england "I cannot be outdone, Jake Paul is number one"
        england "[Chorus: Jake Paul]"
        england "It's everyday bro"
        england "It's everyday bro"
        england "It's everyday bro"
        england "I said it's everyday bro!"
        england "[Verse 2: Nick Crompton]"
        england "You know it's Nick Crompton and my collar stay poppin'"
        england "Yes, I can rap and no, I am not from Compton"
        england "**ENGLAND IS MY CITY**"
        england "**England is my city**"
        england "**England Is My City**"
        england "**England is my city**"
        england "**ENGLAND IS MY CITY**"
        england "And if it weren't for Team 10, then the US would be shitty"
        england "I'll pass it to Chance 'cause you know he stay litty"
        england "[Verse 3: Chance Sutton]"
        england "Two months ago you didn't know my name"
        england "And now you want my fame?"
        england "Bitch I'm blowin' up, I'm only going up"
        england "Now I'm going off, I'm never fallin' off"
        england "Like Mag, who? Digi who? Who are you?"
        england "All these beefs I just ran through, hit a milli in a month"
        england "Where were you? Hatin' on me back in West Fake"
        england "Think you need to get your shit straight"
        england "Jakey brought me to the top, now we really poppin' off"
        england "Number 1 and number 4, that's why these fans all at our door"
        england "It's lonely at the top so we all going"
        england "We left Ohio, now the trio is all rollin'"
        england "It's Team 10, bitch"
        england "We back again, always first, never last"
        england "We the future, we'll see you in the past"
        england "[Chorus: Jake Paul]"
        england "It's everyday bro"
        england "It's everyday bro"
        england "It's everyday bro"
        england "I said it's everyday bro!"
        england "[Interlude: Martinez Twins]"
        england "Hold on, hold on, hold on (espera)"
        england "Can we switch the language? (ha, ya tú sabe')"
        england "We 'bout to hit it (dale)"
        england "[Verse 4: Martinez Twins]"
        england "Sí, lo único que quiero es dinero"
        england "Trabajando en YouTube todo el día entero (dale)"
        england "Viviendo en U.S.A, el sueño de cualquiera (ha)"
        england "Enviando dólares a mi familia entera (pasta)"
        england "Tenemos una persona por encima"
        england "Se llama Donald Trump y está en la cima (la cima)"
        england "Desde aquí te cantamos, can I get my VISA?"
        england "Martinez Twins, representando España"
        england "Desde la pobreza a la fama"
        england "[Chorus: Jake Paul]"
        england "It's everyday bro"
        england "It's everyday bro"
        england "It's everyday bro"
        england "I said it's everyday bro!"
        england "[Verse 5: Tessa Brooks]"
        england "Yo, it's Tessa Brooks"
        england "The competition shook"
        england "These guys up on me"
        england "I got 'em with the hook"
        england "Lemme educate ya"
        england "And I ain't talking book"
        england "Panera is your home?"
        england "So, stop calling my phone"
        england "I'm flyin' like a drone"
        england "They buying like a loan"
        england "Yeah, I smell good"
        england "Is that your boy's cologne?"
        england "[Verse 6: Jake Paul]"
        england "Is that your boy's cologne?"
        england "Started balling', quicken Loans"
        england "Now I'm in my flippin' zone"
        england "Yes, they all copy me"
        england "But, that's some shitty clones"
        england "Stay in all designer clothes"
        england "And they ask me what I make"
        england "I said it's 10 with six zeros"
        england "Always plug, merch link in bio"
        england "And I will see you tomorrow 'cause"
        england "It's everyday bro"
        england "Peace"
        exit
    fi
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

case "$site" in
    paheal)
        paheal
        ;;
    gelbooru)
        gelbooru
        ;;
    rule34xxx)
        rule34xxx
        ;;
    yandere)
        yandere
        ;;
    pixiv)
        if [ ! $downloadmode ]
        then
            echo "Houston, we have an arsefockin' problem: pivix.net MUST use download mode to process, because hentai pics of it cannot be processed by discord" >&2
            exit 7
        else
            pixiv
        fi
        ;;
    pixiv_author)
        if [ ! $downloadmode ]
        then
            echo "Houston, we have an arsefockin' problem: pivix.net MUST use download mode to process, because hentai pics of it cannot be processed by discord" >&2
            exit 7
        else
            pixiv_author
        fi
        ;;
    pixiv_favourite)
        if [ ! $downloadmode ]
        then
            echo "Houston, we have an arsefockin' problem: pivix.net MUST use download mode to process, because hentai pics of it cannot be processed by discord" >&2
            exit 7
        else
            pixiv_favourite
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
