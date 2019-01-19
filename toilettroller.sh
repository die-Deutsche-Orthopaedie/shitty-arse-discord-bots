#!/bin/bash
# copyrekt die deutsche Orthopädiespezialist 201⑨
# toilet troller script
# added instant join & quit antics, as long as that incel pedo fock doesn't have a pc, he literally can't ban any one of my alts, and thus i can troll him all day long:funny_v2:

######################################################################################################################################################################
function rand(){
    min=$1
    max=$(($2-$min+1))
    num=$(date +%s%N)
    echo $(($num%$max+$min))
}

function trolltoilet() {
    local randomchannel=`rand 0 "$channels"`
    local randomline=`rand 0 "$lines"`
    echo -e "\033[36mchannel: \033[32m$randomchannel\033[0m, ${channel[$randomchannel]}"
    echo -e "\033[36mmessage: \033[32m$randomline\033[0m, ${line[$randomline]}"
    echo -e "\033[36mprofile: pedosona\033[32m$1\033[0m"
    echo
    ./futaba.sh -N -c "conf/pedosona$1.conf" --channel-id "${channel[$randomchannel]}" -M "${line[$randomline]}"
    echo
    echo
    # sleep 1
}

function leavechatroom() { # $1 = profile file; $2 = chatroom id (531191841429913640)
    authorization=`cat "$1" |sed "s/-H/\n/g" | grep ""Authorization | head -n 1 | grep -Eo ": .*\"" | sed 's/: //g' | sed 's/"//g'`
    curl "https://discordapp.com/api/v6/users/@me/guilds/$2" -X DELETE -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:64.0) Gecko/20100101 Firefox/64.0" -H "Accept: */*" -H "Accept-Language: zh-CN" --compressed -H "Referer: https://discordapp.com/channels/$2/531191841429913642" -H "Authorization: $authorization" -H "X-Super-Properties: eyJvcyI6IldpbmRvd3MiLCJicm93c2VyIjoiRmlyZWZveCIsImRldmljZSI6IiIsImJyb3dzZXJfdXNlcl9hZ2VudCI6Ik1vemlsbGEvNS4wIChXaW5kb3dzIE5UIDEwLjA7IFdpbjY0OyB4NjQ7IHJ2OjY0LjApIEdlY2tvLzIwMTAwMTAxIEZpcmVmb3gvNjQuMCIsImJyb3dzZXJfdmVyc2lvbiI6IjY0LjAiLCJvc192ZXJzaW9uIjoiMTAiLCJyZWZlcnJlciI6IiIsInJlZmVycmluZ19kb21haW4iOiIiLCJyZWZlcnJlcl9jdXJyZW50IjoiIiwicmVmZXJyaW5nX2RvbWFpbl9jdXJyZW50IjoiIiwicmVsZWFzZV9jaGFubmVsIjoic3RhYmxlIiwiY2xpZW50X2J1aWxkX251bWJlciI6MzA0MTgsImNsaWVudF9ldmVudF9zb3VyY2UiOm51bGx9" -H "DNT: 1" -H "Connection: keep-alive" -H "Cookie: __cfduid=d858fa7055b7203e77800f6fa34a247851546910527" -H "TE: Trailers"
}

linesfilepath="$1"
channelsfilepath="$2"
toiletinvitelink="$3" # cafmqWC
toiletserverid="$4" # 533500611438575627
passes="$5"

lines=-1
for templine in `cat "$linesfilepath" | sed 's/ /|/g'`
do
    let lines+=1
    templine=`echo "$templine" | sed 's/|/ /g'`
    line["$lines"]="$templine"
done

channels=-1
for tempchannel in `cat "$channelsfilepath" | sed 's/ /|/g'`
do
    let channels+=1
    tempchannel=`echo "$tempchannel" | sed 's/|/ /g'`
    channel["$channels"]="$tempchannel"
done

shift 5
opts="$#"
for nein in `seq 1 "$opts"`
do
    opt["$nein"]="$1"
    shift
done

# cat toilethead
# cat toiletfeet
echo -e "Inflated Toilet Spermkle troller by \033[36mdie deutsche Orthopädiespezialist\033[0m"
echo -e "\033[36mlines: \033[32m$((lines+1))\033[36m, channels: \033[32m$((channels+1))\033[0m"
echo "Happy trollin' toilet! (sarcastic"
echo

toilettrolled=0

while true
do
    for nein in `seq 1 "$opts"`
    do
        ./futaba.sh -N -c "conf/pedosona${opt[$nein]}.conf" --join-chatroom "$toiletinvitelink"
        echo
        echo -e "\033[36mprofile \033[32m${opt[$nein]}\033[36m joined safely\033[0m"
        echo
    done

    for pass in `seq 1 $passes`
    do
        for nein in `seq 1 "$opts"`
        do
            trolltoilet "${opt[$nein]}"
            let toilettrolled+=1
            echo -e "\033[36mToilet focked \033[32m$toilettrolled\033[36m time(s)\033[0m"
            echo
        done
    done

    for nein in `seq 1 "$opts"`
    do
        leavechatroom "conf/pedosona${opt[$nein]}.conf" "$toiletserverid"
        echo -e "\033[36mprofile \033[32m${opt[$nein]}\033[36m quitted safely\033[0m"
        echo
    done

    sleep 5
done
