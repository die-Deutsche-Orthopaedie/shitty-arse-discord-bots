#!/bin/bash
# copyrekt die deutsche Orthopädiespezialist 2021
# discord "video hostin'" bot (sarcastic
# split a mp4 video via HLS methods, and upload splited video clips into discord, then replace m3u8 file into one full of discord links, and upload it into discord too

tmpdir="/tmp/discordtubeantics"
[ -d /cygdrive ] && tmpdir_cygwin=`cygpath -w "$tmpdir"` # ffprobe and ffmpeg for windows only accept windows style path
currentdir=`pwd`
username_defaults="kawaii yukari chan"
avatarurl_defaults="https://cdn.discordapp.com/attachments/524633631012945922/693099262237736960/yukari_v3.png"
let maxfilesize=8*1024*1024-114514 # discord's filesize limit is as barbarian as yajuu senpai, so i used 114514 to limit filesize:wiebitte:
let maxfilesize2=50*1024*1024-114514 # discord's filesize limit is as barbarian as yajuu senpai, so i used 114514 to limit filesize:wiebitte:
ratiolimit="0.15"
rate="0.8"

function gretajoke {
    cuties=("Ann" "Chie" "Marie" "Yukari" "Fuuka" "Futaba" "Hifumi" "Riley" "Cosette" "Alice")
    cutie1="Cosette"
    cutie2="Cosette"
    while [ "$cutie1" = "$cutie2" ]
    do
        cutie1=${cuties[$((RANDOM%${#cuties[@]}))]}
        cutie2=${cuties[$((RANDOM%${#cuties[@]}))]}
    done
    echo "$cutie1 chan, $cutie2 chan, and Greta Thunberg were all lost in the desert. They found a lamp and rubbed it. A genie popped out and granted them each one wish. $cutie1 chan wished to be back home. Poof! She was back home. $cutie2 chan wished to be at home with her family. Poof! She was back home with her family. Greta Thunberg said, \\\"How dare you fucking call me Greta Chan! \\\""
}

function praseconf {
    processes=0 # process 0 is nitro process, and other process(es) start with 1
    if [ ! -s "$configfilepath" ]
    then
        echo "Houston, we have an arsefockin' problem: CONFIG FILE IS EMPTY" >&2
        exit 4
    fi

    for templine in `cat "$configfilepath"`
    do
        temp=`echo "$templine" | cut -f1 -d\|`
        if [ "$temp" = "-W" ]
        then
            let processes+=1
            webhookurl[$processes]=`echo "$templine" | cut -f2 -d\|`
            username[$processes]=`echo "$templine" | cut -f3 -d\|`
            avatarurl[$processes]=`echo "$templine" | cut -f4 -d\|`
            if [ ! "${username["$processes"]}" ]
            then
                username[$processes]="$username_defaults $processes"
            fi
            if [ ! "${avatarurl["$processes"]}" ]
            then
                avatarurl[$processes]="$avatarurl_defaults"
            fi
        elif [ "$temp" = "-N" ]
        then # process 0 is nitro process, and other process(es) start with 1
            auth[0]=`echo "$templine" | cut -f2 -d\|`
            channelid[0]=`echo "$templine" | cut -f3 -d\|`
            purechannelid[0]=`echo "${channelid[0]}" | cut -d/ -f2`
        else
            let processes+=1
            auth[$processes]=`echo "$templine" | cut -f1 -d\|`
            channelid[$processes]=`echo "$templine" | cut -f2 -d\|`
            if ! [ "${channelid["$processes"]}" != "${auth["$processes"]}" ]
            then
                channelid[$processes]="${channelid[0]}"
            fi
            purechannelid[$processes]=`echo "${channelid["$processes"]}" | cut -d/ -f2`
        fi
    done
    echo -e "found \e[36m$[processes+1]\e[0m process(es)"
    # if [ "$threadlimit" ]
    # then
        # echo -e "but you set a thread limit of \e[36m$threadlimit\e[0m"
        # [ "$processes" -gt "$threadlimit" ] && processes="$threadlimit"
        # echo -e "so... the actual thread limit was set to \e[36m$processes\e[0m"
    # fi
    # for processid in `seq 0 $processes`
    # do
        # [ "${webhookurl["$processid"]}" ] && echo "${webhookurl["$processid"]} ${username["$processid"]} ${avatarurl["$processid"]}" || echo "${auth["$processid"]} ${channelid["$processid"]} ${purechannelid["$processid"]}"
    # done
}

function uploadfile { # $1 = message, #2 = filepath, #3 = processid (probably useful)
    local processid="$3"
    local discordlink=""
    while [ "$discordlink" = "" ]
    do
        local response=`[ "${webhookurl["$processid"]}" ] && curl -F "payload_json={\"content\":\"$1\",\"username\":\"${username["$processid"]}\",\"avatar_url\":\"${avatarurl["$processid"]}\"}" -F "filename=@$2" "${webhookurl["$processid"]}" || curl "https://discord.com/api/v6/channels/${purechannelid["$processid"]}/messages" -H "User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:61.0) Gecko/20100101 Firefox/61.0" -H "Accept: */*" -H "Accept-Language: en-US" --compressed -H "Referer: https://discordapp.com/channels/${channelid["$processid"]}" -H "Authorization: ${auth["$processid"]}" -H "Content-Type: multipart/form-data; boundary=---------------------------32345443330436" -H "Cookie: __cfduid=d7be2f6bf6a3c09f82cd952f554ea2cb31531625199" -H "DNT: 1" -H "Connection: keep-alive" -F "payload_json={\"content\":\"$1\",\"nonce\":\"46776845$RANDOM$RANDOM$RANDOM\",\"tts\":false}" -F "filename=@$2"`
        discordlink=`echo "$response" | sed 's/,/\n/g' | grep '"url"' | sed 's/"/\n/g' | grep 'http'`
        if [ "$checksums" ]
        then
            if [ "$discordlink" ]
            then
                # wget "$discordlink" -O "$tmpdir/${discordlink##*/}.checksumtemp.$3"
                aria2c -x 8 -s 8 -k 1M -R -c --auto-file-renaming=false "$discordlink" --dir="$tmpdir" --out="${discordlink##*/}.checksumtemp.$3" 1>&2
                local sha5122=`sha512sum "$tmpdir/${discordlink##*/}.checksumtemp.$3" | cut -f1 -d" "`
            else
                local sha5122="999999"
            fi
            local sha5121=`sha512sum "$2" | cut -f1 -d" "`
            
            if [ "$sha5121" == "$sha5122" ]
            then
                # echo -e "\e[36mchecksum for \e[32m$2\e[36 passed[0m" 1>&2
                echo -e "\e[36mchecksum for \e[32m$2\e[36m passed\e[0m" 1>&2
            else
                echo -e "\e[31mchecksum for \e[32m$2\e[31m failed\e[0m, will reupload" 1>&2
                discordlink=""
            fi
            rm "$tmpdir/${discordlink##*/}.checksumtemp.$3" -f
        fi
        sleep $sleeptime
    done
    echo "$discordlink"
}

function upload_subprocess {  # upload a single file into discord, where $1 = process id, $2 = file's fullpath
    local processid="$1"
    local file="$2"
    if [[ "$file" == *,* ]]
    then
        local file2=`echo "$file" | sed 's/,/_/g'`
        mv "$file" "$file2"
        local discordlink=""
        discordlink=`uploadfile "$file" "$file2" "$processid"`
        let processedfiles[$processid]++
        echo -e "\e[36m$discordlink\e[0m uploaded by process \e[32m$processid\e[0m, file \e[36m${processedfiles["$processid"]}\e[0m/\e[32m${filesinprocess["$processid"]}\e[0m"
        echo "$discordlink" >> "$tmpdir/$exportfilename.part$processid"
        mv "$file2" "$file"
    else
        local discordlink=""
        discordlink=`uploadfile "$file" "$file" "$processid"`
        let processedfiles[$processid]++
        echo -e "\e[36m$discordlink\e[0m uploaded by process \e[32m$processid\e[0m, file \e[36m${processedfiles["$processid"]}\e[0m/\e[32m${filesinprocess["$processid"]}\e[0m"
        echo "$discordlink" >> "$tmpdir/$exportfilename.part$processid"
    fi
}

function videoanalysis() { # videopath was already given
    [ -d /cygdrive ] && videotime=`ffprobe -i "$(cygpath -w "$videopath")" -show_entries format=duration -v quiet -of csv="p=0"` || videotime=`ffprobe -i "$videopath" -show_entries format=duration -v quiet -of csv="p=0"`
    videosize=`stat -c "%s" "$videopath"`
    [ "$vtime" ] || vtime=`awk 'BEGIN{printf "%.10f\n",('$videotime'*'$maxfilesize'/'$videosize')}'`
    bruh=1
    rm "$tmpdir" -rf
    time=`date +%y.%m.%d`
    mkdir "$tmpdir"
    while [ "$bruh" -gt 0 ]
    do
        bruh=0
        bigclips=0
        smallclips=0
        [ -d /cygdrive ] && ffmpeg -i "$(cygpath -w "$videopath")" -bsf:v h264_mp4toannexb -c:v copy -c:a copy -hls_time "$vtime" -hls_list_size 0 -f hls "$tmpdir_cygwin\\$videotitle.m3u8" || ffmpeg -i "$videopath" -bsf:v h264_mp4toannexb -c:v copy -c:a copy -hls_time "$vtime" -hls_list_size 0 -f hls "$tmpdir/$videotitle.m3u8"
        for file in `ls "$tmpdir" | grep ts`
        do
            filesize=`stat -c "%s" "$tmpdir/$file"`
            if [ "$filesize" -gt "$maxfilesize2" ]
            then
                echo "$file: $filesize bytes, too big for discord:futabruh:"
                let bruh++
            elif [ "$filesize" -lt "$maxfilesize" ]
            then
                echo "$file: $filesize bytes"
                let smallclips++
            else
                echo "$file: $filesize bytes, would need nitro to upload"
                let bigclips++
            fi
        done
        if [ "$bruh" -gt 0 ]
        then
            vtime=`awk 'BEGIN{printf "%.1f\n",('$vtime'*'$rate')}'`
            echo -e "\e[36mvideo clip time reduced to $vtime sec(s)\e[0m"
            sleep 1
            rm "$tmpdir"/* -f
        fi
        echo "big clips = $bigclips"
        echo "small clips = $smallclips"
        bigratio=`awk 'BEGIN{printf "%.10f\n",('$bigclips'/('$bigclips'+'$smallclips'))}'`
        echo "big clips ratio = $bigratio"
        if [ `awk 'BEGIN{print('$bigratio'>'$ratiolimit')?"JAJAJAJAJA":""}'` ]
        then
            bruh=114514
            vtime=`awk 'BEGIN{printf "%.1f\n",('$vtime'*'$rate')}'`
            echo -e "\e[36mvideo clip time reduced to $vtime sec(s)\e[0m"
            sleep 1
            rm "$tmpdir"/* -f
        fi
    done
}

function scheduler { # muptiple threads
    sleeptime=1
    
    totalfiles=0
    for processid in `seq 0 $processes`
    do
        filesinprocess[$processid]=0
    done
    for processid in `seq 0 $processes`
    do
        processedfiles[$processid]=0
    done
    
    videoanalysis
    
    cat /dev/null > "$tmpdir/$exportfilename"
    for file in `ls "$tmpdir" | grep ts`
    do
        let totalfiles++
        filesize=`stat -c "%s" "$tmpdir/$file"`
        if [ "$filesize" -gt "$maxfilesize" ]
        then
            processid=0
        else
            processid=$[totalfiles%processes+1]
        fi
        echo "$tmpdir/$file" >> "$tmpdir/list$processid"
        let filesinprocess[$processid]++
    done
    
    for processid in `seq 0 $processes`
    do
    {
        for fullpath in `cat "$tmpdir/list$processid"`
        do
            upload_subprocess "$processid" "$fullpath"
        done
    } &
    done
    wait
    
    sleep $sleeptime
    for processid in `seq 0 $processes`
    do
        cat "$tmpdir/$exportfilename.part$processid" >> "$tmpdir/$exportfilename"
    done
    
    for file in `cat "$tmpdir/$videotitle.m3u8" | grep ".ts"`
    do 
        file2=`cat "$tmpdir/$exportfilename" | grep "https://cdn.discordapp.com/.*$file"`
        file2=${file2//\//\\\/}
        sed -i "s/$file/${file2}/g" "$tmpdir/$videotitle.m3u8"
    done
    
    mv "$tmpdir/$videotitle.m3u8" "$currentdir/$videotitle.m3u8"
    m3u8link=`uploadfile "$videotitle" "$currentdir/$videotitle.m3u8" 1`
    echo "$m3u8link"
    [ "$outputfilename" ] && echo "$m3u8link" >> outputfilename || echo "$m3u8link" >> results.bruh
    rm "$tmpdir" -rf
}

OLD_IFS=$IFS
IFS=$'\n'

original_parameters="$0"

for parameter in "$@"
do
    original_parameters="$original_parameters '$parameter'"
done

currentdir=`pwd`
rm "$tmpdir"/* -f
parameters=`getopt -o c:C:o:O:t:T:hH -a -l customratio:,output:,decreaseratio:,videotime:,help -- "$@"`

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
        -h | -H | --help)
            echo "copyrekt die deutsche Orthopädiespezialist 2021"
            echo "discord \"video hostin'\" bot (sarcastic"
            echo "split a mp4 video via HLS methods, and upload splited video clips into discord, then replace m3u8 file into one full of discord links, and upload it into discord too"
            echo
            echo "Usage: "
            echo "./discordvideohosting.sh [options] videotitle videopath config_path"
            echo
            echo "Options: "
            echo "  -t or -T or --videotime <vtime>: manually set the clip time instead of automated calculations"
            echo "  -c or -C or --customratio <ratio>: custom ratio of big clips that exceeds 8MB but not exceeds 50MB outta all clips, default: 0.15"
            echo "      --decreaseratio <rate>: custom rate of clip time decreasing if clips are too big, default: 0.8"
            echo "  -o or -O or --output <filename>: output the generated m3u8 links into a file, in non-overwrite style"
            echo
            echo "by default it shall use webhooks to upload smol clips, but big clips would be uploaded by a nitro account"
            exit
            ;;
        -t | -T | --videotime)
            vtime="$2"
            shift 2
            ;;
        -c | -C | --customratio)
            ratiolimit="$2"
            shift 2
            ;;
        --decreaseratio)
            rate="$2"
            shift 2
            ;;
        -o | -O | --output)
            outputfilename="$2"
            shift 2
            ;;
        --)
            videotitle="$2"
            videopath="$3"
            configfilepath="$4"
            exportfilename="$videotitle.discordlinks.txt"
            praseconf
            scheduler
            break
            ;;
        *)
            echo "Internal error!"
            exit 255
            ;;
    esac
done

IFS=$OLD_IFS
