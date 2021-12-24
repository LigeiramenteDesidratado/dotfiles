#! /bin/sh

remaps&
dunst&
# mpd&
unclutter&
slstatus&
rs&
clipmenud&

echo '' > $HOME/.isdwmrunning
export YT_API_KEY=$(cat ~/.keys/yt-api-key)

while : ; do

    #with logs
    # dwm 2>&1 | sed -e "s/^/$(date '+[%Y-%m-%d] [%T]') /" >> ~/dwmlogs
    exec dwm > /dev/null
    [ -s "$HOME/.isdwmrunning" ] && break
    sleep 1
done
