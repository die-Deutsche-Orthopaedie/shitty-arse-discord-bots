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
rate="0.8"

function gretajoke_v2 {
    cuties=("Ann" "Chie" "Marie" "Yukari" "Fuuka" "Futaba" "Hifumi" "Riley" "Cosette" "Ryza" "Alice" "Barbara" "Jean" "Sucrose" "Fischl")
    villains=("Greta Thunberg" "Lea chan" "Toilet chan" "Jono chan" "Yajuu senpai" "Paimon")
    villainquotes=("How dare you fucking call me Greta Chan! " "Don't fucking call me Lea Chan. " "@everyone Don't call me Toilet Chan, pls. " "posting UCC \\\"chan\\\" will result in a suitable punishment. " "Iiyo! Koiyo! No! Humph! Humph! AAAAAAAAAAAAAAAAA! AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA! " "Wiebit te nandayo! ")
    cutie1="Cosette"
    cutie2="Cosette"
    while [ "$cutie1" = "$cutie2" ]
    do
        cutie1=${cuties[$((RANDOM%${#cuties[@]}))]}
        cutie2=${cuties[$((RANDOM%${#cuties[@]}))]}
    done
    villain="$((RANDOM%${#villains[@]}))"
    echo $villian
    echo "$cutie1 chan, $cutie2 chan, and ${villains["$villian"]} were all lost in the desert. They found a lamp and rubbed it. A genie popped out and granted them each one wish. $cutie1 chan wished to be back home. Poof! She was back home. $cutie2 chan wished to be at home with her family. Poof! She was back home with her family. ${villains["$villian"]} said, \\\"${villainquotes["$villian"]}\\\""
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
    
    [ "$ratiolimit" ] || ratiolimit=`awk 'BEGIN{printf "%.10f\n",(1/(1+'$processes'))}'`
    
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

function m3u8generation() {
    cat /dev/null > "$m3u8dir/$videotitle.m3u8"
    echo "#EXTM3U" >> "$m3u8dir/$videotitle.m3u8"
    echo "#EXT-X-VERSION:3" >> "$m3u8dir/$videotitle.m3u8"
    echo "#EXT-X-TARGETDURATION:5" >> "$m3u8dir/$videotitle.m3u8"
    echo "#EXT-X-MEDIA-SEQUENCE:0" >> "$m3u8dir/$videotitle.m3u8"

    max=`ls $m3u8dir | grep -Eo "split.[0-9]*.ts" | grep -Eo "[0-9]*" | awk 'NR==1{max=$1;next}{max=max>$1?max:$1}END{print max}'`
    min=`ls $m3u8dir | grep -Eo "split.[0-9]*.ts" | grep -Eo "[0-9]*" | awk 'NR==1{min=$1;next}{min=min<$1?min:$1}END{print min}'`
    filebase=`ls $m3u8dir | grep "split.[0-9]*.ts" | sed 's/.split.[0-9]*.ts//g' | uniq`

    if [ "$mparallel" ]
    then
        [ "$mprocesses" ] || mprocesses=24
        dem="$[(max-min+1)/mprocesses]"
        for bruh in `seq $min $dem $max`
        do
        {
            [ `expr $bruh + $dem - 1 - $max` -gt 0 ] && bruh2=$max || bruh2=`expr $bruh + $dem - 1`
            for file in `seq $bruh $bruh2`
            do 
                [ -d /cygdrive ] && time=`ffprobe -i "$(cygpath -w "$m3u8dir/$filebase.split.$file.ts")" -show_entries format=duration -v quiet -of csv="p=0"`  || time=`ffprobe -i "$m3u8dir/$filebase.split.$file.ts" -show_entries format=duration -v quiet -of csv="p=0"`
                echo "#EXTINF:$time," | sed 's/\r//g;s/\n//g' >> "$m3u8dir/$videotitle.m3u8.temp.$bruh-$bruh2"
                echo "$filebase.split.$file.ts" >> "$m3u8dir/$videotitle.m3u8.temp.$bruh-$bruh2"
            done
        } &
        done
        wait
        for bruh in `seq $min $dem $max`
        do
            [ `expr $bruh + $dem - 1 - $max` -gt 0 ] && bruh2=$max || bruh2=`expr $bruh + $dem - 1`
            cat "$m3u8dir/$videotitle.m3u8.temp.$bruh-$bruh2" >> "$m3u8dir/$videotitle.m3u8"
            rm "$m3u8dir/$videotitle.m3u8.temp.$bruh-$bruh2" -f
        done
    else
        for file in `seq $min $max`
        do 
            [ -d /cygdrive ] && time=`ffprobe -i "$(cygpath -w "$m3u8dir/$filebase.split.$file.ts")" -show_entries format=duration -v quiet -of csv="p=0"`  || time=`ffprobe -i "$m3u8dir/$filebase.split.$file.ts" -show_entries format=duration -v quiet -of csv="p=0"`
            echo "#EXTINF:$time," | sed 's/\r//g;s/\n//g' >> "$m3u8dir/$videotitle.m3u8"
            echo "$filebase.split.$file.ts" >> "$m3u8dir/$videotitle.m3u8"
        done
    fi

    echo "#EXT-X-ENDLIST" >> "$m3u8dir/$videotitle.m3u8"
    
    [ "$directdir" ] || exit
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

function scheduler { # muptiple threads upload only
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
    
    if [ "$directdir" ]
    then
        rm "$tmpdir" -rf
        mkdir "$tmpdir"
        cp -p "$directdir/$videotitle.m3u8" "$tmpdir/$videotitle.m3u8"
    else
        videoanalysis
    fi
    
    cat /dev/null > "$tmpdir/$exportfilename"
    
    if [ "$directdir" ]
    then
        for file in `ls "$directdir" | grep ts`
        do
            let totalfiles++
            filesize=`stat -c "%s" "$directdir/$file"`
            if [ "$filesize" -gt "$maxfilesize" ]
            then
                processid=0
            else
                processid=$[totalfiles%processes+1]
            fi
            echo "$directdir/$file" >> "$tmpdir/list$processid"
            let filesinprocess[$processid]++
        done
    else
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
    fi

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

function scheduler2 { # muptiple threads upload and replacements
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
    
    if [ "$directdir" ]
    then
        rm "$tmpdir" -rf
        mkdir "$tmpdir"
        cp -p "$directdir/$videotitle.m3u8" "$tmpdir/$videotitle.m3u8"
    else
        videoanalysis
    fi
    
    for processid in `seq 0 $processes`
    do
    {
        cat /dev/null > "$tmpdir/$exportfilename.part$processid"
    } &
    done
    wait

    cat "$tmpdir/$videotitle.m3u8" | sed '1,4d;$d' | sed ':a;N;$!ba;s/,\n/,/g;' > "$tmpdir/$videotitle.m3u8.temp"
    totallines=`cat "$tmpdir/$videotitle.m3u8.temp" | wc -l`
    lineperprocess="$[totallines/processes+1]"
    for line in `cat "$tmpdir/$videotitle.m3u8.temp"`
    do
        let totalfiles++
        echo "$line" >> "$tmpdir/$videotitle.m3u8.part$[totalfiles/lineperprocess+1]"
        filename=`echo $line | cut -d, -f2`
        [ "$directdir" ] && filesize=`stat -c "%s" "$directdir/$filename"` || filesize=`stat -c "%s" "$tmpdir/$filename"`
        if [ "$filesize" -gt "$maxfilesize" ]
        then
            processid=0
        else
            processid=$[totalfiles/lineperprocess+1]
        fi
        [ "$directdir" ] && echo "$directdir/$filename" >> "$tmpdir/list$processid" || echo "$tmpdir/$filename" >> "$tmpdir/list$processid"
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
    
    for processid in `seq 1 $processes`
    do
    {
        for file in `cat "$tmpdir/$videotitle.m3u8.part$processid" | cut -d, -f2`
        do 
            file2=`cat "$tmpdir/$exportfilename.part$processid" | grep "https://cdn.discordapp.com/.*$file"`
            [ "$file2" ] || file2=`cat "$tmpdir/$exportfilename.part0" | grep "https://cdn.discordapp.com/.*$file"`
            file2=${file2//\//\\\/}
            sed -i "s/$file/${file2}/g" "$tmpdir/$videotitle.m3u8.part$processid"
        done
    } &
    done
    wait

    cat /dev/null > "$currentdir/$videotitle.m3u8"
    echo "#EXTM3U" >> "$currentdir/$videotitle.m3u8"
    echo "#EXT-X-VERSION:3" >> "$currentdir/$videotitle.m3u8"
    echo "#EXT-X-TARGETDURATION:5" >> "$currentdir/$videotitle.m3u8"
    echo "#EXT-X-MEDIA-SEQUENCE:0" >> "$currentdir/$videotitle.m3u8"
    for processid in `seq 1 $processes`
    do
        cat "$tmpdir/$videotitle.m3u8.part$processid" | sed 's/,/,\n/g'>> "$currentdir/$videotitle.m3u8"
    done
    echo "#EXT-X-ENDLIST" >> "$currentdir/$videotitle.m3u8"
    
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
parameters=`getopt -o c:C:o:O:t:T:hHpP -a -l customratio:,output:,decreaseratio:,videotime:,m3u8generation:,directdir:,tsmuxer-antics:,m3u8-parallel,m3u8-processes:,replace-parallel,parallel,help -- "$@"`

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
            echo "meanwhile i found a better way to split videos via tsMuxeR, too bad its command line version just does not implement this function; that means it needed to be half-arsed, instead of full-arsed in one single script:barbruh:"
            echo
            echo "Usage: "
            echo "./discordvideohosting.sh [options] videotitle videopath config_path"
            echo
            echo "Options: "
            echo "  -t or -T or --videotime <vtime>: manually set the clip time instead of automated calculations"
            echo "  -c or -C or --customratio <ratio>: custom ratio of big clips that exceeds 8MB but not exceeds 50MB outta all clips, default: 1/(1+processs)"
            echo "      --decreaseratio <rate>: custom rate of clip time decreasing if clips are too big, default: 0.8"
            echo "  -o or -O or --output <filename>: output the generated m3u8 links into a file, in non-overwrite style"
            echo
            echo "tsMuxeR antics: "
            echo "  --m3u8generation <dir>: generate m3u8 from an already tsMuxeR-splited folder"
            echo "  --directdir <dir>: use when video clips and m3u8 was already present, like processed by --m3u8generation"
            echo "  --tsmuxer-antics <dir>: equals --m3u8generation <dir> --directdir <dir>, dealin' both of them on the same computer"
            echo 
            echo "extra parallelisms (experimental): "
            echo "  --m3u8-parallel: parallelly generate m3u8"
            echo "    --m3u8-processes: set processes of m3u8 generation, default: 24"
            echo "  --replace-parallel: parallelly replaced m3u8 with discord links"
            echo "  -p or -P or --parallel: equals --m3u8-parallel and --replace-parallel"
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
        --m3u8generation)
            m3u8dir="$2"
            shift 2
            ;;
        --directdir)
            directdir="$2"
            shift 2
            ;;
        --tsmuxer-antics)
            m3u8dir="$2"
            directdir="$2"
            shift 2
            ;;
        --m3u8-parallel)
            mparallel="JAJAJAJAJA"
            shift
            ;;
        --m3u8-processes)
            mprocesses="$2"
            shift 2
            ;;
        --replace-parallel)
            rparallel="JAJAJAJAJA"
            shift
            ;;
        -p | -P | --parallel)
            mparallel="JAJAJAJAJA"
            rparallel="JAJAJAJAJA"
            shift
            ;;
        --)
            videotitle="$2"
            videopath="$3"
            configfilepath="$4"
            break
            ;;
        *)
            echo "Internal error!"
            exit 255
            ;;
    esac
done

[ "$m3u8dir" ] && m3u8generation

exportfilename="$videotitle.discordlinks.txt"
praseconf

[ "$rparallel" ] && scheduler2 || scheduler

IFS=$OLD_IFS
