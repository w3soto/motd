#!/bin/bash

###############################################################################
# Message of the day
# Usage: modt.sh [console|notify] [index]
# Author: Soto
###############################################################################

DIR=`dirname "$0"`
MODE="$1"
INDEX="$2"

QUOTE=""
AUTHOR=""

function notify_print() {
	next_motd
	$DIR/notify-send.sh --icon=$HOME/.face --urgency=critical --expire-time=10000 "Welcome $USER" "\n$QUOTE\n\n$AUTHOR\n" -o "Next:$DIR/motd.sh notify"
}

function console_print() {
	next_motd
	echo -e "\n   Welcome $USER\n"
    echo -e "   $QUOTE"
    echo -e "   $AUTHOR\n"
}

function next_motd() {
	# local version
    if [[ $INDEX != "" ]]; then
        line=$(sed "${INDEX}q;d" $DIR/motd.txt)
    else
        line=$(shuf -n 1 $DIR/motd.txt)
    fi
    QUOTE=$(echo $line | sed -r 's/(\-\-.+)//g')
    AUTHOR=$(echo $line | sed -r 's/(".+" )//g')
}

if [ $MODE == "notify" ]; then
    notify_print
else
	console_print
fi


