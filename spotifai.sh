#!/bin/bash
# Spotifai v0.6
# Author: @0xFEDERICO
# Source code: https://github.com/0xFEDERICO/Spotifai

#print usage
function usage() {
    printf "\e[1;34mUsage: spotifai -p PLAYLIST-ID [-s SONGS-FOLDER-PATH || -d DATABASE-FOLDER-PATH || -h]\e[0m\n"
    printf "\e[1;34m  -p | --playlist         =>  Youtube playlist id\e[0m\n";
    printf "\e[1;34m  -s | --songs-path       =>  Folder path where you want to store the songs\e[0m\n";
    printf "\e[1;34m  -h | --help             =>  This message\e[0m\n";
}

#parse input args
function parseArgs() {
    while [ "$1" != "" ]; do
        case "$1" in
            -p | --playlist )       PLAYLIST="$2";shift ;;
            -s | --songs-path )     SONGSFOLDER="$2";shift ;;
            -h | --help )           usage;exit ;;
            * )
                printf "\e[31mE: unknown parameter %s\e[0m\n" "$PARAM";
                usage;
                exit 1;
                ;;
        esac
        shift #shift all arguments by 1 position
    done

    #validate required args
    if [[ -z "$PLAYLIST" ]]; then
        printf "\e[31mE: missing playlist id.\e[0m\n";
        usage;
        exit 1;
    fi

    #set default songs folder
    if [[ -z "$SONGSFOLDER" ]]; then
        SONGSFOLDER=$(pwd);
        printf "\e[1;34mI: by default songs folder is: %s\e[0m\n" "$SONGSFOLDER"
    fi
}

#print some characters to make this project look serious
function banner() {
    printf "\e[37m  __   __   __  ___    __  __    \e[0m\n"
    printf "\e[37m |__  |__| |  |  |  | |_  |__| | \e[0m\n"
    printf "\e[37m  __| |    |__|  |  | |   |  | | \e[0m\n"
    printf "\n"
}

#check dependencies
function deps() {
    command -v youtube-dl > /dev/null 2>&1 || {
        printf "\e[31mE: youtube-dl is not installed\e[0m\n";
        printf "\e[31mE: please install it using python pip.\e[0m\n";
        exit 1;
    }
    command -v ffmpeg > /dev/null 2>&1 || {
        printf "\e[31mE: ffmpeg is not installed\e[0m\n";
        printf "\e[31mE: please install it using apt.\e[0m\n";
        exit 1;
    }
    command -v convert > /dev/null 2>&1 || {
        printf "\e[31mE: imagemagick 6 is not installed\e[0m\n";
        printf "\e[31mE: please install it using apt.\e[0m\n";
	      printf "\e[31mE: if you want to install version 7 substitute convert with magick in the whole script\e[0m\n";
        exit 1;
    }
    command -v eyeD3 > /dev/null 2>&1 || {
        printf "\e[31mE: eyeD3 is not installed\e[0m\n";
        printf "\e[31mE: please install it using python pip.\e[0m\n";
        exit 1;
    }
    command -v jq > /dev/null 2>&1 || {
        printf "\e[31mE: jq is not installed\e[0m\n";
        printf "\e[31mE: please install it using apt.\e[0m\n";
        exit 1;
    }
}

#music downloader
function downloadMusic() {
    cd "$SONGSFOLDER" || { printf "\e[31mE: songs folder not found.\e[0m\n"; exit 1; }
    printf "\e[1;34mI: start downloading all the songs\e[0m\n"
    youtube-dl -i --extract-audio --audio-format mp3 --add-metadata --write-thumbnail --restrict-filename \
    --download-archive database.txt "https://www.youtube.com/playlist?list=$PLAYLIST"
    printf "\e[1;34mI: download process ended\e[0m\n"
    printf "\e[1;34mI: start files cleanup\e[0m\n"
    count=$(ls -1 *.jpg *.webp 2>/dev/null | wc -l)
    if [ "$count" != 0 ]; then 
        for filename in *.mp3; do
            if [ -f "${filename%.*}.webp" ]; then
                convert "${filename%.*}.webp" "${filename%.*}.jpg" #use magik with imagemagick 7
            fi
	    if [ -f "${filename%.*}.jpg" ]; then
                eyeD3 --add-image "${filename%.*}.jpg:FRONT_COVER" "$filename"
            fi
        done
        rm -f *.jpg *.webp #it doesn't work with double quote
    fi 
    printf "\e[1;34mI: the cleanup process is done, some statistics:\e[0m\n"
    find . -type f | sed 's/.*\.//' | sort | uniq -c #https://unix.stackexchange.com/a/18508
    printf "\e[1;34mI: if there are files with extension other than (mp3, txt, sh) please open an issue\e[0m\n"
}


#check difference and remove local songs
function syncToRemote() {
    cd "$SONGSFOLDER" || { printf "\e[31mE: songs folder not found.\e[0m\n"; exit 1; }
    printf "\e[1;34mI: sync playlist to remote\e[0m\n";
    for (( i=0; i<10; ++i)); do #max 10 times
       if ping -q -c 1 -W 1 youtube.com >/dev/null; then
          JSON_DATA=$(youtube-dl -j --flat-playlist "$PLAYLIST")
          echo "$JSON_DATA" | jq -r '.id' > "updated"
	  if [ ! -s "updated" ]; then
             for a in *.mp3; do
                id=$(basename "${a##*-}" .mp3)
                if ! grep -q "$id" "updated"; then
	           printf "\e[1;34mI: you removed %s from your Youtube playlist, I also remove it from downloaded songs.\e[0m\n" "$i";
                   rm "$a"
                   sed -i "/$id/d" "database.txt"
                fi
             done
	  fi
	  rm "updated"
          break
       else
          printf "\e[1;31mE: you need an internet connection to see if you have removed any songs from the playlist.\e[0m\n";
          printf "\e[1;34mI: sleeping for 10 seconds...\e[0m\n";
          sleep 10
       fi
    done
}

parseArgs "$@"
banner
deps
downloadMusic
syncToRemote
printf "\e[1;34mI: enjoy Spotifai ❤\e[0m\n"
exit 0
