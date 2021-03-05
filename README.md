# Spotifai
 listen to music as it was done in the 2000s
 
# Get PLAYLIST-ID
 https://www.youtube.com/playlist?list=XXXXXXXXXXXXXXXX  <---- id is here

# Install pip3 and git
 ``sudo apt install python3-pip git``

# Install Spotifai
```
pip3 install youtube-dl eyeD3
sudo apt install ffmpeg imagemagick jq
git clone https://github.com/0xFEDERICO/Spotifai.git
cd Spotifai
chmod +x spotifai.sh
./spotifai.sh [...]
```

# Usage
``./spotifai.sh -p PLAYLIST-ID || -a ARCHIVE-FILE [-s SONGS-FOLDER-PATH || -h]``</br>
``  -a | --archive          =>  Run Spotifai in local mode``</br>
``  -p | --playlist         =>  Youtube playlist id or archive file``</br>
``  -s | --songs-path       =>  Folder path where you want to store the songs``</br>
``  -h | --help             =>  This message``</br>
    
# Termux + Tasker
 Go to play store and install Termux + Termux:Tasker + Tasker and run the previous installation commands.<br/>
 Follow this guide https://wiki.termux.com/wiki/Termux:Tasker and create a one line script like that:<br/>
 ``bash /path/to/spotifai.sh -p ... -s ...``.
 In this way you can run the script automatically one or more times a day and keep the playlist synchronized!!!

 </br></br>
![](https://img.shields.io/github/issues/0xfederico/Spotifai)
![](https://img.shields.io/github/forks/0xfederico/Spotifai)
![](https://img.shields.io/github/stars/0xfederico/Spotifai)
![](https://img.shields.io/github/license/0xfederico/Spotifai)
![](https://img.shields.io/github/languages/count/0xfederico/Spotifai)
![](https://img.shields.io/github/languages/top/0xfederico/Spotifai)
![](https://img.shields.io/github/repo-size/0xfederico/Spotifai)
</br>
![](https://img.shields.io/github/downloads/0xfederico/Spotifai/latest/total)
![](https://img.shields.io/github/v/release/0xfederico/Spotifai)
![](https://img.shields.io/github/last-commit/0xfederico/Spotifai)
![](https://img.shields.io/github/commit-activity/y/0xfederico/Spotifai)