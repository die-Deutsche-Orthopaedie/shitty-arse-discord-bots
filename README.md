# Shitty Arse Discord Bots
Shitty Arse Discord Bots usin' bash, and yep, arsefockin' **B A S H**

Other bots will not be updated any fockin' way, all of them are in **futaba.sh**

And one more thing, i've completed the **Holy Grail of Hentai**, **pixiv.net**, with arsefockin' **B A S H**! How the fock will i celebrate? 

Now i've added cross channel messagin' and chatroom join functionality, one step closer to discord: bash edition xD

Usage: 

`futaba.sh [options] cutie cutie_name`

Options: 
> * Modes: 
> * * `-w or -W or --webhook`: use discord webhook to upload hentai, need to paste webhook url into `nanako()` function
> * * * and when you use this mode, you must use `-a or -A or --avatar-url` to set your avatar, you need to make one yourself and upload to discord and get the link via **Copy Link**
> * * `-n or -N or --natural-mode`: use your own account to upload hentai, need to follow the instructions in `futaba()` function
> * * `-m or -M or --message <message>`: send a message usin' either methods, in this mode `$cutie_name` will become your bot's name (if you use webhook)
> * * `-u or -U or --upload <filepath> <message>`: upload a file usin' either methods, in this mode `$cutie_name` will become your bot's name (if you use webhook)
> * * * and i've found a strange bug out here, now it would be better if you put `-u or -U or --upload` as the last parameter and all will be fine
> * * `-d or -D or --download`: download pics and reupload to discord instead of just postin' links, required for pixiv
> * * `-l or -L or --link-only <exportfilepath>`: only export hentai pics links to file; for pixiv, it's the entire wget command, you can use bash or localmachine_pixiv to run them later
>
> * Configurations: 
> * * `-s or -S or --site <sitename>`: input site name, currently supported: **paheal**, **gelbooru**, **pixiv**
> * * * use **localmachine** to post or upload pics in local file (like bein' generated in link-only mode) to discord, in this case `$cutie` will be your filename
> * * * and **localmachine_pixiv** to download and reupload pics in local pixiv file generated in link-only mode to discord, in this case `$cutie` will be your filename
> * * `-c or -C or --config-file <configfilepath>`: load a configuration file which contains **three** lines of **webhook url**, **account curl command** and **account curl command (used to upload)**; if you don't load one it will use default values in the script; but i don't make pixiv shit to be in configuration file because you just don't need to change them by all means
> * * `--silent`: omit all of messages except pics (they'll be outputted in console anyway), may be useful in some cases
> * * `--webhookinterval <newinterval>`: override webhook mode hentei interval in the script
> * * `--naturalinterval <newinterval>`: override natural mode hentei interval in the script
> * * `--pixiv-fast-mode`: only use the list page info to dump pixiv pics, but will generate too much 404
> * * `--pixiv-halfspeed-mode`: use id page info to dump pixiv pics, but faster than full mode
> * * `--pixiv-log`: an extra procedure to use pixiv log just like normal local pic file, so you don't need to grep it yourself
> * * * and currently this thing will either kill the script or make it stop, just forget about it 
> * * * or you can just use `cat <logfile> | sed 's/,/\n/g' | grep -Eo '"url": "https://cdn.discordapp.com/.*"' | sed 's/"//g' | sed 's/url: //g' > <newfile>` to process beforehand, then use normal method
> * * `--channel-id <chatroom-id/channel-id>`: the ability to send message in any channel that you have access to (only with natural mode), need to provide both chatroom id and channel id
> * * * and i'm still not used to called discord chatroom "server", because what runs this script is the real server for me
> * * `--join-chatroom <chatroom-invite-link>`: the ability to join chatroom VIA CLI, you just need to provide the last few letters of the invite link, for https://discord.gg/FEGELEIN you only need "**FEGELEIN**"
>
> * Help: 
> * * `-h or -H or --help`: show help

Cutie: 
> * pls input an **ACTUALLY EXISTED** search term or tag, you can look up by addin' "**site:\<your site\>**" on Google to make sure it exists. And pls include "_" if it has one
> * * eg. **futaba**'s page on paheal.net is https://rule34.paheal.net/post/list/Futaba_Sakura and what you need to input is "**Futaba_Sakura**"
> * * eg. **futaba**'s page on gelbooru.com is https://gelbooru.com/index.php?page=post&s=list&tags=sakura_futaba and what you need to input is "**sakura_futaba**"
> * * eg. **futaba**'s page on pixiv.net is https://www.pixiv.net/search.php?word=佐倉双葉&order=date_d&mode=r18 and what you need to input is "**佐倉双葉**"
> * * * the display name for your cutie (`$cutie_name`) can be different from the search term or tag (`$cutie`), but if you don't input one it will be automatically generated from the tag

And you'll need to provide webhook url (webhook mode) or curl command for account ("natural" mode) to make this script work. It's not too hard to provide webhook url, but it needs extra efforts to form two curl commands for this script to use. 

You'll need to follow these steps to form curl commands: 

1. Login your discord account in firefox
2. go to your desired channel
3. press F12 to open developer menu, and click "Network" or "Networking" tab
4. Enter some messages, you will see a request called "typing" in the network tab below
5. Send the message, and right click the new "messages" request and select "copy" -> "copy as cURL"
6. process the curl command copied: it should be like `curl "https://discordapp.com/api/v6/channels/XXXXXXXX/messages" -H "User-Agent: XXXXXXXX" -H "Accept: */*" -H "Accept-Language: en-US" --compressed -H "Referer: https://discordapp.com/channels/XXXXXXXX" -H "Content-Type: application/json" -H "Authorization: XXXXXXXX" -H "X-Super-Properties: XXXXXXXX" -H "Cookie: XXXXXXXX" -H "DNT: 1" -H "Connection: keep-alive" --data "{""content"":""fish"",""nonce"":""XXXXXXXX"",""tts"":false}"`
replace your content with `"$1"` and replace `""` with `\"`, then it's good to go to be in the script or in the configuration file
7. use the same method to upload a file and copy the curl command, this time it should be like `curl "https://discordapp.com/api/v6/channels/XXXXXXXX/messages" -H "User-Agent: XXXXXXXX" -H "Accept: */*" -H "Accept-Language: en-US" --compressed -H "Referer: https://discordapp.com/channels/XXXXXXXX" -H "Authorization: XXXXXXXX" -H "X-Super-Properties: XXXXXXXX" -H "Content-Type: multipart/form-data; boundary=XXXXXXXX" -H "Cookie: XXXXXXXX" -H "DNT: 1" -H "Connection: keep-alive" --data ""`, and you can't see any file or message, but don't worry, just replace `--data ""` with `-F "payload_json={\"content\":\"$1\",\"nonce\":\"XXXXXXXX\",\"tts\":false}" -F "filename=@$2"`, and you can use nonce data on the last command, and the curl command **for upload** is finished as well
8. form a three line file, first line is webhook url (even if you don't wanna or can't use webhook, you'll at least need to provide somethin' to fill the line), second line is curl command and third line is curl command **for upload**, save these into a text file, and next time you can load them with `-c or -C or --config-file` option, and you're good to go! 

Similar steps will be required to get pixiv parts work, but it would be much simpler, just make sure you can see hentai pics in https://www.pixiv.net/search.php?word=佐倉双葉&order=date_d&mode=r18 (that requires you to be registrated, set things right and even in the correct geolocation, idk but it works for me), find the very first request in firefox network tab, and copy as curl; it would be like `curl "https://www.pixiv.net/search.php?word="%"E4"%"BD"%"90"%"E5"%"80"%"89"%"E5"%"8F"%"8C"%"E8"%"91"%"89&order=date_d&mode=r18" -H xxxxxxxx -H xxxxxxxx`, just delete the `curl "xxxxxxxx"` part and leave a bunch of `-H` only, and paste it into `$shitty_arse_pixiv_parameter`, and you're good to go! 
