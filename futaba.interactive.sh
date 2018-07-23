#!/bin/bash
# copyrekt die deutsche Orthopädiespezialist 2018
# interactive assistant for multi-site rule34 fully automatic masspostin' bot for discord
# here we fockin' go

parameters="bash futaba.sh"

whiptail --title "futaba.sh Interactive Helper" --msgbox "Welcumm to this shitty arse helper, pls provide necessary infomation to generate futaba.sh command. Choose Ok to continue." 10 60

# Webhook or Natural
if (whiptail --title "Question 0" --yes-button "Webhook mode" --no-button "Natural Mode"  --yesno "Webhook Mode or Natural Mode? " 10 60) then
    parameters="$parameters -W"
    mode=0
else
    parameters="$parameters -N"
    mode=1
fi

# Webhook mode
if [ $mode = 0 ]
then
    avatarurl=$(whiptail --title "Question 0.1" --inputbox "You need to provide your webhook's avatar url: " 10 60 3>&1 1>&2 2>&3)
    if [ $? = 0 ]
    then
        parameters="$parameters -A '$avatarurl'"
    fi
    avatarname=$(whiptail --title "Question 0.2" --inputbox "(Optional) provide your webhook's avatar nickname: " 10 60 3>&1 1>&2 2>&3)
    if [ $? != 0 ]
    then
        unset $avatarname
    fi
    if (whiptail --title "Question 0.3" --yes-button "JAJAJAJAJA" --no-button "nein"  --yesno "Do you wanna use your webhook url RIGHT HERE? " 10 60) then
        fastwebhook=$(whiptail --title "Question 0.4" --inputbox "You need to provide your webhook's url: " 10 60 3>&1 1>&2 2>&3)
        if [ $? = 0 ]
        then
            parameters="$parameters --fast-webhook '$fastwebhook'"
        fi
    fi
fi

# special modes (message, upload)
if (whiptail --title "Question 1" --yes-button "JAJAJAJAJA" --no-button "nein"  --yesno "Do you wanna use some special modes? " 10 60) then
    specialmode=$(whiptail --title "Question 1.1" --radiolist \
    "Which special mode do you wanna use? " 15 60 4 \
    "message" "message mode" ON \
    "upload" "upload mode" OFF \
    "england" "spam England is my City" OFF \
    "pingasland" "spam PINGASland is my PINGAS" OFF 3>&1 1>&2 2>&3)
    if [ $? != 0 ]; then
        whiptail --title "Houston" --msgbox "Houston, we have an arsefockin' problem: WE NEED A MODE" 10 60
        exit
    fi
    if [ "$specialmode" = "message" ]
    then
        message=$(whiptail --title "Question 1.2" --inputbox "Input message: " 10 60 3>&1 1>&2 2>&3)
        if [ $? = 0 ]
        then
            parameters="$parameters -m '$message'"
        else
            whiptail --title "Houston" --msgbox "Houston, we have an arsefockin' problem: WE NEED A MESSAGE" 10 60
            exit
        fi
    fi
    if [ "$specialmode" = "upload" ]
    then
        message=$(whiptail --title "Question 1.2" --inputbox "Input message: " 10 60 3>&1 1>&2 2>&3)
        if [ $? = 0 ]
        then
            parameters="$parameters -u '$message'"
        else
            whiptail --title "Houston" --msgbox "Houston, we have an arsefockin' problem: WE NEED A MESSAGE" 10 60
            exit
        fi
        filename=$(whiptail --title "Question 1.3" --inputbox "Input file name: " 10 60 3>&1 1>&2 2>&3)
        if [ $? = 0 ]
        then
            parameters="$parameters '$filename'"
        else
            whiptail --title "Houston" --msgbox "Houston, we have an arsefockin' problem: WE NEED A FILENAME" 10 60
            exit
        fi
    fi
    if [ "$specialmode" = "england" ]
    then
        parameters="$parameters --england-is-my-city"
    fi
    if [ "$specialmode" = "message" ]
    then
        parameters="$parameters --pingasland-is-my-pingas"
    fi
    
    echo "$parameters"
    exit
fi

# download? 
if (whiptail --title "Question 2" --yes-button "JAJAJAJAJA" --no-button "nein"  --yesno "Do you wanna download and reupload other than just post links? " 10 60) then
    downloadmode=1
    parameters="$parameters -D"
    if (whiptail --title "Question 2.1" --yes-button "JAJAJAJAJA" --no-button "nein"  --yesno "Do you wanna keep your downloaded pics other than just delete them? " 10 60) then
        parameters="$parameters --preserve-pics"
    fi
fi

# Site name
site=$(whiptail --title "Question 3" --radiolist \
"Select your desired hentai site: " 15 60 4 \
"paheal" "rule34.paheal.net" ON \
"gelbooru" "gelbooru.com" OFF \
"rule34xxx" "rule34.xxx" OFF \
"yandere" "yande.re" OFF \
"pixiv" "pixiv.net" OFF \
"pixiv_author" "pixiv.net but search a certain author" OFF \
"pixiv_favourite" "pixiv.net but search a certain user's favourite" OFF \
"localmachine " "process lines of links in local machine" OFF \
"localmachine_pixiv " "process lines of wget commands in local machine" OFF 3>&1 1>&2 2>&3)
if [ $? = 0 ]; then
    parameters="$parameters -S '$site'"
else
    whiptail --title "Houston" --msgbox "Houston, we have an arsefockin' problem: WE NEED A SITE" 10 60
    exit
fi

# Configuration file
if (whiptail --title "Question 4" --yes-button "JAJAJAJAJA" --no-button "nein"  --yesno "Do you wanna use your configuration file? " 10 60) then
    configfile=$(whiptail --title "Question 4.1" --inputbox "You need to provide your configuration file's location: " 10 60 3>&1 1>&2 2>&3)
    if [ $? = 0 ]
    then
        parameters="$parameters -c '$configfile'"
    fi
fi

# silent option
if (whiptail --title "Question 5" --yes-button "JAJAJAJAJA" --no-button "nein"  --yesno "Do you wanna silent your arse? " 10 60) then
    parameters="$parameters --silent"
fi

# new interval
if (whiptail --title "Question 6" --yes-button "JAJAJAJAJA" --no-button "nein"  --yesno "Do you wanna set new interval for each post? " 10 60) then
    webhookinterval=$(whiptail --title "Question 6.1" --inputbox "(Optional) provide your webhook mode's new interval: " 10 60 3>&1 1>&2 2>&3)
    if [ $? = 0 ]
    then
        parameters="$parameters --webhookinterval $webhookinterval"
    fi
    naturalinterval=$(whiptail --title "Question 6.2" --inputbox "(Optional) provide your natural mode's new interval: " 10 60 3>&1 1>&2 2>&3)
    if [ $? = 0 ]
    then
        parameters="$parameters --naturalinterval $naturalinterval"
    fi
fi

# pixiv related options
if [ "$site" = "pixiv" ] || [ "$site" = "pixiv_author" ] || [ "$site" = "pixiv_favourite" ]
then
    if [ ! $downloadmode ]
    then
        parameters="$parameters -D"
    fi
    # pixiv mode
    pixivmode=$(whiptail --title "Question 7" --radiolist \
    "Which pixiv mode are you gonna use? " 15 60 4 \
    "halfspeed mode" "(default)" ON \
    "fullscan mode" "gelbooru.com" OFF \
    "fast mode" "rule34.xxx" OFF 3>&1 1>&2 2>&3)
    if [ $? = 0 ]; then
        if [ "$pixivmode" = "fullscan mode" ]
        then
            parameters="$parameters --pixiv-fullscan-mode"
        fi
        if [ "$pixivmode" = "fast mode" ]
        then
            parameters="$parameters --pixiv-fast-mode"
        fi
    else
        whiptail --title "Houston" --msgbox "Houston, we have an arsefockin' problem: WE NEED A PIXIV MODE" 10 60
        exit
    fi
    
    # pixiv order
    if (whiptail --title "Question 7.1" --yes-button "JAJAJAJAJA" --no-button "nein"  --yesno "Do you wanna set your pixiv order? " 10 60) then
        if [ "$site" = "pixiv" ]
        then
            if (whiptail --title "Question 7.11" --yes-button "JAJAJAJAJA" --no-button "nein"  --yesno "Do you have a pixiv premium account? " 10 60) then
                pixivorder=$(whiptail --title "Question 7.2" --radiolist \
                "Which pixiv order are you gonna use? " 15 60 4 \
                "date_d" "default, from latest to oldest" ON \
                "date" "from oldest to latest" OFF \
                "popular_d" "order by popularity" OFF \
                "popular_male_d" "order by popularity amongst males" OFF \
                "popular_female_d" "order by popularity amongst females" OFF 3>&1 1>&2 2>&3)
                if [ $? = 0 ]; then
                    parameters="$parameters --pixiv-order '$pixivorder'"
                else
                    whiptail --title "Houston" --msgbox "Houston, we have an arsefockin' problem: WE NEED A PIXIV ORDER" 10 60
                    exit
                fi
            else
                pixivorder=$(whiptail --title "Question 7.2" --radiolist \
                "Which pixiv order are you gonna use? " 15 60 4 \
                "date_d" "default, from latest to oldest" ON \
                "date" "from oldest to latest" OFF 3>&1 1>&2 2>&3)
                if [ $? = 0 ]; then
                    parameters="$parameters --pixiv-order '$pixivorder'"
                else
                    whiptail --title "Houston" --msgbox "Houston, we have an arsefockin' problem: WE NEED A PIXIV ORDER" 10 60
                    exit
                fi
            fi
        fi
        if [ "$site" = "pixiv_favourite" ]
        then
            pixivorder=$(whiptail --title "Question 7.2" --radiolist \
            "Which pixiv order are you gonna use? " 15 60 4 \
            "desc" "default, from latest added to favourite to oldest" ON \
            "asc" "from oldest added to favourite to latest" OFF \
            "date_d " "from latest posted to oldest" OFF \
            "date" "from oldest posted to latest" OFF 3>&1 1>&2 2>&3)
            if [ $? = 0 ]; then
                parameters="$parameters --pixiv-order '$pixivorder'"
            else
                whiptail --title "Houston" --msgbox "Houston, we have an arsefockin' problem: WE NEED A PIXIV ORDER" 10 60
                exit
            fi
        fi
    fi
    
    # pixiv progress control
    if (whiptail --title "Question 7.3" --yes-button "JAJAJAJAJA" --no-button "nein"  --yesno "Do you wanna set custom progress for pixiv dumpin'? " 10 60) then
        startfrom=$(whiptail --title "Question 7.31" --inputbox "(Optional) provide which post you're gonna start from: " 10 60 3>&1 1>&2 2>&3)
        if [ $? = 0 ]
        then
            parameters="$parameters --start-from $startfrom"
        fi
        endwith=$(whiptail --title "Question 7.32" --inputbox "(Optional) provide which post you're gonna end with: " 10 60 3>&1 1>&2 2>&3)
        if [ $? = 0 ]
        then
            parameters="$parameters --end-with $endwith"
        fi
    fi
fi

# main input parameter
cutie=$(whiptail --title "Question NEIN" --inputbox "Input cutie name, search tag, author id, file name, or whatfockin'ever: " 10 60 3>&1 1>&2 2>&3)
if [ $? = 0 ]
then
    parameters="$parameters '$cutie'"
else
    whiptail --title "Houston" --msgbox "Houston, we have an arsefockin' problem: WE NEED A CUTIE" 10 60
    exit
fi

# avatar nickname
if [ $avatarname ]
then
    parameters="$parameters '$avatarname'"
fi

echo "$parameters"
