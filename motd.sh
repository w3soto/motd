#!/bin/bash

###############################################################################
# Message of the day
# Author: Soto (soto.ms@gmail.com)
###############################################################################

DIR=`dirname "$0"`
OUTPUT="console"
INDEX=
SOURCE_FILE="motd.txt"
QUOTE=""
AUTHOR=""

###############################################################################
# FUNCTIONS
###############################################################################
function help() {
cat <<EOF

    Usage:
        modt.sh [OPTION...]

    Options:
        -o, --output=OUTPUT         Specifies the output. Available values are "console" (default) or "notify".
        -i, --index=INDEX           Specifies the index line of source file. If not set, random line will be used.
        -s, --source=SOURCE_FILE    Specifies the source file. By default "motd.txt".
        -h, --help                  Show options

EOF
}

function notify_print() {
	next_motd
	$DIR/notify-send.sh --icon=$HOME/.face --urgency=critical "Welcome $USER" "\n$QUOTE\n\n$AUTHOR\n" -o "Next:$DIR/motd.sh -o notify"
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
        line=$(sed "${INDEX}q;d" $DIR/$SOURCE_FILE)
    else
        line=$(shuf -n 1 $DIR/$SOURCE_FILE)
    fi
    QUOTE=$(echo $line | sed -r 's/(\-\-.+)//g')
    AUTHOR=$(echo $line | sed -r 's/(".+" )//g')
}


###############################################################################
# PROCESS ARGUMENTS
###############################################################################
while (( $# > 0 )) ; do
    case "$1" in
        -h|--help)
            help
            exit 0
            ;;
        -v|--version)
            echo "${0##*/} $VERSION"
            exit 0
            ;;
        -o|--output|--output=*)
            [[ "$1" = --output=* ]] && output="${1#*=}" || { shift; output="$1"; }
            OUTPUT="$output"
            ;;
        -i|--index|--index=*)
            [[ "$1" = --index=* ]] && index="${1#*=}" || { shift; index="$1"; }
            INDEX="$index"
            ;;
        -s|--source|--source=*)
            [[ "$1" = --source=* ]] && source="${1#*=}" || { shift; source="$1"; }
            SOURCE_FILE="$source"
            ;;
    esac
    shift
done;

###############################################################################
# RUN
###############################################################################
if [[ $OUTPUT == "notify" ]]; then
    notify_print
else
	console_print
fi

exit 0	
