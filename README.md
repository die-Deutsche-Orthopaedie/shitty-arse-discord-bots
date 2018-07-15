# Shitty Arse Discord Bots
Shitty Arse Discord Bots usin' bash, yep, **B A S H**

Other bots will not be updated anyway, all of them are in futaba.sh

Usage: 

futaba.sh [options] cutie cutie_name

Options: 
> *     -s or -S or --site: input site name, currently supported: paheal, gelbooru
> * *        use localmachine to post or upload pics in local file (like bein' generated in link-only mode) to discord, in this case **$cutie** will be your filename
> *     -w or -W or --webhook: use discord webhook to upload hentai, need to paste webhook url into nanako() function
> * *        and when you use this mode, you must use **-a or -A or --avatar-url** to set your avatar, you need to make one yourself and upload to discord and get the link via "Copy Link"
> *     -n or -N or --natural-mode: use your own account to upload hentai, need to follow the instructions in futaba() function
> *     -m or -M or --message: send a message usin' either methods, in this mode the cutie name will become your bot's name (if you use webhook)
> *     -c or -C or --config-file: load a configuration file which contains three lines of webhook url, account curl command and account curl command (used to upload); if you don't load one it will use default values in the script
> *     -d or -D or --download: download pics and upload to discord instead of just postin' links
> *     -l or -L or --link-only: only export hentai pics links to file
> *     --silent: omit all of messages except pics, may be useful in some cases
> *     -h or -H or --help: show help

Cutie: 
> * pls input an **ACTUALLY EXISTED** name or tag, you can look up by addin' "**site:\<your site\>**" on Google to make sure it exists. And pls include "_" if it has one
> * * eg. **futaba**'s page on gelbooru.com is https://gelbooru.com/index.php?page=post&s=list&tags=sakura_futaba and what you need to input is "**sakura_futaba**"
> * * the display name for your cutie (**$cutie_name**) can be different from the search name or tag (**$cutie**), but if you don't input one it will be automatically generated from the tag

And you'll need to provide webhook url (webhook mode) or curl command for account ("natural" mode) to make this script work. It's not too hard to provide webhook url, but it needs extra efforts to form two curl commands for this script to use. 

You'll need to follow these steps to form curl commands: 

1. Login your discord account in firefox
2. go to your desired channel
3. press F12 to open developer menu, and click "Network" or "Networking" tab
4. Enter some messages, you will see a request called "typing" in the network tab below
5. Send the message, and right click the new "messages" request and select "copy" -> "copy as cURL"
6. process the curl command copied: it should be like `curl "https://discordapp.com/api/v6/channels/XXXXXXXX/messages" -H "User-Agent: XXXXXXXX" -H "Accept: */*" -H "Accept-Language: en-US" --compressed -H "Referer: https://discordapp.com/channels/XXXXXXXX" -H "Content-Type: application/json" -H "Authorization: XXXXXXXX" -H "X-Super-Properties: XXXXXXXX" -H "Cookie: XXXXXXXX" -H "DNT: 1" -H "Connection: keep-alive" --data "{""content"":""fish"",""nonce"":""XXXXXXXX"",""tts"":false}"`
replace your content with "$1" and replace '""' with '\"', then it's good to go to be in the script or in the configuration file
7. use the same method to upload a file and copy the curl command, this time it should be like `curl "https://discordapp.com/api/v6/channels/XXXXXXXX/messages" -H "User-Agent: XXXXXXXX" -H "Accept: */*" -H "Accept-Language: en-US" --compressed -H "Referer: https://discordapp.com/channels/XXXXXXXX" -H "Authorization: XXXXXXXX" -H "X-Super-Properties: XXXXXXXX" -H "Content-Type: multipart/form-data; boundary=XXXXXXXX" -H "Cookie: XXXXXXXX" -H "DNT: 1" -H "Connection: keep-alive" --data ""`, and you don't see any file or any messages, but don't worry, just replace `--data ""` with `-F "payload_json={\"content\":\"$1\",\"nonce\":\"XXXXXXXX\",\"tts\":false}" -F "filename=@$2"`, and you can use nonce data on the last command, and the curl command **for upload** is finished as well
8. form a three line file, first line is webhook url, second line is curl command and third line is curl command **for upload**, save these into a text file, and next time you can load them with -c option, and you're good to go! 
