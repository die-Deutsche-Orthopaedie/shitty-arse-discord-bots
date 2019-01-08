#!/bin/bash
# copyrekt die deutsche Orthopädiespezialist 201⑨
# toilet focker script
# i really can't tolerate that arsehole anymore

######################################################################################################################################################################
function rand(){
    min=$1
    max=$(($2-$min+1))
    num=$(date +%s%N)
    echo $(($num%$max+$min))
}

function focktoilet() {
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

linesfilepath="$1"
channelsfilepath="$2"

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

shift 2
opts="$#"
for nein in `seq 1 "$opts"`
do
    opt["$nein"]="$1"
    shift
done

# cat toilethead
# cat toiletfeet
echo -e "Inflated Toilet Spermkle focker by \033[36mdie deutsche Orthopädiespezialist\033[0m"
echo -e "\033[36mlines: \033[32m$((lines+1))\033[36m, channels: \033[32m$((channels+1))\033[0m"
echo "Happy fockin' toilet! (sarcastic"
echo

toiletfocked=0
while true
do
    for nein in `seq 1 "$opts"`
    do
        focktoilet "${opt[$nein]}"
        let toiletfocked+=1
        echo -e "\033[36mToilet focked \033[32m$toiletfocked\033[36m time(s)\033[0m"
        echo
    done
done
