#!/bin/bash
# copyrekt die deutsche Orthopädiespezialist 2020
# channel archive bot for discord, but fegelly improved
# archive a discord channel before it's deleted by its arsehole mods
# only auth would be accepted, and added attachment re-upload feature to re-upload attachments and perhaps replace attachment links in original dumped messages into our repuloaded attachments
# and perhaps upload via nitro account instead of webhooks or normal accounts if attachments exceeded a certain size:futabruh:
# and now continue and incremental modes are also made and it just futabruhin' works
# i even added a futabruhin' greta joke:howdareyou::gertabitte:
# (v4) now it supports multithreading attachment reuploadin' feature 
# (v4) and even optimized for large message dumps (> 10000 messages)
# now if your arsehole mod threatens to delete a channel in an hour, you know what the futabruh you would do, bc it would indeed finish dumpin' a 60000 message channel within an hour:wiebitte:

tmpdir="/tmp/wiebitte"
currentdir=`pwd`
username_defaults="kawaii yukari chan"
avatarurl_defaults="https://cdn.discordapp.com/attachments/524633631012945922/693099262237736960/yukari_v3.png"
let maxfilesize=8*1024*1024-114514 # discord's filesize limit is as barbarian as yajuu senpai, so i used 114514 to limit filesize:wiebitte:

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
    echo -e "found \e[36m$processes\e[0m process(es)"
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

function reupload_subprocess { # $1 = process id
    local processid="$1"
    local line
    local totalbruh=`cat "$tmpdir/metadata$processid" | wc -l`
    local bruh=0
    for line in `cat "$tmpdir/metadata$processid"`
    do
        let bruh++
        local messageid=`echo "$line" | cut -f1 -d\|`
        local attachmenturl=`echo "$line" | cut -f3 -d\|`
        local attachmentproxyurl=`echo "$line" | cut -f4 -d\|`
        echo -e "processin' \e[36m$attachmenturl\e[0m from message id \e[36m$messageid\e[0m by process \e[32m$processid\e[0m"
        cd "$tmpdir.$processid"
        rm "$tmpdir.$processid"/* -f
        aria2c -x 16 -s 16 -k 1M -R -c --auto-file-renaming=false "$attachmenturl"
        local files
        for files in `ls "$tmpdir.$processid"`
        do
            if [ "${webhookurl["$processid"]}" ]
            then
                local response=`curl -F "payload_json={\"content\":\"attachment for message id $messageid\",\"username\":\"${username["$processid"]}\",\"avatar_url\":\"${avatarurl["$processid"]}\"}" -F "filename=@$files" "${webhookurl["$processid"]}"`
                # echo "$response"
                sleep 2
            else
                local response=`curl "https://discordapp.com/api/v6/channels/${purechannelid["$processid"]}/messages" -H "User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:61.0) Gecko/20100101 Firefox/61.0" -H "Accept: */*" -H "Accept-Language: en-US" --compressed -H "Referer: https://discordapp.com/channels/${channelid["$processid"]}" -H "Authorization: ${auth["$processid"]}" -H "Content-Type: multipart/form-data; boundary=---------------------------32345443330436" -H "Cookie: __cfduid=d7be2f6bf6a3c09f82cd952f554ea2cb31531625199" -H "DNT: 1" -H "Connection: keep-alive" -F "payload_json={\"content\":\"attachment for message id $messageid\",\"tts\":false}" -F "filename=@$files"`
                # echo "$response"
                sleep 2
            fi
            local newattachmenturl=`echo "$response" | grep -Eo '"attachments": \[.{1,}\], "embeds"' | grep -Eo '"url": ".{1,}", "proxy_url"' | sed 's/"/\n/g' | grep "http"`
            local newattachmentproxyurl=`echo "$response" | grep -Eo '"attachments": \[.{1,}\], "embeds"' | grep -Eo '"proxy_url": ".{1,}"' | sed 's/"/\n/g' | grep "http"`
            echo "$newattachmenturl" >> "$tmpdir/aria2$processid"
            echo " dir=${filename%.*}.attachments" >> "$tmpdir/aria2$processid"
            echo " out=$messageid.$files" >> "$tmpdir/aria2$processid"
            echo "$attachmenturl|$newattachmenturl" >> "$tmpdir/results$processid"
            echo "$attachmentproxyurl|$newattachmentproxyurl" >> "$tmpdir/results$processid"
            echo -e "\e[36m$attachmenturl\e[0m from message id \e[36m$messageid\e[0m by process \e[32m$processid\e[0m done processin', new, url: \e[36m$newattachmenturl\e[0m"
        done
        rm "$tmpdir.$processid"/* -f
        echo -e "\e[36m$bruh\e[0m outta \e[36m$totalbruh\e[0m files(s) in process \e[32m$processid\e[0m has been reuploaded"
    done
}

function analysis_subprcess { # $1 = process id
    local processid="$1"
    local singlemessage
    local totalbruh=`cat "$tmpdir/$filename.part$processid" | wc -l`
    local bruh=0
    for singlemessage in `cat "$tmpdir/$filename.part$processid"`
    do
        let bruh++
        local messageid=`echo "$singlemessage" | grep -Eo '{"id": "[0-9]*", "type"' | grep -Eo '[0-9]*'`
        if [ `echo "$singlemessage" | grep -Eo '"attachments": \[.{1,}\], "embeds"'` ]
        then
            local singleattachment
            for singleattachment in `echo "$singlemessage" | grep -Eo '"attachments": \[.{1,}\], "embeds"' | sed 's/"attachments": \[//g' | sed 's/\], "embeds"//g' | sed 's/}, {/}\n{/g'`
            do
                local attachmenturl=`echo "$singleattachment" | grep -Eo '"url": ".{1,}", "proxy_url"' | sed 's/"/\n/g' | grep "http"`
                local attachmentproxyurl=`echo "$singleattachment" | grep -Eo '"proxy_url": ".{1,}"' | sed 's/"/\n/g' | grep "http"`
                local filesize=`echo "$singleattachment" | grep -Eo '"size": [0-9]*,' | grep -Eo "[0-9]*"`
                
                if [ "$filesize" -gt "$maxfilesize" ]
                then
                    echo "$messageid|$filesize|$attachmenturl|$attachmentproxyurl" >> "$tmpdir/metadata0"
                    echo -e "detected attachment (again? ) and distributed to \e[36nitro process\e[0, url: \e[32m$attachmenturl\e[0m"
                    echo "$attachmenturl" >> "$tmpdir/aria2original0"
                    echo " dir=${filename%.*}.attachments.original" >> "$tmpdir/aria2original0"
                    echo " out=$messageid.${attachmenturl##*/}" >> "$tmpdir/aria2original0"
                else
                    echo "$messageid|$filesize|$attachmenturl|$attachmentproxyurl" >> "$tmpdir/metadata$processid"
                    echo -e "detected attachment (again? ) and distributed to \e[36process $processid\e[0, url: \e[32m$attachmenturl\e[0m"
                    echo "$attachmenturl" >> "$tmpdir/aria2original$processid"
                    echo " dir=${filename%.*}.attachments.original" >> "$tmpdir/aria2original$processid"
                    echo " out=$messageid.${attachmenturl##*/}" >> "$tmpdir/aria2original$processid"
                fi
            done
        fi
        echo -e "\e[36m$bruh\e[0m outta \e[36m$totalbruh\e[0m messages(s) in process \e[32m$processid\e[0m has been processed"
    done
}

function replace_subprocess {
    local processid="$1"
    local totalbruh=`cat "$tmpdir/results$processid" | wc -l`
    local bruh=0
    for line in `cat "$tmpdir/results$processid"`
    do
        let bruh++
        local before=`echo "$line" | cut -f1 -d\|`
        local after=`echo "$line" | cut -f2 -d\|`
        sed -i "s/${before//\//\\/}/${after//\//\\/}/g" "$tmpdir/$filename.part$processid"
        echo -e "replaced \e[36m$bruh\e[0m outta \e[36m$totalbruh\e[0m line(s) in original dumps for process \e[32m$processid\e[0m"
    done
}

function s1p1 {
    for processid in `seq 0 $processes`
    do
    {
        reupload_subprocess "$processid"
    } &
    done
    wait
}

function s1p2 {
    cp -p "$currentdir/$filename" "$currentdir/${filename%.*}.replaced.${filename##*.}"
    totalbruh=`cat "$currentdir/${filename%.*}.sedresults" | wc -l`
    bruh=0
    for line in `cat "$currentdir/${filename%.*}.sedresults"`
    do
        let bruh++
        before=`echo "$line" | cut -f1 -d\|`
        after=`echo "$line" | cut -f2 -d\|`
        sed -i "s/${before//\//\\/}/${after//\//\\/}/g" "$currentdir/${filename%.*}.replaced.${filename##*.}"
        echo -e "replaced \e[36m$bruh\e[0m outta \e[36m$totalbruh\e[0m line(s) in original dumps"
    done
}

function scheduler {
    for bruh in `seq 0 $processes`
    do
        mkdir "$tmpdir.$bruh"
        rm "$tmpdir.$bruh"/* -f
    done
    
    totalfiles=0
    for line in `cat "$currentdir/${filename%.*}.metadata"`
    do
        messageid=`echo "$line" | cut -f1 -d\|`
        filesize=`echo "$line" | cut -f2 -d\|`
        attachmenturl=`echo "$line" | cut -f3 -d\|`
        attachmentproxyurl=`echo "$line" | cut -f4 -d\|`
        if [ "$filesize" -gt "$maxfilesize" ]
        then
            echo "$line" >> "$tmpdir/metadata0"
        else
            echo "$line" >> "$tmpdir/metadata$((totalfiles%(processes)+1))"
            let totalfiles++
        fi
    done
    
    echo ">>>> time for stage 2 reupload phase: " >> "$currentdir/${filename%.*}.timestat.temp"
    # /usr/bin/time -a -o "$currentdir/${filename%.*}.timestat.temp" s1p1
    ( time s1p1 ) 2>> "$currentdir/${filename%.*}.timestat.temp"
    
    for processid in `seq 0 $processes`
    do
        cat "$tmpdir/results$processid" >> "$currentdir/${filename%.*}.sedresults"
        cat "$tmpdir/aria2$processid" >> "$currentdir/${filename%.*}.aria2"
    done
    
    echo ">>>> time for stage 2 sedreplace phase: " >> "$currentdir/${filename%.*}.timestat.temp"
    # /usr/bin/time -a -o "$currentdir/${filename%.*}.timestat.temp" s1p2
    ( time s1p2 ) 2>> "$currentdir/${filename%.*}.timestat.temp"
}

function s2p1 {
    for processid in `seq 1 $processes`
    do
    {
        analysis_subprcess "$processid"
    } &
    done
    wait
}

function s2p2 {
    for processid in `seq 0 $processes`
    do
    {
        reupload_subprocess "$processid"
    } &
    done
    wait
}

function s2p3 {
    for processid in `seq 1 $processes`
    do
    {
        replace_subprocess "$processid"
    } &
    done
    wait
    
    for processid in `seq 1 $processes`
    do
        cat "$tmpdir/$filename.part$processid" >> "$currentdir/${filename%.*}.replaced.${filename##*.}"
    done
    
    totalbruh=`cat "$tmpdir/results0" | wc -l`
    bruh=0
    for line in `cat "$tmpdir/results0"`
    do
        let bruh++
        before=`echo "$line" | cut -f1 -d\|`
        after=`echo "$line" | cut -f2 -d\|`
        sed -i "s/${before//\//\\/}/${after//\//\\/}/g" "$currentdir/${filename%.*}.replaced.${filename##*.}"
        echo -e "replaced \e[36m$bruh\e[0m outta \e[36m$totalbruh\e[0m line(s) in original dumps for \e[32mnitro process\e[0m"
    done
}

function scheduler2 {
    for bruh in `seq 0 $processes`
    do
        mkdir "$tmpdir.$bruh"
        rm "$tmpdir.$bruh"/* -f
    done
    
    # spilt message dumps into $processes files, assumin' they're in $tmpdir/$filename.part$processid, where process 0 does not do that
    totalbitte=`cat "$currentdir/$filename" | wc -l`
    wiebitte=0
    for line in `seq 0 $((totalbitte/processes)) $totalbitte`
    do
        let wiebitte++
        if [ "$wiebitte" -eq "$processes" ]         
        then 
            sed -n "$((line+1)),$totalbitte""p" "$currentdir/$filename" > "$tmpdir/$filename.part$wiebitte" 
            break
        else
            sed -n "$((line+1)),$((line+totalbitte/processes))p" "$currentdir/$filename" > "$tmpdir/$filename.part$wiebitte"
        fi
    done
    
    echo ">>>> time for stage 2 analysis phase: " >> "$currentdir/${filename%.*}.timestat.temp"
    # /usr/bin/time -a -o "$currentdir/${filename%.*}.timestat.temp" s2p1
    ( time s2p1 ) 2>> "$currentdir/${filename%.*}.timestat.temp"

    echo ">>>> time for stage 2 reupload phase: " >> "$currentdir/${filename%.*}.timestat.temp"
    # /usr/bin/time -a -o "$currentdir/${filename%.*}.timestat.temp" s2p2
    ( time s2p2 ) 2>> "$currentdir/${filename%.*}.timestat.temp"
    
    for processid in `seq 0 $processes`
    do
        cat "$tmpdir/results$processid" >> "$currentdir/${filename%.*}.sedresults"
        cat "$tmpdir/aria2$processid" >> "$currentdir/${filename%.*}.aria2"
        cat "$tmpdir/aria2original$processid" >> "$currentdir/${filename%.*}.aria2.original"
    done
    
    echo ">>>> time for stage 2 sedreplace phase: " >> "$currentdir/${filename%.*}.timestat.temp"
    # /usr/bin/time -a -o "$currentdir/${filename%.*}.timestat.temp" s2p3
    ( time s2p3 ) 2>> "$currentdir/${filename%.*}.timestat.temp"
}

function stage2 {
    praseconf

    if [ "$optimized" ] 
    then
        scheduler2 
    else
        scheduler
    fi
    
    echo ">>>> time for stage 2: " >> "$currentdir/${filename%.*}.timestat.temp"
}

function stage1 {
    if [ "$messageid" ]
    then
        url="https://discordapp.com/api/v6/channels/$rpurechannelid/messages?before=$messageid&limit=50"
        echo $url
    else
        url="https://discordapp.com/api/v6/channels/$rpurechannelid/messages?limit=50"
    fi
    original=`curl "$url" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:66.0) Gecko/20100101 Firefox/66.0" -H "Accept: */*" --compressed -H "Referer: https://discordapp.com/channels/$rchannelid" -H "Authorization: $rauth" -H "DNT: 1" -H "Connection: keep-alive" -H "Cookie: __cfduid=d5654e7ddceb28663e0d4ee79adbf39e81538640920" -H "TE: Trailers"`
    while [ "$original" = "error500" ]
    do
        original=`curl "$url" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:66.0) Gecko/20100101 Firefox/66.0" -H "Accept: */*" --compressed -H "Referer: https://discordapp.com/channels/$rchannelid" -H "Authorization: $rauth" -H "DNT: 1" -H "Connection: keep-alive" -H "Cookie: __cfduid=d5654e7ddceb28663e0d4ee79adbf39e81538640920" -H "TE: Trailers"`
        sleep 1
    done
    
    [ "$finished" ] && bruh2="$finished" || bruh2=0
    echo "$original"
    while [ "$original" != "[]" ]
    do
        local bruh=0
        for singlemessage in `echo "$original" | sed 's/^\[//g' | sed 's/\]$//g' | sed 's/}, {"id": "\([0-9]*\)", "type"/}\n{"id": "\1", "type"/g'`
        do
            let bruh++
            let bruh2++
            messageid=`echo "$singlemessage" | grep -Eo '{"id": "[0-9]*", "type"' | grep -Eo '[0-9]*'`
            if [ "$messageid" -eq "$lastmessageid" ] 
            then
                echo -e "\e[33mcurrent message id \e[36m$messageid\e[33m equals the latest message id of base dumps, stoppin'\e[0m"
                IFS=$OLD_IFS
                exit
            fi
            
            if [ "$estimation" ]
            then
                echo -e "processin' messages \e[36m$bruh\e[0m/50, outta total progress of \e[36m$bruh2\e[32m/$totalresults\e[0m, message id: \e[36m$messageid\e[0m"
            else
                echo -e "processin' messages \e[36m$bruh\e[0m/50, message id: \e[36m$messageid\e[0m"
            fi
            
            if [ "$reupload" ]
            then
                if [ `echo "$singlemessage" | grep -Eo '"attachments": \[.{1,}\], "embeds"'` ]
                then
                    for singleattachment in `echo "$singlemessage" | grep -Eo '"attachments": \[.{1,}\], "embeds"' | sed 's/"attachments": \[//g' | sed 's/\], "embeds"//g' | sed 's/}, {/}\n{/g'`
                    do
                        attachmenturl=`echo "$singleattachment" | grep -Eo '"url": ".{1,}", "proxy_url"' | sed 's/"/\n/g' | grep "http"`
                        attachmentproxyurl=`echo "$singleattachment" | grep -Eo '"proxy_url": ".{1,}"' | sed 's/"/\n/g' | grep "http"`
                        echo -e "\e[36mdetected attachment, url: \e[32m$attachmenturl\e[0m"
                        echo "$attachmenturl" >> "$currentdir/${filename%.*}.aria2.original"
                        echo " dir=${filename%.*}.attachments.original" >> "$currentdir/${filename%.*}.aria2.original"
                        echo " out=$messageid.${attachmenturl##*/}" >> "$currentdir/${filename%.*}.aria2.original"
                        cd "$tmpdir"
                        rm "$tmpdir"/* -f
                        # wget "$attachmenturl"
                        aria2c -x 16 -s 16 -k 1M -R -c --auto-file-renaming=false "$attachmenturl"
                        for file in `ls "$tmpdir"`
                        do
                            filesize=`ls -l "$tmpdir/$file" | awk '{print $5}'`
                            if [ "$filesize" -lt "$maxfilesize" ]
                            then
                                response=`curl -F "payload_json={\"content\":\"attachment for message id $messageid\",\"username\":\"kawaii yukari chan\",\"avatar_url\":\"https://cdn.discordapp.com/attachments/524633631012945922/693099262237736960/yukari_v3.png\"}" -F "filename=@$file" "$swebhookurl"`
                                sleep 2
                            else
                                echo -e "\e[33mattachment file size exceeded evil discord webhook filesize limit, would upload via nitro account\e[0m"
                                response=`curl "https://discordapp.com/api/v6/channels/$nitropurechannelid/messages" -H "User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:61.0) Gecko/20100101 Firefox/61.0" -H "Accept: */*" -H "Accept-Language: en-US" --compressed -H "Referer: https://discordapp.com/channels/$nitrochannelid" -H "Authorization: $nitroauth" -H "Content-Type: multipart/form-data; boundary=---------------------------32345443330436" -H "Cookie: __cfduid=d7be2f6bf6a3c09f82cd952f554ea2cb31531625199" -H "DNT: 1" -H "Connection: keep-alive" -F "payload_json={\"content\":\"attachment for message id $messageid\",\"tts\":false}" -F "filename=@$file"`
                                sleep 2
                            fi
                            newattachmenturl=`echo "$response" | grep -Eo '"attachments": \[.{1,}\], "embeds"' | grep -Eo '"url": ".{1,}", "proxy_url"' | sed 's/"/\n/g' | grep "http"`
                            echo -e "\e[36mreuploaded, new url: \e[32m$newattachmenturl\e[0m"
                            newattachmentproxyurl=`echo "$response" | grep -Eo '"attachments": \[.{1,}\], "embeds"' | grep -Eo '"proxy_url": ".{1,}"' | sed 's/"/\n/g' | grep "http"`
                            singlemessage=${singlemessage/$attachmenturl/$newattachmenturl}
                            singlemessage=${singlemessage/$attachmentproxyurl/$newattachmentproxyurl}
                            echo "$newattachmenturl" >> "$currentdir/${filename%.*}.aria2"
                            echo " dir=${filename%.*}.attachments" >> "$currentdir/${filename%.*}.aria2"
                            echo " out=$messageid.$file" >> "$currentdir/${filename%.*}.aria2"
                            if [ "$store" ]
                            then
                                mv "$file" "$storelocaion/$messageid.$file"
                            fi
                        done
                        rm "$tmpdir"/* -f
                    done
                fi
                cd "$currentdir"
                echo "$singlemessage" >> "$currentdir/$filename"
                echo
            elif [ ! "$optimized" ]
            then
                echo "$singlemessage" >> "$currentdir/$filename"
                if [ `echo "$singlemessage" | grep -Eo '"attachments": \[.{1,}\], "embeds"'` ]
                then
                    for singleattachment in `echo "$singlemessage" | grep -Eo '"attachments": \[.{1,}\], "embeds"' | sed 's/"attachments": \[//g' | sed 's/\], "embeds"//g' | sed 's/}, {/}\n{/g'`
                    do
                        attachmenturl=`echo "$singleattachment" | grep -Eo '"url": ".{1,}", "proxy_url"' | sed 's/"/\n/g' | grep "http"`
                        attachmentproxyurl=`echo "$singleattachment" | grep -Eo '"proxy_url": ".{1,}"' | sed 's/"/\n/g' | grep "http"`
                        if [ "$multithreading" ]
                        then
                            filesize=`echo "$singleattachment" | grep -Eo '"size": [0-9]*,' | grep -Eo "[0-9]*"`
                            echo "$messageid|$filesize|$attachmenturl|$attachmentproxyurl" >> "$currentdir/${filename%.*}.metadata"
                        fi
                        echo -e "\e[36mdetected attachment, url: \e[32m$attachmenturl\e[0m"
                        echo "$attachmenturl" >> "$currentdir/${filename%.*}.aria2.original"
                        echo " dir=${filename%.*}.attachments.original" >> "$currentdir/${filename%.*}.aria2.original"
                        echo " out=$messageid.${attachmenturl##*/}" >> "$currentdir/${filename%.*}.aria2.original"
                    done
                fi
                echo
            else
                echo "$singlemessage" >> "$currentdir/$filename"
            fi
        done
        
        original=`curl "https://discordapp.com/api/v6/channels/$rpurechannelid/messages?before=$messageid&limit=50" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:66.0) Gecko/20100101 Firefox/66.0" -H "Accept: */*" --compressed -H "Referer: https://discordapp.com/channels/$rchannelid" -H "Authorization: $rauth" -H "DNT: 1" -H "Connection: keep-alive" -H "Cookie: __cfduid=d5654e7ddceb28663e0d4ee79adbf39e81538640920" -H "TE: Trailers"`
        while [ "$original" = "error500" ]
        do
            original=`curl "https://discordapp.com/api/v6/channels/$rpurechannelid/messages?before=$messageid&limit=50" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:66.0) Gecko/20100101 Firefox/66.0" -H "Accept: */*" --compressed -H "Referer: https://discordapp.com/channels/$rchannelid" -H "Authorization: $rauth" -H "DNT: 1" -H "Connection: keep-alive" -H "Cookie: __cfduid=d5654e7ddceb28663e0d4ee79adbf39e81538640920" -H "TE: Trailers"`
            sleep 1
        done
    done
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
parameters=`getopt -o c:C:i:I:a:A:eEuUs:S:hHmMoO -a -l continue:,incremental:,antics:,estimation,reupload,store:help,multithreading,optimized -- "$@"`

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
        -c | -C | --continue)
            messageid=`cat $2 | tail -1 | grep -Eo '{"id": "[0-9]*", "type"' | grep -Eo '[0-9]*'`
            finished=`cat $2 | wc -l`
            shift 2
            ;;
        -i | -I | --incremental)
            lastmessageid=`cat $2 | head -1 | grep -Eo '{"id": "[0-9]*", "type"' | grep -Eo '[0-9]*'`
            shift 2
            ;;
        -a | -A | --antics)
            antics="JAJAJAJAJA"
            rarfilename="$2"
            shift 2
            ;;
        -e | -E | --estimation)
            estimation="JAJAJAJAJA"
            shift
            ;;
        -u | -U | --reupload)
            reupload="JAJAJAJAJA"
            shift
            ;;
        -s | -S | --store)
            store="JAJAJAJAJA"
            storelocaion="$2"
            shift 2
            ;;
        -m | -M | --multithreading)
            multithreading="JAJAJAJAJA"
            shift
            ;;
        -o | -O | --optimized)
            optimized="JAJAJAJAJA"
            shift
            ;;
        -h | -H | --help)
            echo "copyrekt die deutsche Orthopädiespezialist 2020"
            echo "channel archive bot for discord, but improved"
            echo "archive a discord channel before it's deleted by its arsehole mods"
            echo
            echo "Usage: "
            echo "./archivechannels.v5.sh [options] channel_id auth [config_path] [picarchive_channel_id] [webhookurl] [nitro] filename"
            echo
            echo "Options: "
            echo "  -c or -C or --continue <filename>: read message id from the last line of an existing archive file, and continue dumpin' from there"
            echo "  -i or -I or --incremental <filename>: read message id from the first line of an existing archive file, and dump from the latest message to there"
            echo "    in both cases newer dumps would be stored in a new file, you can use any file merge commands to merge them"
            echo "  -a or -A or --antics <rarfilename>: compress and upload dumped message file right into source channel to furtherly humiliate its arsehole mod of its failure against fegelein's antics:wiebitte:"
            echo "  -e or -E or --estimation: use discord search feature to estimate how many posts source channel have"
            echo "  -m or -M or --multithreading: dump messages first, reupload and replace later:wiebitte:"
            echo "    in this case config file path instead of other parameters shall be provided"
            echo "    config file format: "
            echo "      -W|webhook url|username|avatarurl (latter two are optional)"
            echo "      -N|nitro account auth|<chatroom id/channel id>"
            echo "    -o or -O or --optimized: another way of multithreading scheduler, to make sure sed replacement won't take too long time on larger message dumps"
            echo "  -u or -U or --reupload: reupload attachments in source channel into another channel given"
            echo "    -s or -S or --store <location>: downloaded attachments would be renamed and stored into local folder instead of bein' deleted"
            echo
            echo "channel id should be <chatroom id/channel id> format"
            echo "picarchive_channel_id is the channel to reupload pics from source channel"
            echo "by default it shall use a webhook to upload smol pics, but big pics shall be uploaded by a nitro account"
            exit
            shift
            ;;
        --)
            if [ "$antics" ]
            then
                rchannelid="$2"
                rauth="$3"
                rpurechannelid=`echo "$rchannelid" | cut -d/ -f2`
                filename="$4"
                rm "$tmpdir"/* -f
                rar a -v8M -htb -m5 -ma5 -rr5 -ol -ts "$tmpdir/$rarfilename.rar" "${filename%.*}"*
                for file in `ls $tmpdir`
                do
                    curl "https://discordapp.com/api/v6/channels/$rpurechannelid/messages" -H "User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:61.0) Gecko/20100101 Firefox/61.0" -H "Accept: */*" -H "Accept-Language: en-US" --compressed -H "Referer: https://discordapp.com/channels/$rchannelid" -H "Authorization: $rauth" -H "Content-Type: multipart/form-data; boundary=---------------------------32345443330436" -H "Cookie: __cfduid=d7be2f6bf6a3c09f82cd952f554ea2cb31531625199" -H "DNT: 1" -H "Connection: keep-alive" -F "payload_json={\"content\":\"`gretajoke`\",\"tts\":false}" -F "filename=@$tmpdir/$file"
                done
                rm "$tmpdir"/* -f
                exit
            else
                if [ "$reupload" ]
                then
                    rchannelid="$2"
                    rauth="$3"
                    rpurechannelid=`echo "$rchannelid" | cut -d/ -f2`
                    nitrochannelid="$4"
                    nitropurechannelid=`echo "$nitrochannelid" | cut -d/ -f2`
                    swebhookurl="$5"
                    nitroauth="$6"
                    if [ "$7" ]
                    then
                        filename="$7"
                    else
                        temp=`echo "$rchannelid" | sed 's/\//./g'`
                        time=`date +%y.%m.%d`
                        filename="$temp.$time.json"
                    fi
                    break
                elif [ "$multithreading" ]
                then
                    rchannelid="$2"
                    rauth="$3"
                    rpurechannelid=`echo "$rchannelid" | cut -d/ -f2`
                    configfilepath="$4"
                    if [ "$5" ]
                    then
                        filename="$5"
                    else
                        temp=`echo "$rchannelid" | sed 's/\//./g'`
                        time=`date +%y.%m.%d`
                        filename="$temp.$time.json"
                    fi
                    break
                else
                    rchannelid="$2"
                    rauth="$3"
                    rpurechannelid=`echo "$rchannelid" | cut -d/ -f2`
                    if [ "$4" ]
                    then
                        filename="$4"
                    else
                        temp=`echo "$rchannelid" | sed 's/\//./g'`
                        time=`date +%y.%m.%d`
                        filename="$temp.$time.json"
                    fi
                    break
                fi
            fi
            ;;
        *)
            echo "Internal error!"
            exit 255
            ;;
    esac
done

if [ "$messageid" ] && [ "$lastmessageid" ]
then
    echo "Houston, we have an arsefockin' problem: continue mode and incremental mode can't be used together:bruhsette:" >&2
    exit 2
fi

if [ ! "$lastmessageid" ]
then
    lastmessageid=0
fi

if [ ! "$reupload" ] && [ "$store" ]
then
    echo "Houston, we have an arsefockin' problem: no file to store if they're not donwloaded first:bruhsette:" >&2
    exit 3
fi

if [ "$estimation" ]
then
    rguildid=`echo "$rchannelid" | cut -d/ -f1`
    totalresults=`curl "https://discordapp.com/api/v6/guilds/$rguildid/messages/search?channel_id=$rpurechannelid&include_nsfw=true" -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:74.0) Gecko/20100101 Firefox/74.0' -H 'Accept: */*' -H 'Accept-Language: en-US' --compressed -H "Authorization: $rauth" -H 'Connection: keep-alive' -H "Referer: https://discordapp.com/channels/$rchannelid" -H 'Cookie: __cfduid=d440293169c3730ee2beff170518c1cb31565407611; locale=en-US; __cfruid=cd69440a7f7f42175065bc6d8aaeaf9e61ec8171-1585334844' -H 'TE: Trailers' | grep -Eo '"total_results": [0-9]*,' | grep -Eo "[0-9]*"`
fi

mkdir "$tmpdir"

echo ">>>> time for stage 1: " >> "$currentdir/${filename%.*}.timestat.temp"

( time stage1 ) 2>> "$currentdir/${filename%.*}.timestat.temp"
# /usr/bin/time -a -o "$currentdir/${filename%.*}.timestat.temp" stage1 # i'm gonna not run this script in cygwin anyway, so use GNU time instead

# [ "$multithreading" ] && /usr/bin/time -a -o "$currentdir/${filename%.*}.timestat.temp" stage2
[ "$multithreading" ] && ( time stage2 ) 2>> "$currentdir/${filename%.*}.timestat.temp"

cat "$currentdir/${filename%.*}.timestat.temp" | grep -E "(time for|real|user|sys)" > "$currentdir/${filename%.*}.timestat"

rm "$currentdir/${filename%.*}.timestat.temp" -f

IFS=$OLD_IFS
