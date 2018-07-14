# copyrekt die deutsche Orthopädiespezialist 2018
# paheal.net rule34 fully automatic masspostin' bot
# you can either use a webhook or your own account or alt account if you don't have perms to create webhooks
# here we fockin' go

######################################################################################################################################################################
# need to be changed
webhookinterval=3
naturalinterval=2
# hentai update interval

function nanako(){ # use webhooks
    magic="<paste your webhook url here>"
    curl -d "content=$1&username=$cutie Hentai Bot&avatar_url=$avatarurl" "$magic"
}

function nanako2(){ # use your own accounts
    # <log in your discord account usin' firefox, use F12 to open developer mode, use "network" tab to monitor network activities, send a message in your desired channel, find the "messages" request and use "Copy" -> "Copy as cURL" to get the cURL command and replace your message with a $1 and replace all '""' with '\"', then you're good to go! >
    # it will look like the cURL command below, but pls do yourself a fockin' favor and change it to yours
    curl "https://discordapp.com/api/v6/channels/XXXXXXXXXXXXXXXXX/messages" -H "XXXXXXXXXXXXXXXXX" -H "Accept: */*" -H "Accept-Language: en-US" --compressed -H "Referer: https://discordapp.com/channels/XXXXXXXXXXXXXXXXX" -H "Content-Type: application/json" -H "Authorization: XXXXXXXXXXXXXXXXX" -H "X-Super-Properties: XXXXXXXXXXXXXXXXX" -H "Cookie:XXXXXXXXXXXXXXXXX" -H "DNT: X" -H "Connection: keep-alive" --data "{\"content\":\"$1\",\"nonce\":\"XXXXXXXXXXXXXXXXX\",\"tts\":false}"
}
######################################################################################################################################################################


######################################################################################################################################################################
# DO NOT CHANGE UNLESS NECESSARY

parameters=`getopt -o WNA:hH -a -l webhook,natural-mode,avatar-url:,help -- "$@"`

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
        -W | --webhook)
			mode=0
            shift
            ;;  
        -N | --natural-mode)
			mode=1
            shift
            ;;  
		-A | --avatar-url)
			avatarurl=$2
            shift 2
            ;;  
		-h | -H | --help)
            echo "copyrekt die deutsche Orthopädiespezialist 2018"
            echo "paheal.net rule34 fully automatic masspostin' bot"
            echo "you can either use a webhook or your own account or alt account if you don't have perms to create webhooks"
            echo
            echo "usage: "
            echo "paheal.sh [options] cutie"
            echo
            echo "Options: "
            echo "    -W or --webhook: use discord webhook to upload hentai, need to paste webhook url into nanako() function"
            echo "        and when you use this mode, you must use -A or --avatar-url to set your avatar, you need to make one yourself and upload to discord and get the link via \"Copy Link\""
            echo "    -N or --natural-mode: use your own account to upload hentai, need to follow the instrucions in nanako2() function"
            echo "    -H or -h or --help: this shit"
            echo
            echo "Cutie: "
            echo "    pls input an ACTUALLY EXISTED name, you can look up by addin' \"site:paheal.net\" on Google to make sure it exists. And pls include \"_\""
			exit
            shift
            ;;  		
        --)
            cutie=$2
            shift  
            break  
            ;;  
        *)   
            echo "Internal error!"  
            exit 1  
            ;;  
        esac  
done

if [ $mode == 0 ] && [ ! $avatarurl ]
then
    echo "Houston, we have an arsefockin' problem: Avatar url required when usin' Webhook mode" >&2  
    exit 3
fi

url="https://rule34.paheal.net/post/list/$cutie/"
totalfish=`curl "$url" | grep -Eo "Next.*Last" | grep -Eo "[0-9]*"`
#totalfish=2 # in some cases you just can't use script to find out pages, you'll have to make it manually
cutie=`echo $cutie | sed 's/_/ /g'`

message="paheal.net rule34 fully automatic masspostin' bot developed by **die deutsche Orthopädiespezialist**"
case "$mode" in
    0)
        nanako "$message"
        ;;
    1)
        nanako2 "$message"
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
message="FYI, the cutie's name is **$cutie**, and this hentai has **$totalfish** page(s), and the hentai update interval is set to **$nein** second(s), so enjoy your fockin' hentai <:funny_v1:449451139063218177><:funny_v1:449451139063218177><:funny_v1:449451139063218177><:funny_v1:449451139063218177><:funny_v1:449451139063218177>"
case "$mode" in
    0)
        nanako "$message"
        ;;
    1)
        nanako2 "$message"
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
                nanako2 "${hentai//%20/ }"
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
        nanako2 "$message"
        ;;
esac
