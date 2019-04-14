#!/bin/bash
# copyrekt die deutsche Orthopädiespezialist 201⑨
# multi-site rule34 fully automatic masspostin' bot for discord
# you can either use a webhook or your own account or alt account if you don't have permissions to create webhooks
# here we fockin' go

######################################################################################################################################################################
# default values, need to be changed

# hentai update interval
webhookinterval=3
naturalinterval=2

# shitty arse pixiv parameter, well, anythin' in pixiv curl other than `curl "<your pixiv page url>"`
shitty_arse_pixiv_parameter='<get it yourself>'
shitty_arse_pixiv_parameter=${shitty_arse_pixiv_parameter//--compressed /} # otherwise you cannot use it on wget

webhook_url="<paste your webhook url here>"

# <login your discord account usin' firefox, use F12 to open developer mode, use "network" tab to monitor network activities, send a message in your desired channel, find the "messages" request and use "Copy" -> "Copy as cURL to get the cURL command and replace your message with a $1 and replace all '""' with '\"', then you're good to go! >
# it will look like the cURL command below, but pls do yourself a fockin' favor and change it to yours
# curl_command='curl "https://discordapp.com/api/v6/channels/XXXXXXXXXXXXXXXXX/messages" -H "XXXXXXXXXXXXXXXXX" -H "Accept: */*" -H "Accept-Language: en-US" --compressed -H "Referer: https://discordapp.com/channels/XXXXXXXXXXXXXXXXX" -H "Content-Type: application/json" -H "Authorization: XXXXXXXXXXXXXXXXX" -H "X-Super-Properties: XXXXXXXXXXXXXXXXX" -H "Cookie:XXXXXXXXXXXXXXXXX" -H "DNT: X" -H "Connection: keep-alive" --data "{\"content\":\"$1\",\"nonce\":\"XXXXXXXXXXXXXXXX$RANDOM$RANDOM$RANDOM\",\"tts\":false}"'

# <login your discord account usin' firefox, use F12 to open developer mode, use "network" tab to monitor network activities, send a message in your desired channel, find the "messages" request and use "Copy" -> "Copy as cURL to get the cURL command, but this time you'll need to change the enitre --data into '-F "payload_json={\"content\":\"$1\",\"nonce\":\"XXXXXXXXXXXXXXXXX\",\"tts\":false}" -F "filename=@$2"', then you're good to go! >
# it will look like the cURL command below, but pls do yourself a fockin' favor and change it to yours
# curl_command_upload='curl "https://discordapp.com/api/v6/channels/XXXXXXXXXXXXXXXXX/messages" -H "XXXXXXXXXXXXXXXXX" -H "Accept: */*" -H "Accept-Language: en-US" --compressed -H "Referer: https://discordapp.com/channels/XXXXXXXXXXXXXXXXX" -H "Content-Type: multipart/form-data; boundary=---------------------------XXXXXXXXXXXXXXXXX" -H "Authorization: XXXXXXXXXXXXXXXXX" -H "X-Super-Properties: XXXXXXXXXXXXXXXXX" -H "Cookie:XXXXXXXXXXXXXXXXX" -H "DNT: X" -H "Connection: keep-alive" -F "payload_json={\"content\":\"$1\",\"nonce\":\"XXXXXXXX$RANDOM$RANDOM$RANDOM\",\"tts\":false}" -F "filename=@$2"'

# now we have a better way to provide auth, just curl and copy anythin' after "Authorization: "
auth_defaults=""
channelid_defaults=""

# contents below usually don't need to be changed
######################################################################################################################################################################

######################################################################################################################################################################
# discord-related functions start here

function nanako() { # use webhooks [ with one parameter <message> ]
    if [ ! $messagemode ] && [ ! $uploadmode ] && [ ! $englandmode ] && [ ! $pingasmode ] && [ ! $snowflakesmode ]
    then
        username="$cutie_name Hentai Bot"
    else
        username="$cutie"
    fi
    # curl -d "content=$1&username=$username&avatar_url=$avatarurl" "$webhook_url"
    curl -d "{\"content\":\"$1\",\"username\":\"$username\",\"avatar_url\":\"$avatarurl\"}" "$webhook_url"
}

function hifumi() { # use webhooks to upload files [ with two parameters <message> <filepath> ]
    if [ ! $messagemode ] && [ ! $uploadmode ] && [ ! $englandmode ] && [ ! $pingasmode ] && [ ! $snowflakesmode ]
    then
        username="$cutie_name Hentai Bot"
    else
        username="$cutie"
    fi
    curl -F "payload_json={\"content\":\"$1\",\"username\":\"$username\",\"avatar_url\":\"$avatarurl\"}" -F "filename=@$2" "$webhook_url"
}

function futaba() { # use your own accounts [ with one parameter <message> ]
    if [ "$auth" ]
    then
        curl "https://discordapp.com/api/v6/channels/$purechannelid/messages" -H "User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:61.0) Gecko/20100101 Firefox/61.0" -H "Accept: */*" -H "Accept-Language: en-US" --compressed -H "Referer: https://discordapp.com/channels/$channelid" -H "Content-Type: application/json" -H "Authorization: $auth" -H "Cookie: __cfduid=d6fa896e3cb4d9ce5a05e36e3c845ada11531595067" -H "DNT: 1" -H "Connection: keep-alive" --data "{\"content\":\"$1\",\"nonce\":\"46776845$RANDOM$RANDOM$RANDOM\",\"tts\":false}";
    else
        eval "$curl_command"
    fi
}

function makoto() { # use your own accounts to upload files [ with two parameters <message> <filepath> ]
    if [ "$auth" ]
    then
        curl "https://discordapp.com/api/v6/channels/$purechannelid/messages" -H "User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:61.0) Gecko/20100101 Firefox/61.0" -H "Accept: */*" -H "Accept-Language: en-US" --compressed -H "Referer: https://discordapp.com/channels/$channelid" -H "Authorization: NDYyNTczNjY0NDIwODg4NTk3.Dhj1hA.as8aZRXu_3o0CG5M0OGEEmwS6Lw" -H "Content-Type: multipart/form-data; boundary=---------------------------32345443330436" -H "Cookie: __cfduid=d7be2f6bf6a3c09f82cd952f554ea2cb31531625199" -H "DNT: 1" -H "Connection: keep-alive" -F "payload_json={\"content\":\"$1\",\"nonce\":\"46776845$RANDOM$RANDOM$RANDOM\",\"tts\":false}" -F "filename=@$2"
    else
        eval "$curl_command_upload"
    fi
}

######################################################################################################################################################################

######################################################################################################################################################################
# info-message-related functions start here

function message_general() { # [ with one parameter <message> ]
    if [ ! $silentmode ] && [ ! $linkonlymode ]
    then
        case "$mode" in
            0)
                echo
                echo -e "\e[36m$1\e[0m"
                nanako "$1"
                sleep "$webhookinterval"
                ;;
            1)
                echo
                echo -e "\e[36m$1\e[0m"
                futaba "$1"
                sleep "$naturalinterval"
                ;;
        esac
    else
        echo -e "\e[36m$1\e[0m"
    fi
}

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
        danbooru)
            sitename="danbooru.donmai.us"
            ;;
        rule34xxx)
            sitename="rule34.xxx"
            ;;
        yandere)
            sitename="yande.re"
            ;;
        yandere2)
            sitename="yande.re"
            ;;
        shinobijp)
            sitename="shinobi.jp"
            ;;
        sankaku)
            sitename="sankakucomplex.com"
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
        discordchannel)
            sitename="discordapp.com (sarcastic"
            ;;
        *)
            echo "fock it" >&2
            exit 6
    esac
    message="$sitename rule34 fully automatic masspostin' bot developed by **$author**"
    message_general "$message"
    message="**Legal Disclaimer**: this bot's result is completely generated from the target site, so either the author or users of this bot has **ABSOLUTELY NO LIABILITY** for its behaviors, or **WOULD YOU JUST KINDLY GO DIDDLE YOURSELF YOU SOCIAL JUSTICE ARSEFOCKIN' WORRIORS**? $funnyemote"
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
            message="FYI, the cutie's name is **$cutie_name**, and this hentai has **$totalfish** page(s), and the hentai update interval is set to **$nein** second(s), so enjoy your fockin' hentai $funnyemote$funnyemote$funnyemote$funnyemote$funnyemote"
            ;;
        gelbooru)
            message="FYI, the cutie's name is **$cutie_name**, and this hentai has more than **$finalfish** pic(s), and the hentai update interval is set to **$nein** second(s), so enjoy your fockin' hentai $funnyemote$funnyemote$funnyemote$funnyemote$funnyemote"
            ;;
        danbooru)
            message="FYI, the cutie's name is **$cutie_name**, and this hentai has more than **$finalfish** page(s), and the hentai update interval is set to **$nein** second(s), so enjoy your fockin' hentai $funnyemote$funnyemote$funnyemote$funnyemote$funnyemote"
            ;;
        rule34xxx)
            message="FYI, the cutie's name is **$cutie_name**, and this hentai has more than **$finalfish** pic(s), and the hentai update interval is set to **$nein** second(s), so enjoy your fockin' hentai $funnyemote$funnyemote$funnyemote$funnyemote$funnyemote"
            ;;
        yandere)
            message="FYI, the cutie's name is **$cutie_name**, and this hentai has **$totalfish** page(s), and the hentai update interval is set to **$nein** second(s), so enjoy your fockin' hentai $funnyemote$funnyemote$funnyemote$funnyemote$funnyemote"
            ;;
        yandere2)
            message="FYI, the cutie's name is **$cutie_name**, and this hentai has **$totalfish** page(s), and the hentai update interval is set to **$nein** second(s), so enjoy your fockin' hentai $funnyemote$funnyemote$funnyemote$funnyemote$funnyemote"
            ;;
        shinobijp)
            message="FYI, the blogger's name is **$cutie**, and this hentai has **$totalfish** page(s), and the hentai update interval is set to **$nein** second(s), so enjoy your fockin' hentai $funnyemote$funnyemote$funnyemote$funnyemote$funnyemote"
            ;;
        sankaku)
            message="FYI, the cutie's name is **$cutie_name**, idk how many pics does this hentai have (and idc either$funnyemote), and the hentai update interval is set to **$nein** second(s), so enjoy your fockin' hentai $funnyemote$funnyemote$funnyemote$funnyemote$funnyemote"
            ;;
        pixiv)
            message="FYI, the cutie's name is **$cutie_name**, and this hentai has exactly **$finalfish** post(s), and the hentai update interval is set to **$nein** second(s), so enjoy your fockin' hentai $funnyemote$funnyemote$funnyemote$funnyemote$funnyemote"
            ;;
        pixiv_author | pixiv_favourite)
            message="FYI, the author's id is **${cutie//&tag=/** and tag is **}**, and this hentai has exactly **$finalfish** post(s), and the hentai update interval is set to **$nein** second(s), so enjoy your fockin' hentai $funnyemote$funnyemote$funnyemote$funnyemote$funnyemote"
            ;;
        localmachine)
            message="FYI, the cutie's name is **$cutie_name**, and idk how many pics does this hentai have (and idc either$funnyemote), and the hentai update interval is set to **$nein** second(s), so enjoy your fockin' hentai $funnyemote$funnyemote$funnyemote$funnyemote$funnyemote"
            ;;
        localmachine_pixiv)
            message="FYI, the cutie's name is **$cutie_name**, but idk how many pics does this hentai have (and idc either$funnyemote), and the hentai update interval is set to **$nein** second(s), so enjoy your fockin' hentai $funnyemote$funnyemote$funnyemote$funnyemote$funnyemote"
            ;;
        discordchannel)
            message="FYI, the source channel's id is **$cutie**, but idk how many pics does this hentai have (and idc either$funnyemote), and the hentai update interval is set to **$nein** second(s), so enjoy your fockin' hentai $funnyemote$funnyemote$funnyemote$funnyemote$funnyemote"
            ;;
        *)
            echo "fock it" >&2
            exit 6
    esac
    message_general "$message"
    
    if [ ! `echo "$original_parameters" | grep "\-\-auth"` ] && [ ! `echo "$original_parameters" | grep "\-\-rauth"` ] # to protekt your auth from appearin' in discord messages
    then
        message="And **FYTI**, the original command is: \n\`\`\`bash\n$original_parameters\n\`\`\`"
        message_general "$message"
    fi
}

function finalmessage() {
    [ $(($hcount%$multiplepics)) -eq 0 ] || england "$combined"
    finaltime=`date +%s%N`
    # usedtime=`echo "scale=3;($finaltime - $starttime)/1000000000" | bc`
    usedtime=`awk -v x=$finaltime -v y=$starttime 'BEGIN{printf "%.3f",(x-y)/1000000000}'`
    message="Thanks for usin' this shitty arse bot, this bot has finished dumpin' hentais in **$usedtime** second(s), see u next time$funnyemote$funnyemote$funnyemote$funnyemote$funnyemote"
    message_general "$message"
    if [ "$snowflakesend" ]
    then
        england "that's enough for today's hentai doses, "
        case "$snowflakesend" in
            1)
                snowflakes
                ;;
            2)
                snowflakes2
                ;;
        esac
    fi
    exit
}

######################################################################################################################################################################

######################################################################################################################################################################
# site-related functions start here

function urldecode() { : "${*//+/ }"; echo -e "${_//%/\\x}"; }

function download() {
    mkdir temp
    rm temp/* -f
    if [ $preserve_pics ]
    then
        mkdir "`urldecode "$cutie" | sed 's/\//./g'`.pics"
    fi
    cd temp
    rm *.* -f
    hentaifilename=${hentai##*/}
    hentaifilename=${hentaifilename%\?*}
    hentaifilename=${hentaifilename/:large} # for fockin' twitter images xD
    [ $aria2 ] && aria2c -R -s 128 -x 128 -k 1M --header="User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:62.0) Gecko/20100101 Firefox/62.0" "$hentai" -o "$hentaifilename" || wget --user-agent="Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:62.0) Gecko/20100101 Firefox/62.0" "$hentai" -O "$hentaifilename"
    
    ext3=`date +%y.%m.%d`
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
        esac >> "$currentdir/`urldecode "$cutie" | sed 's/ /./g' | sed 's/_/ /g' | sed 's/\//./g'`.$site.log.$ext3.txt"
    done
    if [ $preserve_pics ]
    then
        mv * "../`urldecode "$cutie"`.pics | sed 's/\//./g'" -f 
    else
        rm * -f
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

function post2discord_v2() {
    let hcount++
    case $(($hcount%$multiplepics)) in
        0)
            combined=${combined}${hentai}
            case "$mode" in
                0)
                    nanako "$combined"
                    sleep "$webhookinterval"
                    ;;
                1)
                    futaba "$combined"
                    sleep "$naturalinterval"
                    ;;
            esac
            combined=`echo ""`
            ;;
        *)
            combined=${combined}${hentai}"$delimiter"
    esac
}

function processhentai() {
    if [ ! $linkonlymode ]
    then
        if [ $downloadmode ]
        then
            echo -e "\e[33mdownloadin'\e[36m $hentai\e[0m: "
            download
        else
            [ $multiplepics ] && post2discord_v2 || post2discord
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
            mkdir "`urldecode "$cutie"`.pics"
        fi
        cd temp
        rm *.* -f
        # message_general "uploadin' $hentai"
        # eval "wget ${shitty_arse_pixiv_parameter//-H /--header=} '$hentai'"
        hentaifilename=${hentai##*/}
        hentaifilename=${hentaifilename%\?*}
        echo -e "\e[33mdownloadin'\e[36m $hentai\e[0m: "
        [ $aria2 ] && aria2c -R -s $aria2threads -x $aria2threads --header="User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:62.0) Gecko/20100101 Firefox/62.0" --header="Referer: https://www.pixiv.net/member_illust.php?mode=medium&illust_id=23333333" "$hentai" -o "$hentaifilename" || wget --user-agent="Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:62.0) Gecko/20100101 Firefox/62.0" --header="Referer: https://www.pixiv.net/member_illust.php?mode=medium&illust_id=23333333" "$hentai" -O "$hentaifilename"
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
        ext3=`date +%y.%m.%d`

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
            esac >> "$currentdir/`urldecode ${cutie//&tag=/.} | sed 's/ /./g' | sed 's/_/ /g'`.pixivlog$ext$ext2.$ext3.txt"
        done
        if [ $preserve_pics ]
        then
            mv *.* "../`urldecode "$cutie"`.pics" -f 
        else
            rm *.* -f
        fi
        cd ..
    else
        [ $aria2 ] && echo "wget --user-agent=\"Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:62.0) Gecko/20100101 Firefox/62.0\" --header=\"Referer: https://www.pixiv.net/member_illust.php?mode=medium&illust_id=23333333\" \"$hentai\" -O \"$hentaifilename\"" >> "$exportfilepath" || echo "aria2c -R -s $aria2threads -x $aria2threads --header=\"User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:62.0) Gecko/20100101 Firefox/62.0\" --header=\"Referer: https://www.pixiv.net/member_illust.php?mode=medium&illust_id=23333333\" \"$hentai\" -o \"$hentaifilename\"" >> "$exportfilepath" # just an example, idk if it's useful any fockin' way
    fi
}

function processhentai_pixiv_ugoira() {
    if [ ! $linkonlymode ]
    then
        mkdir temp
        if [ $preserve_pics ]
        then
            mkdir "`urldecode "$cutie"`.pics"
        fi
        cd temp
        rm *.* -f
        # message_general "uploadin' $hentai"
        # eval "wget ${shitty_arse_pixiv_parameter//-H /--header=} '$hentai'"
        
        f=`curl "https://www.pixiv.net/member_illust.php?mode=medium&illust_id=$hentaiid" | sed 's/;/\n;/g' | grep ";pixiv.context.ugokuIllustData"`
        lastframe=`echo $f | sed 's/,{/\n/g' | grep "}]}" | grep -Eo "[0-9]*.jpg" | grep -Eo "[0-9]*"`
        imglink=`echo $f | sed 's/,/\n/g' | sed 's/\\\//g'  | grep "src" | sed  's/"/\n/g' | grep "https" | sed 's/img-zip-ugoira/img-original/g' | sed 's/_ugoira.*.zip/_ugoira/g'`
        ext=${hentai##*.}
        if [ $aria2 ]
        then
            for nein in `seq 0 $lastframe`
            do
                echo "$imglink$nein.$ext" >> neinfish.txt
            done
            aria2c -R -s $aria2threads -x $aria2threads -j $aria2threads --header="User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:62.0) Gecko/20100101 Firefox/62.0" --header="Referer: https://www.pixiv.net/member_illust.php?mode=medium&illust_id=23333333" -i neinfish.txt
            rm neinfish.txt
        else
            for nein in `seq 0 $lastframe`
            do
                echo -e "downloadin' \e[36m$imglink$nein$ext\e[0m"
                wget --user-agent="Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:62.0) Gecko/20100101 Firefox/62.0" --header="Referer: https://www.pixiv.net/member_illust.php?mode=medium&illust_id=23333333" "$imglink$nein.$ext"
            done
        fi
        
        # ffmpeg -r 10 -i "$hentaiid""_ugoira%d.$ext" -vcodec libx264 -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" "$hentaiid.mp4"
        ffmpeg -r 10 -i "$hentaiid""_ugoira%d.$ext" -vcodec libx264 -pix_fmt yuv420p -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" "$hentaiid.mp4" # for outdated media players
        rm *."$ext" -f

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
        ext3=`date +%y.%m.%d`

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
            esac >> "$currentdir/`urldecode ${cutie//&tag=/.} | sed 's/ /./g' | sed 's/_/ /g'`.pixivlog$ext$ext2.$ext3.txt"
        done
        if [ $preserve_pics ]
        then
            mv *.* "../`urldecode "$cutie"`.pics" -f 
        else
            rm *.* -f
        fi
        cd ..
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
        cutie=`cat "$cutie" | sed 's/,/\n/g' | grep -Eo '"url": "https://cdn.discordapp.com/.*"' | sed 's/"//g' | sed 's/url: //g'`
    fi
    
    for file in `echo "$cutie" | sed 's/ /|/g'`
    do
        hentai=`echo $file | sed 's/|/_/g'`
        if [ $downloadmode ]
        then
            echo -e "\e[33mdownloadin'\e[36m $hentai\e[0m: "
            download
        else
            [ $multiplepics ] && post2discord_v2 || post2discord
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
                    webhookinterval2=`expr $webhookinterval - 2`
                    sleep "$webhookinterval2"
                    ;;
                1)
                    naturalinterval2=`expr $naturalinterval - 1`
                    sleep "$naturalinterval2"
                    ;;
            esac >> "$currentdir/${cutie%.*}.pixivlog.txt"
        done
        rm *.* -f
        cd ..
    done
    
    finalmessage
}

function paheal() {
    url="https://rule34.paheal.net/post/list/$cutie/"
    url=${url// /%20}
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
        for hentai in `curl "$url/$fish" | sed 's/<br/\n/g' | grep "Image Only" | grep -Eo "https://.*>Image" | sed 's/">Image//g'`
        do
            processhentai
        done
    done

    finalmessage
}

function nein() { # #1 = "before" message id, no if not given
    if [ "$1" ]
    then
        url="https://discordapp.com/api/v6/channels/$rpurechannelid/messages?before=$1&limit=100"
    else
        url="https://discordapp.com/api/v6/channels/$rpurechannelid/messages?limit=100"
    fi
    original=`curl "$url" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:66.0) Gecko/20100101 Firefox/66.0" -H "Accept: */*" --compressed -H "Referer: https://discordapp.com/channels/$cutie" -H "Authorization: $rauth" -H "DNT: 1" -H "Connection: keep-alive" -H "Cookie: __cfduid=d5654e7ddceb28663e0d4ee79adbf39e81538640920" -H "TE: Trailers"`
    for hentai in $(for messages in `echo "$original" | sed 's/"type": [0-9]*}, {"attachments"/"type": "nein"}, \n\n{"attachments"/g'`
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
    do
        processhentai
    done
}

function discordchannel() {
    rpurechannelid=`echo "$cutie" | cut -d/ -f2`
    OLD_IFS=$IFS
    IFS=$'\n'
    
    initmessage
    
    nein
    
    messageid=`cat /tmp/messageid`
    while [ "$messageid" ]
    do
        nein "$messageid"
        messageid=`cat /tmp/messageid`
    done
    
    finalmessage

    IFS=$OLD_IFS
}

function gelbooru() {
    url="https://gelbooru.com/index.php?page=post&s=list&tags=$cutie"
    url=${url// /%20}
    finalfish=`curl "$url" | grep -Eo "pid=[0-9]*\" alt=\"last page\"" | sed 's/pid=//g' | sed 's/" alt="last page"//g'`
    if [ ! $finalfish ]
    then
        finalfish=1
    fi
    if [ ! "$cutie_name" ]
    then
        cutie_name=`echo $cutie | sed 's/_/ /g'`
    fi

    initmessage

    for fish in `seq 0 42 $finalfish`
    do
        url="https://gelbooru.com/index.php?page=post&s=list&tags=$cutie&pid=$fish"
        url=${url// /%20}
        for hentailink in `curl "$url" | sed 's/>/\n/g' | grep -Eo "view&amp;id=[0-9]*" | grep -Eo "[0-9]*"` # find id's
        do
            hentai=`curl "https://gelbooru.com/index.php?page=post&s=view&id=$hentailink" | sed 's/\/li/\n/g' | grep -Eo "<li><a href=\".*\" style=\"font-weight: bold;\">Original image" | sed 's/"/\n/g' | grep "http"`
            processhentai
        done
    done

    finalmessage
}

function danbooru() {
    url="https://danbooru.donmai.us/posts?&tags=$cutie"
    url=${url// /%20}
    finalfish=`curl "$url" | grep -Eo "[0-9]*</a></li><li class='arrow'" | grep -Eo "[0-9]*"`
    if [ ! $finalfish ]
    then
        finalfish=1
    fi
    if [ ! "$cutie_name" ]
    then
        cutie_name=`echo $cutie | sed 's/_/ /g'`
    fi

    initmessage

    for fish in `seq 1 $finalfish`
    do
        url="https://danbooru.donmai.us/posts?page=$fish&tags=$cutie"
        url=${url// /%20}
        for hentailink in `curl "$url" | grep -Eo "/posts/[0-9]+"` # find id's
        do
            hentai=`curl "https://danbooru.donmai.us$hentailink" | grep "Size:" | sed 's/"/\n/g' | grep "http"`
            processhentai
        done
    done

    finalmessage
}

function rule34xxx() {
    url="https://rule34.xxx/index.php?page=post&s=list&tags=$cutie"
    url=${url// /%20}
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
        url=${url// /%20}
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
    url=${url// /%20}
    totalfish=`curl "$url" | grep -Eo "[0-9]*</a> <a class=\"next_page" | grep -Eo "[0-9]*"`
    if [ ! $totalfish ]
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
        url=${url// /%20}
        for hentailink in `curl "$url" | grep -Eo "a class=\"thumb\" href="\"/post/show/[0-9]*\" | grep -Eo "[0-9]*"` # find id's
        do
            hentai=`curl "https://yande.re/post/show/$hentailink" | grep "a class=\"highres-show\" href=\".*\">View" | sed 's/"/\n/g' | grep "http"`
            processhentai
        done
    done

    finalmessage
}

function yandere2() {
    url="https://yande.re/post?tags=$cutie"
    url=${url// /%20}
    totalfish=`curl "$url" | grep -Eo "[0-9]*</a> <a class=\"next_page" | grep -Eo "[0-9]*"`
    if [ ! $totalfish ]
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
        url=${url// /%20}
        for hentailink in `curl "$url" | grep -Eo "a class=\"thumb\" href="\"/post/show/[0-9]*\" | grep -Eo "[0-9]*"` # find id's
        do
            hentai=`curl "https://yande.re/post/show/$hentailink" | grep "Download PNG" | sed 's/"/\n/g' | grep "http"`
            processhentai
        done
    done

    finalmessage
}

function shinobijp() {
    url="http://$cutie.blog.shinobi.jp/Page/999999999999999999/"
    url=${url// /%20}
    totalfish=`curl "$url" | grep '<a href="/Page/[0-9]*/">前のページ</a>' | grep -Eo "[0-9]*"`
    if [ ! $totalfish ]
    then
        totalfish=1
    else
        totalfish=`expr $totalfish + 1`
    fi
    if [ ! "$cutie_name" ]
    then
        cutie_name=`echo $cutie | sed 's/_/ /g'`
    fi

    initmessage

    for fish in `seq 1 $totalfish`
    do
        url="http://$cutie.blog.shinobi.jp/Page/$fish/"
        url=${url// /%20}
        for hentai in `curl "$url" | sed 's/<br/\n/g' | grep "http://file.$cutie.blog.shinobi.jp/.*\" target=\"_blank\"" | sed 's/"/\n/g' | grep "http" | grep ".jp[e]*g"`
        do
            processhentai
        done
    done

    finalmessage
}

function sankakucomplex() { # defunct, would update later
    url="https://chan.sankakucomplex.com/post/index.content?tags=$cutie%20order:popular"
    url=${url// /%20}
    if [ ! "$cutie_name" ]
    then
        cutie_name=`echo $cutie | sed 's/_/ /g'`
    fi

    initmessage
    
    num=1
    while
        nein=`curl "$url&page=$num" -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" -H "Accept-Language: zh-CN,zh;q=0.8,zh-TW;q=0.7,zh-HK;q=0.5,en-US;q=0.3,en;q=0.2" --compressed -H "Referer: $url&page=$num&commit=Search" -H "DNT: 1" -H "Connection: keep-alive" -H "Cookie: _pk_id.2.42fa=572917ae58b0d777.1539068321.14.1545558908.1545558908.; _pk_ref.2.42fa="%"22"%"5B"%"5C"%"22"%"5C"%"22"%"2C"%"20"%"5C"%"22"%"5C"%"22"%"2C"%"201545558908"%"2C"%"20"%"5C"%"22https"%"3A"%"2F"%"2Fiqdb.org"%"2F"%"5C"%"22"%"5D"%"22; auto_page=1; locale=en" -H "Upgrade-Insecure-Requests: 1" -H "Cache-Control: max-age=0" | sed 's/ /|/g'`
        det=`echo $nein | grep -Eo "No\|matching\|posts"`
        [ "$det" != "No|matching|posts" ]
    do
        for fish in `echo "$nein"`
        do
            link=`echo $fish | sed 's/|/ /g' | grep -Eo "post/show/[0-9]*"`
            [ $link ] && for hentai in `curl "https://chan.sankakucomplex.com/$link" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:64.0) Gecko/20100101 Firefox/64.0" -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" -H "Accept-Language: zh-CN,zh;q=0.8,zh-TW;q=0.7,zh-HK;q=0.5,en-US;q=0.3,en;q=0.2" --compressed -H "Referer: $url&page=$num" -H "DNT: 1" -H "Connection: keep-alive" -H "Cookie: _pk_id.2.42fa=572917ae58b0d777.1539068321.14.1545558908.1545558908.; _pk_ref.2.42fa="%"22"%"5B"%"5C"%"22"%"5C"%"22"%"2C"%"20"%"5C"%"22"%"5C"%"22"%"2C"%"201545558908"%"2C"%"20"%"5C"%"22https"%"3A"%"2F"%"2Fiqdb.org"%"2F"%"5C"%"22"%"5D"%"22; auto_page=1; locale=en" -H "Upgrade-Insecure-Requests: 1" -H "Cache-Control: max-age=0" | grep "Original:" | sed 's/amp;//g' | sed 's/"/\n/g' | grep "//"`
            do
                hentai="https:$hentai"
                processhentai
            done
        done
        let num++
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

function pixiv_det() {
    if [ ! $finalfish ] || [ $finalfish == "0" ]
    then
        echo "Cutie not found"
        exit
    fi
    if [ ! $start_from ]
    then
        start_from=1
    else
        ext2=".$start_from-$end_with"
    fi
    if [ ! $end_with ]
    then
        end_with=999999999999999999 # "NEIN NEIN NEIN NEIN NEIN NEIN" ---- Adolf Shitler
    else
        ext2=".$start_from-$end_with"
    fi
    if [ ! "$cutie_name" ]
    then
        cutie_name=`echo $cutie | sed 's/_/ /g'`
    fi
}

function pixiv_subprocess() {
    pixiv_hentai
    message_general "Analyzin' https://www.pixiv.net/member_illust.php?mode=medium&illust_id=$hentaiid (**$antics**/$finalfish)... Found **$hentaipages** pic(s)"
    message_general "https://www.pixiv.net/member_illust.php?mode=medium&illust_id=$hentaiid processin' started"
    if [ $hentaipages -eq 1 ]
    then # single-pic page cumfirmed
        hentai=`eval "curl 'https://www.pixiv.net/member_illust.php?mode=medium&illust_id=$hentaiid' $shitty_arse_pixiv_parameter" | sed 's/,/\n/g' | grep -Eo "original.*" | sed 's/\\\//g' | grep -Eo "https.*" | sed 's/"}//g'`
        if [ `echo $hentai | grep -c "ugoira"` -eq 1 ] && [ $ugoiramode ]
        then
            processhentai_pixiv # needs $hentai AND $hentaiid to work
            processhentai_pixiv_ugoira # needs $hentai AND $hentaiid to work
        else
            processhentai_pixiv # needs $hentai AND $hentaiid to work
        fi
    else # multi-pic page cumfirmed
        for bighentai in `eval "curl 'https://www.pixiv.net/member_illust.php?mode=manga&illust_id=$hentaiid' $shitty_arse_pixiv_parameter" | sed 's/\&amp;/\&/g' | sed 's/"/\n/g' | grep "page=[0-9]*"`
        do
            hentai=`eval "curl 'https://www.pixiv.net$bighentai' $shitty_arse_pixiv_parameter" | grep -Eo "img src.*\" " | sed 's/img src="//g' | sed 's/" //g'`
            if [ `echo $hentai | grep -c "ugoira"` -eq 1 ] && [ $ugoiramode ]
            then
                processhentai_pixiv # needs $hentai AND $hentaiid to work
                processhentai_pixiv_ugoira # needs $hentai AND $hentaiid to work
            else
                processhentai_pixiv # needs $hentai AND $hentaiid to work
            fi
        done
    fi
    message_general "https://www.pixiv.net/member_illust.php?mode=medium&illust_id=$hentaiid done processin'"
}

function pixiv_half_subprocess() {
    pixiv_hentai
    message_general "Analyzin' https://www.pixiv.net/member_illust.php?mode=medium&illust_id=$hentaiid (**$antics**/$finalfish)... Found **$hentaipages** pic(s)"
    # message_general "https://www.pixiv.net/member_illust.php?mode=medium&illust_id=$hentaiid processin' started"
    if [ $hentaipages -eq 1 ]
    then # single-pic page cumfirmed
        hentai=`eval "curl 'https://www.pixiv.net/member_illust.php?mode=medium&illust_id=$hentaiid' $shitty_arse_pixiv_parameter" | sed 's/,/\n/g' | grep -Eo "original.*" | sed 's/\\\//g' | grep -Eo "https.*" | sed 's/"}//g'`
        if [ `echo $hentai | grep -c "ugoira"` -eq 1 ] && [ $ugoiramode ]
        then
            processhentai_pixiv # needs $hentai AND $hentaiid to work
            processhentai_pixiv_ugoira # needs $hentai AND $hentaiid to work
        else
            processhentai_pixiv # needs $hentai AND $hentaiid to work
        fi
    else # multi-pic page cumfirmed
        hentaitemp=`eval "curl 'https://www.pixiv.net/member_illust.php?mode=manga_big&illust_id=$hentaiid&page=0' $shitty_arse_pixiv_parameter" | grep -Eo "img src.*\" " | sed 's/img src="//g' | sed 's/" //g'`
        extension=${hentaitemp##*.}
        hentaitemp="${hentaitemp%p[0-9]*}p"
        hentaipages=`expr $hentaipages - 1`
        for fegelein in `seq 0 $hentaipages`
        do
            hentai="$hentaitemp$fegelein.$extension"
            if [ `echo $hentai | grep -c "ugoira"` -eq 1 ] && [ $ugoiramode ]
            then
                processhentai_pixiv # needs $hentai AND $hentaiid to work
                processhentai_pixiv_ugoira # needs $hentai AND $hentaiid to work
            else
                processhentai_pixiv # needs $hentai AND $hentaiid to work
            fi
        done
    fi
    # message_general "https://www.pixiv.net/member_illust.php?mode=medium&illust_id=$hentaiid done processin'"
}

function pixiv_fast_subprocess() {
    pixiv_hentai
    message_general "Analyzin' https://www.pixiv.net/member_illust.php?mode=medium&illust_id=$hentaiid (**$antics**/$finalfish)... Found **$hentaipages** pic(s)"
    message_general "https://www.pixiv.net/member_illust.php?mode=medium&illust_id=$hentaiid processin' started"
    hentaipages=`expr $hentaipages - 1`
    for fegelein in `seq 0 $hentaipages`
    do
        hentai="$hentaitemp$fegelein.jpg"
        if [ `echo $hentai | grep -c "ugoira"` -eq 1 ] && [ $ugoiramode ]
        then
            processhentai_pixiv # needs $hentai AND $hentaiid to work
            processhentai_pixiv_ugoira # needs $hentai AND $hentaiid to work
        else
            processhentai_pixiv # needs $hentai AND $hentaiid to work
        fi
        hentai="$hentaitemp$fegelein.png"
        if [ `echo $hentai | grep -c "ugoira"` -eq 1 ] && [ $ugoiramode ]
        then
            processhentai_pixiv # needs $hentai AND $hentaiid to work
            processhentai_pixiv_ugoira # needs $hentai AND $hentaiid to work
        else
            processhentai_pixiv # needs $hentai AND $hentaiid to work
        fi
    done
    message_general "https://www.pixiv.net/member_illust.php?mode=medium&illust_id=$hentaiid done processin'"
}

function pixiv() {
    cutie=${cutie// /%20}
    if [ ! $pixivorder ]
    then
        pixivorder="date_d" # default order: newest to oldest
    fi
    if [ ! $fulltag ]
    then
        tag="s_tag"
    else
        tag="s_tag_full"
    fi
    url="https://www.pixiv.net/search.php?s_mode=$tag&word=$cutie&order=$pixivorder&mode=r18" # it would be better if use japanese keyword ## some shitty arse hosts will not support you to input non-latin characters, you might need to have a way to deal with it like encodin' your url or just not use them to dump pixiv
    finalfish=`eval "curl '$url' $shitty_arse_pixiv_parameter" | grep -Eo "og.*に関する作品は[0-9]*件" | grep -Eo "に関する作品は[0-9]*件" | grep -Eo "[0-9]*"`

    pixiv_det

    initmessage

    totalfish=`expr $finalfish / 40 + 1`
    antics=0
    for fish in `seq 1 $totalfish`
    do
        url="https://www.pixiv.net/search.php?s_mode=s_tag&word=$cutie&order=$pixivorder&mode=r18&p=$fish"
        for hentaiinfo in `eval "curl '$url' $shitty_arse_pixiv_parameter" | sed 's/ /|/g' | sed 's/&quot;/"/g' | sed 's/{"illustId"/\n{"illustId"/g' | grep "illustId"` # find id's and pagecounts
        do
            antics=`expr $antics + 1`
            echo "$start_from - $end_with"
            if [ "$antics" -ge "$start_from" ] && [ "$antics" -le "$end_with" ]
            then
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
            fi
            if [ "$antics" -gt "$end_with" ]
            then
                finalmessage
            fi
        done
    done
    
    finalmessage
}

function pixiv_author() {
    cutie=${cutie// /%20}
    url="https://www.pixiv.net/member_illust.php?id=$cutie" # author id ## theoretically you can still apply tags in this mode, just add "&tag=<your tags>" after the author id
    finalfish=`eval "curl '$url' $shitty_arse_pixiv_parameter" | grep -Eo "[0-9]+件" | grep -Eo "[0-9]*"`

    pixiv_det

    initmessage

    totalfish=`expr $finalfish / 20 + 1`
    antics=0
    for fish in `seq 1 $totalfish`
    do
        url="https://www.pixiv.net/member_illust.php?id=$cutie&p=$fish"
        for hentaiinfo in `eval "curl '$url' $shitty_arse_pixiv_parameter" | sed 's/ /|/g' | sed 's/<\/li>/\n/g' | grep "image-item"` # find id's and pagecounts
        do
            antics=`expr $antics + 1`
            if [ "$antics" -ge "$start_from" ] && [ "$antics" -le "$end_with" ]
            then
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
            fi
            if [ "$antics" -gt "$end_with" ]
            then
                finalmessage
            fi
        done
    done
    
    finalmessage
    echo
}

function pixiv_favourite() {
    cutie=${cutie// /%20}
    if [ ! $pixivorder ]
    then
        pixivorder="desc" # default order: latest to add to favourite to oldest
    fi
    url="https://www.pixiv.net/bookmark.php?id=$cutie&order=$pixivorder" # author id
    finalfish=`eval "curl '$url' $shitty_arse_pixiv_parameter" | grep -Eo "[0-9]+件" | grep -Eo "[0-9]*"`

    pixiv_det

    initmessage

    totalfish=`expr $finalfish / 20 + 1`
    antics=0
    for fish in `seq 1 $totalfish`
    do
        url="https://www.pixiv.net/bookmark.php?id=$cutie&order=$pixivorder&p=$fish"
        for hentaiinfo in `eval "curl '$url' $shitty_arse_pixiv_parameter" | sed 's/ /|/g' | sed 's/<\/li>/\n/g' | grep "image-item"` # find id's and pagecounts
        do
            antics=`expr $antics + 1`
            if [ "$antics" -ge "$start_from" ] && [ "$antics" -le "$end_with" ]
            then
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
            fi
            if [ "$antics" -gt "$end_with" ]
            then
                finalmessage
            fi
        done
    done
    
    finalmessage
}

######################################################################################################################################################################

######################################################################################################################################################################
# functions of outputin' custom lines that would risk your sorry arse banned start here

function pingaslandismypingas() {
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
}

function englandismycity() {
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
}

function snowflakes() {
    england "❄s falling on your face, \na cold wind blows away \nthe laughter from this treasured place, \nbut in our memories it stays\n\nThis is where we say farewell,\nand the wind, it feels a little colder now\nHere time's run out like a spell,\nbut laughter's our vow\n\nThis is where we saw it through,\nthick and thin, this friendship, it was built to last\nHere we swore that we'd be true\nto bonds that were forged in our past \n\n❄s blowing and the view's\nobscured by history, I still remember it with you\nlike I'm stuck in mixed realities\n\nthis is where we say goodbye\nand I'm stronger for the time I shared with you\nit helps me hold my head up high\nin my heart I'm with you\n\nthis is where the snow falls now\ncold and hard, and yet it melts upon my brow\nsomething keeps me warm inside\nsome dream keeps me going through the night\n\nsome dream keeps me going through the night\n$funnyemote$funnyemote$funnyemote$funnyemote$funnyemote"
}

function snowflakes2() {
    england "❄s falling on your face, "
    england "a cold wind blows away "
    england "the laughter from this treasured place, "
    england "but in our memories it stays"
    england "_ _"
    england "This is where we say farewell,"
    england "and the wind, it feels a little colder now"
    england "Here time's run out like a spell,"
    england "but laughter's our vow"
    england "_ _"
    england "This is where we saw it through,"
    england "thick and thin, this friendship, it was built to last"
    england "Here we swore that we'd be true"
    england "to bonds that were forged in our past "
    england "_ _"
    england "❄s blowing and the view's"
    england "obscured by history, I still remember it with you"
    england "like I'm stuck in mixed realities"
    england "_ _"
    england "this is where we say goodbye"
    england "and I'm stronger for the time I shared with you"
    england "it helps me hold my head up high"
    england "in my heart I'm with you"
    england "_ _"
    england "this is where the snow falls now"
    england "cold and hard, and yet it melts upon my brow"
    england "something keeps me warm inside"
    england "some dream keeps me going through the night"
    england "_ _"
    england "some dream keeps me going through the night"
    england "$funnyemote$funnyemote$funnyemote$funnyemote$funnyemote"
}

######################################################################################################################################################################

######################################################################################################################################################################
# DO NOT CHANGE UNLESS NECESSARY

original_parameters="$0"

for parameter in "$@"
do
    original_parameters="$original_parameters '$parameter'"
done

starttime=`date +%s%N`
currentdir=`pwd`
parameters=`getopt -o S:s:WwA:a:NnM:m:EeU:u:C:c:DdL:l:hH -a -l site:,webhook,avatar-url:,natural-mode,message:,multiple-pics:,delimiter:,england-is-my-city,pingasland-is-my-pingas,snowflakes,snowflakes2,snowflakes-end,snowflakes2-end,upload:,config-file:,fast-webhook:,download,aria2:,preserve-pics,link-only:,troll:,silent,webhookinterval:,naturalinterval:,pixiv-fast-mode,pixiv-fullscan-mode,pixiv-order:,pixiv-log,start-from:,end-with:,full-tag,ugoira-mode,channel-id:,join-chatroom:,customfunny:,auth:,rauth:,rconf:,help -- "$@"`

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
        --multiple-pics)
            multiplepics=$2
            shift 2
            ;;
        --delimiter)
            delimiter=$2
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
        --snowflakes)
            snowflakesmode=1
            shift
            ;;
        --snowflakes2)
            snowflakesmode=2
            shift
            ;;
        --snowflakes-end)
            snowflakesend=1
            shift
            ;;
        --snowflakes2-end)
            snowflakesend=2
            shift
            ;;
        -u | -U | --upload)
            uploadmode=1
            filepath=$2
            message=$4
            echo "$filepath, $message"
            shift 2
            ;;
        -c | --config-file)
            configmode=1
            configfilepath=$2
            shift 2
            ;;
        --rconf)
            rconf=$2
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
        --aria2)
            aria2=1
            aria2threads=$2
            [ $aria2threads ] || aria2threads=16 # idk if it will be used
            shift 2
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
        --pixiv-order)
            pixivorder=$2
            shift 2
            ;;
        --pixiv-log)
            pixivlogmode=1
            shift
            ;;
        --start-from)
            start_from=$2
            shift 2
            ;;
        --end-with)
            end_with=$2
            shift 2
            ;;
        --full-tag)
            fulltag="JAJAJAJAJA"
            shift
            ;;
        --ugoira-mode)
            ugoiramode="JAJAJAJAJA"
            shift
            ;;
        -C | --channel-id)
            channelid=$2
            shift 2
            ;;
        --join-chatroom)
            chatroom=$2
            shift 2
            ;;
        --customfunny)
            funnyemote=$2
            shift 2
            ;;
        --auth)
            auth=$2
            shift 2
            ;;
        --rauth)
            rauth=$2
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
            echo "            --snowflakes / --snowflakes2: spam Shihoko Hirata chan's famous \"Snowflakes\" to mock these fockin' snowflakes who couldn't stand futaba.sh grade pure cutie hentai"
            echo "        -u or -U or --upload <filepath> <message>: upload a file usin' either methods, in this mode \$cutie_name will become your bot's name (if you use webhook)"
            echo "            and i've found a strange bug out here, now it would be better if you put -u or -U or --upload as the last parameter and all will be fine"
            echo "        -d or -D or --download: download pics and reupload to discord instead of just postin' links, required for pixiv"
            echo "            --aria2 <threads>: use aria2 instead of wget to download pics, if you need more than 16 threads you'll need a hacked aria2"
            echo "            --preserve-pics: move downloaded pics in pics folder other than removin' them"
            echo "        -l or -L or --link-only <exportfilepath>: only export hentai pics links to file; for pixiv, it's the entire wget command, you can use bash or localmachine_pixiv to run them later"
            echo
            echo "    Configurations: "
            echo "        -s or -S or --site <sitename>: input site name, currently supported: paheal, gelbooru, danbooru, rule34xxx, yandere, yandere2, shinobijp, sankaku, pixiv, pixiv_author, pixiv_favourite"
            echo "            use localmachine to post or upload pics in local file (like bein' generated in link-only mode) to discord, in this case \$cutie will be your filename"
            echo "            and localmachine_pixiv to download and reupload pics in local pixiv file generated in link-only mode to discord, in this case \$cutie will be your filename"
            echo "            and discordchannel to get link / download all pics from a discord channel to well, post / reupload them to another discord channel, in this case \$cutie will be your source discord channel (must be <chatroom-id/channel-id> format)"
            echo "                in this case pls use --rauth or --rconf if your account to get pics isn't as same as account to post pics, otherwise it would be the same; ofc in webhook mode you must set either of them or it won't fockin' work"
            echo "        -c or --config-file <configfilepath>: load a configuration file which contains three lines of webhook url, account curl command and account curl command (used to upload); if you don't load one it will use default values in the script; but i don't make pixiv shit to be in configuration file because you just don't need to change them by all means"
            echo "            --fast-webhook <webhook-link>: if you just wanna change webhook (i've forgotten it for days... ), you don't need to create a new configuration file anyway, that's for other uses, actually with cross channel messagin' functionality now natural mode is much more versatile than webhook mode"
            echo "        --auth <auth>: use auth string instead of config file, basically you can't use them both"
            echo "        --troll <trollname>: replace die deutsche Orthopädiespezialist in the copyrekt message to something else"
            echo "        --silent: omit all of messages except pics (they'll be outputted in console anyway), may be useful in some cases"
            echo "        --webhookinterval <newinterval>: override webhook mode hentei interval in the script"
            echo "        --naturalinterval <newinterval>: override natural mode hentei interval in the script"
            echo "        --multiple-pics <multiplepics>: send more than one pic in a message, the maximum pics you can send at once is 5, more pics would not be in embeds"
            echo "                --delimiter <delimiter>: set the delimiter between pics in a message, defaultly it would a new line (\\n), but you can use space as well"
            echo
            echo "    pixiv.net Related Configurations: "
            echo "        --pixiv-fast-mode: only use the list page info to dump pixiv pics, but will generate too much 404"
            echo "        --pixiv-halfspeed-mode: use id page info to dump pixiv pics, but faster than full mode (default and you don't need to use this)"
            echo "        --pixiv-fullscan-mode: use all page info to dump pixiv pics, slowest"
            echo "        --pixiv-order <pixivorder>: use custom order to search through pixiv; currently available orders: "
            echo "            main mode: date_d (default, from latest to oldest), date (from oldest to latest)"
            echo "            premium account exclusive: popular_d (order by popularity), popular_male_d (order by popularity amongst males), popular_female_d (order by popularity amongst females)"
            echo "            favourite mode: desc (default, from latest added to favourite to oldest), asc (from oldest added to favourite to latest), date_d (from latest posted to oldest), date (from oldest posted to latest)"
            echo "        --pixiv-log: an extra procedure to use pixiv log just like normal local pic file, so you don't need to grep it yourself"
            echo "            and currently this thing will either kill the script or make it stop, just forget about it"
            echo "        --start-from <postnumber>: start from certain number of post, and skip all posts before it"
            echo "        --end-with <postnumber>: end with certain number of post, and skip all posts after it"
            echo "        --full-tag: use \"s_tag_full\" instead of \"s_tag\""
            echo "        --ugoira-mode: process ugoira, download every last pic of them, and use ffmpeg to make them .mp4"
            echo
            echo "    Antics: "
            echo "        -C or --channel-id <chatroom-id/channel-id>: the ability to send message in any channel that you have access to (only with natural mode), need to provide both chatroom id and channel id"
            echo "            and i'm still not used to called discord chatroom \"server\", because what runs this script is the real server for me"
            echo "        --join-chatroom <chatroom-invite-link>: the ability to join chatroom via ARSEFOCKIN' B A S H, you just need to provide the last few letters of the invite link, for https://discord.gg/FEGEL you only need \"FEGEL\""
            echo "        --customfunny <funnyemote>: custom emote to express sarcasm"
            echo "        --snowflakes-end / --snowflakes2-end: spam \"Snowflakes\" after postin' normal final messages, well, to mock these fockin' snowflakes who couldn't stand futaba.sh grade pure cutie hentai"
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
            echo "        this time it's not futaba, but you just find user id in links like https://www.pixiv.net/bookmark.php?id=5758362 or https://www.pixiv.net/member_illust.php?id=5758362 and the number \"5758362\" is user id that can be used in either pixiv_author or pixiv_favourite; actually they're not too different in processin'"
            echo "            if you wanna apply tags in this mode, just add \"&tag=<your tags>\" after the author id, eg. for such tagged search like https://www.pixiv.net/member_illust.php?id=5758362&tag=久慈川りせ what you need to input is \"5758362&tag=久慈川りせ\""
            echo "    the display name for your cutie (\$cutie_name) can be different from the search term or tag (\$cutie), but if you don't input one it will be automatically generated from the tag"
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

if [ $configmode ] && [ "$auth" ]
then
    echo "Houston, we have an arsefockin' problem: You can't use config file and auth both" >&2
    exit 10
fi

if [ "$rconf" ] && [ "$rauth" ]
then
    echo "Houston, we have an arsefockin' problem: You can't use reciver config file and reciver auth both" >&2
    exit 11
fi

if [ $mode == 0 ] && [ ! "$rconf" ] && [ ! "$rauth" ]
then
    echo "Houston, we have an arsefockin' problem: You must either give a reciver auth or reciver config file to be able to receive messages from your discord channel in webhook mode" >&2
    exit 12
fi

if [ "$rconf" ]
then
    rauth=`cat "$rconf" | grep '"Authorization: ' | head -1 | sed 's/"/\n/g' | grep "Authorization: " | sed 's/Authorization: //g'`
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

if [ ! "$curl_command" ] # curl command unset, force auth mode usin' $auth_defaults
then
    echo -e "\033[31m\$curl_command not detected, force auth mode\033[0m"
    [ "$auth" ] || auth="$auth_defaults"
    if [ $channelid ]
    then
        purechannelid=`echo "$channelid" | cut -d/ -f2`
    else
        channelid="$channelid_defaults"
        purechannelid=`echo "$channelid" | cut -d/ -f2`
    fi
else
    if [ $channelid ] # it looks like shit but it works
    then
        # echo $curl_command
        # echo
        curl_command=${curl_command//`echo $curl_command | grep -Eo "channels/[0-9]*/messages"`/channels/`echo $channelid | cut -f2 -d/`/messages}
        curl_command=${curl_command//`echo $curl_command | grep -Eo "channels/[0-9]*/[0-9]*\""`/channels/$channelid\"}
        curl_command_upload=${curl_command_upload//`echo $curl_command_upload | grep -Eo "channels/[0-9]*/messages"`/channels/`echo $channelid | cut -f2 -d/`/messages}
        curl_command_upload=${curl_command_upload//`echo $curl_command_upload | grep -Eo "channels/[0-9]*/[0-9]*\""`/channels/$channelid\"}
        purechannelid=`echo "$channelid" | cut -d/ -f2`
        # echo $curl_command
        # echo
    else
        channelid="$channelid_defaults"
        purechannelid=`echo "$channelid" | cut -d/ -f2`
    fi
fi

if [ $mode == 1 ] && [ ! "$auth" ] && [ ! "$curl_command" ]
then
    echo "Houston, we have an arsefockin' problem: Not a single bit of arsefockin' auth could be found and used to send messages" >&2
    exit -999999
fi

if [ ! "$rauth" ] # if receiver auth's not given by any mean, it will use transmitter auth; otherwise rauth should either be fockin' given, or can be extracted in conf file
then
    if [ "$auth" ]
    then
        rauth="$auth"
    else
        rauth=`echo "$curl_command" | sed 's/"/\n/g' | grep "Authorization: " | sed 's/Authorization: //g'`
    fi
fi

if [ $channelid ] # it looks like shit but it works
then
    # echo $curl_command
    # echo
    curl_command=${curl_command//`echo $curl_command | grep -Eo "channels/[0-9]*/messages"`/channels/`echo $channelid | cut -f2 -d/`/messages}
    curl_command=${curl_command//`echo $curl_command | grep -Eo "channels/[0-9]*/[0-9]*\""`/channels/$channelid\"}
    curl_command_upload=${curl_command_upload//`echo $curl_command_upload | grep -Eo "channels/[0-9]*/messages"`/channels/`echo $channelid | cut -f2 -d/`/messages}
    curl_command_upload=${curl_command_upload//`echo $curl_command_upload | grep -Eo "channels/[0-9]*/[0-9]*\""`/channels/$channelid\"}
    purechannelid=`echo "$channelid" | cut -d/ -f2`
    # echo $curl_command
    # echo
else
    channelid="$channelid_defaults"
    purechannelid="$purechannelid_defaults"
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

if [ $ugoiramode ] && [ $linkonlymode ]
then
    echo "Houston, we have an arsefockin' problem: You can't process ugoira while usin' link only mode, at least for now" >&2
    exit 9
fi

[ $funnyemote ] || funnyemote="<:funny_v2:530321446338035742>"

if [ ! $messagemode ] && [ ! $uploadmode ] && [ ! $englandmode ] && [ ! $pingasmode ] && [ ! $snowflakesmode ]
then
    if [ ! "$cutie" ]
    then 
        echo "Houston, we have an arsefockin' problem: Cutie required" >&2
        exit 4
    fi
else
    if [ $pingasmode ]
    then
        pingaslandismypingas
        exit
    fi
    if [ $englandmode ]
    then
        englandismycity
        exit
    fi
    if [ $snowflakesmode ] && [ $snowflakesmode == 1 ]
    then
        snowflakes
        exit
    fi
    if [ $snowflakesmode ] && [ $snowflakesmode == 2 ]
    then
        snowflakes2
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

hcount=0
combined=`echo ""`
[ "$delimiter" ] || delimiter="\n"

case "$site" in
    paheal)
        paheal
        ;;
    gelbooru)
        gelbooru
        ;;
    danbooru)
        danbooru
        ;;
    rule34xxx)
        rule34xxx
        ;;
    yandere)
        yandere
        ;;
    yandere2)
        yandere2
        ;;
    shinobijp)
        shinobijp
        ;;
    sankaku)
        sankakucomplex
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
    discordchannel)
        discordchannel
        ;;
    *)
        echo "Houston, we have an arsefockin' problem: Site currently not supported" >&2
        exit 6
esac
