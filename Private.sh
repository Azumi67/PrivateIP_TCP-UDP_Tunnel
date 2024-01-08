#!/bin/bash
#
# Private IP Tunnel Configuration Script
# Author: github.com/Azumi67
#
# This script is designed to simplify the installation and configuration of private ip and some of its tunnels.
#
# supported architectures: x86_64, amd64
# Supported operating systems: Ubuntu 20
#
# Usage:
#   - Run the script with root privileges.
#   - Follow the on-screen prompts to install, configure, or uninstall the tunnel.
#
#
# Disclaimer:
# This script comes with no warranties or guarantees. Use it at your own risk.
# root check
if [[ $EUID -ne 0 ]]; then
  echo -e "\e[93mThis script must be run as root. Please use sudo -i.\e[0m"
  exit 1
fi

# bar
function display_progress() {
  local total=$1
  local current=$2
  local width=40
  local percentage=$((current * 100 / total))
  local completed=$((width * current / total))
  local remaining=$((width - completed))

  printf '\r['
  printf '%*s' "$completed" | tr ' ' '='
  printf '>'
  printf '%*s' "$remaining" | tr ' ' ' '
  printf '] %d%%' "$percentage"
}

# baraye checkmark
function display_checkmark() {
  echo -e "\xE2\x9C\x94 $1"
}

# error msg
function display_error() {
  echo -e "\xE2\x9D\x8C Error: $1"
}

# notify
function display_notification() {
  echo -e "\xE2\x9C\xA8 $1"
}
# Azumi is in your area
function display_loading() {
  local frames=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")
  local delay=0.1
  local duration=3  # Duration in seconds

  local end_time=$((SECONDS + duration))

  while ((SECONDS < end_time)); do
    for frame in "${frames[@]}"; do
      printf "\r[frame] Loading...  "
      sleep "$delay"
      printf "\r[frame]             "
      sleep "$delay"
    done
  done

  echo -e "\r\xE2\x98\xBA Service activated successfully! ~"
}
#logo2
function display_logoo() {
    echo -e "\e[92m$logoo\e[0m"
}
#art2
logoo=$(cat << "EOF"

  _____       _     _      
 / ____|     (_)   | |     
| |  __ _   _ _  __| | ___ 
| | |_ | | | | |/ _` |/ _ \
| |__| | |_| | | (_| |  __/
 \_____|\__,_|_|\__,_|\___|
EOF
)
#logo
function display_logo() {
echo -e "\033[1;96m$logo\033[0m"
}
# art
logo=$(cat << "EOF"
\033[1;96m          
                 
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\033[1;93m⠀⠀⢀⣀⣀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\033[1;93m⠀⠀⡀⠤⠒⠊⠉⠀⠀⠀⠀⠈⠁⠢⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀\033[1;93m⠀⢀⠔⠉⠀⠀⠀⠀⢀⡠⠤⠐⠒⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\033[1;93m⠀⠀⣀⡠⠤⠤⠀⠀⠂⠐\033[1;96m⠀⠠⢤⠎⢑⡭⣽⣳⠶⣖⡶⣤⣖⣬⡽⡭⣥⣄\033[1;93m⠒⠒⠀⠐⠁⠑⢄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\033[1;93m⠀⢀⠴⠊⠁⠀⠀⠀⠀⡀⠀\033[1;96m⣠⣴⡶⣿⢏⡿⣝⡳⢧⡻⣟⡻⣞⠿⣾⡽⣳⣯⣳⣞⡻⣦⡀⠀⠀\033[1;93m⠀⠈⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\033[1;93m⢨⠀⠀⠀⢀⠤⠂⠁\033[1;96m⢠⣾⡟⣧⠿⣝⣮⣽⢺⣝⣳⡽⣎⢷⣫⡟⡵⡿⣵⢫⡷⣾⢷⣭⢻⣦⡄\033[1;93m⠤⡸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\033[1;93m⠘⡄⠀⠀⠓⠂⠀\033[1;96m⣴⣿⢷⡿⣝⣻⣏⡷⣾⣟⡼⣣⢟⣼⣣⢟⣯⢗⣻⣽⣏⡾⡽⣟⣧⠿⡼⣿⣦\033[1;93m⣃⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\033[1;93m⢀⠇⠀⠀⠀⠀\033[1;96m⣼⣿⢿⣼⡻⣼⡟⣼⣧⢿⣿⣸⡧⠿⠃⢿⣜⣻⢿⣤⣛⣿⢧⣻⢻⢿⡿⢧⣛⣿⣧⠀\033[1;93m⠛⠤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\033[1;93m⠀⢸⠁⠀⠀⠀⠀\033[1;96m⣼⣻⡿⣾⣳⡽⣾⣽⡷⣻⣞⢿⣫⠕⣫⣫⣸⢮⣝⡇⠱⣏⣾⣻⡽⣻⣮⣿⣻⡜⣞⡿⣷\033[1;93m⢀⠀⠀⠑⠢⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\033[1;93m⠘⣧⠀⠀⠀\033[1;96m⣼⣳⢯⣿⣗⣿⣏⣿⠆⣟⣿⣵⢛⣵⡿⣿⣏⣟⡾⣜⣻⠀⢻⡖⣷⢳⣏⡶⣻⡧⣟⡼⣻⡽⣇\033[1;93m⠁⠢⡀⠠⡀⠑⡄⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\033[1;93m⠀⠈⢦⠀\033[1;96m⣰⣯⣟⢯⣿⢾⣹⢾⡟⠰⣏⡾⣾⣟⡷⣿⣻⣽⣷⡶⣟⠿⡆⠀⢻⣝⣯⢷⣹⢧⣿⢧⡻⣽⣳⢽⡀\033[1;93m⠀⠈⠀⠈⠂⡼⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\033[1;93m⠀⠀⡀⢵\033[1;96m⣟⣾⡟⣾⣿⣻⢽⣺⠇⠀⣿⡱⢿⡞⣵⡳⣭⣿⡜⣿⣭⣻⣷⠲⠤⢿⣾⢯⢯⣛⢿⣳⡝⣾⣿⢭⡇⠀\033[1;93m⠀⠀⠀⡰⠁⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\033[1;93m⢀⠤⠊⠀\033[1;96m⣼⢻⣿⢞⣯⢿⡽⣸⣹⡆⠀⢷⣏⢯⣿⣧⣛⠶⣯⢿⣽⣷⣧⣛⣦⠀⠀⠙⢿⣳⣽⣿⣣⢟⡶⣿⣫⡇⠀⠀\033[1;93m⠀⠰⠁⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀\033[1;93m⣠⠖⠁⠀⠀⡄\033[1;96m⡿⣯⣷⣻⡽⣞⡟⣿⣿⣟⠉⠈⢯⣗⣻⣕⢯⣛⡞⣯⢮⣷⣭⡚⠓⠋⠀⠀⠀⠈⠉⣿⡽⣎⠷⡏⡷⣷⠀⠀⠀\033[1;93m⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀\033[1;93m⠐⣇⠀⠀⢀⠊\033[1;96m⣼⣇⣿⡗⣿⣽⣷⡿⣿⣱⡿⣆⠀⠀⠙⠒⠛⠓⠋⠉⠉⠀⠀⠀\033[1;91m⢠⣴⣯⣶⣶⣤⡀\033[1;96m ⠀⣿⣟⡼⣛⡇⣟⣿⡆\033[1;93m⡀⠀⢀⠇⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀\033[1;93m⠀⠘⢤⠀⠃⠌\033[1;96m⣸⣿⢾⡽⣹⣾⠹⣞⡵⣳⣽⡽⣖⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\033[1;91m⣤⣖⣻⣾⣝⢿⡄\033[1;96m ⢸⣯⢳⣏⡿⣏⣾⢧\033[1;93m⠈⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀\033[1;93m⠀⠘⠀⠈⠀\033[1;96m⡿⣿⣻⡽⣽⣿⢧⠌⠉\033[1;91m⠉⣴⣿⣿⣫⣅⡀⠀⠀⠀⠀⠀⠀⠀⠀⣸⣛⠿⠿⢟⢙⡄⠙\033[1;96m ⠘⣯⢳⣞⡟⣯⢾⣻⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀\033[1;93m⠀⡇⠀⠀⠀\033[1;96m⡿⣿⣿⢵⣫⣿⣆⠁⠂\033[1;91m⣼⡿⢹⣿⡿⠽⠟⢢⠀⠀⠀⠀⠀⠀⠀⢹⠀⢄⢀⠀⡿⠀⠀\033[1;96m ⢰⣯⢷⣺⣏⣯⢻⡽⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀\033[1;93m⠀⡇⠀⢀⠠\033[1;96m⣿⣿⢾⣛⡶⣽⠈⢓⠀\033[1;91m⢻⠁⢸⠇⠀⠀⠀⢸⠀⠀⠀⠀⠀⠀⠀⠀⠑⠠⠤⠔⠂⠀⠀\033[1;96m ⢸⣿⢮⣽⠿⣜⣻⡝⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀\033[1;93m⠀⠑⠊⠁\033[1;96m⢠⡷⡇⣿⣿⢼⣹⡀⠀⠑⢄⠀\033[1;91m⠀⠃⠌⣁⠦⠟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠂⠀⠀\033[1;96m⢀⣿⢾⡝⣾⡽⣺⢽⣹⣽⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣻⢽⣻⡟⣮⣝⡷⢦⣄⣄⣢⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣾⣯⢿⡺⣟⢷⡹⢾⣷⡞⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣟⡿⣎⢿⡽⣳⢮⣿⣹⣾⣯⡝⣷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠃⠀⠀⠀⠀⠀⠀⣀⣴⡟⣿⢧⣏⢷⡟⣮⠝⢿⣹⣯⡽⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⣯⡷⣏⣾⡳⣽⢺⣷⡹⣟⢶⡹⣾⡽⣷⣤⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⡀⠔⣾⢯⣷⡇⣿⢳⣎⢿⡞⣽⢦⣼⡽⣧⢻⡽⣆⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣟⢾⡷⣭⣿⢳⣭⢻⣷⡻⣜⣻⡵⣻⡼⣿⠾⠫\033[1;96m⣽⣟⣶⣶⣶⠒⠒⠂⠉⠀\033[1;96m⢸⣽⢺⡷⣷⣯⢗⣮⣟⢾⢧⣻⠼⡿⣿⢣⡟⣼⣆⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡾⣝⣾⢳⢧⣟⡳⣎⣿⣿⣱⢏⣾⣽⣳⠟\033[1;92m⠁⠀⡌⠈\033[1;96m⢹⡯⠟⠛⠀⠀⠀⠀⠀⠈\033[1;96m⣷⢻⣼⣽⣿⡾⣼⣏⣾⣻⡜⣯⣷⢿⣟⣼⡳⣞⣦⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⢿⡸⣎⠿⣾⡏⣷⣉⣷⣿⢹⣎⡿\033[1;92m⠎⡎⠀⠀⠀⡇⠀⣾⠱⡀⠀⠀⠀⠀⠀⠀⠀⠈⣹⠉⡏⠀\033[1;96m⠹⣾⣏⢹⣶⢹⣶⢿⡾⣿⢶⣿⣸⠾⣇⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⣠⣾⢫⣞⡽⣯⢿⣹⡟⣶⣹⢷⣻\033[1;92m⡷⠊⠀⡜⠀⠀⠀⠀⢱⠀⣿⡀⠈⠢⢀⣀⣀⠠⠄⠒⢈⡏⡰⠀⠀⠀\033[1;96m⠀⣿⡜⣮⢟⡼⣻⡵⣻⣗⠾⣟⣯⢻⣆⠀⠀⠀⠀
⠀⠀⠀⠀⠀⢀⣴⣿⢣⣟⡾⣽⣯⢳⣿⡹⣖⣿⡳\033[1;92m⠋⠀⠀⡸⠀⠀⠀⠀⠀⢸⠀⢺⢂⠀⠀⠀⠀⠀⠀⠀⢠⡺⡱⠁⠀⠀⠀⠀\033[1;96m⢹⣧⣻⢮⡳⣝⡷⢧⣻⢯⢿⣻⣳⢞⡆⠀⠀⠀
⠀⠀⠀⠀⢀⡾⣽⣣⡿⣼⣏⡿⣼⣳⡯⢷⣹⣯⠇\033[1;92m⠀⠀⢠⠁⠀⠀⠀⠀⠀⠈⡆⠈⢹⡰⠤⡀⠀⠀⠀⢠⡼⢱⠁⠀⠀⠀⠀⠀⠀\033[1;96m⠹⣿⣿⣱⣻⣼⣏⢷⣯⣿⡳⣿⣎⢿⡀⠀⠀
⠀⠀⠀⠀⣾⣽⠷⣿⣵⡿⣼⡟⣭⣷⡟⣿⢯⡏⠀\033[1;92m⠀⠀⠘⠀⠀⠒⠈⢡⠀⠀⢗⢄⠀⠃⠀⠺⢁⢈⠥⠋⣀⠇⠀⠀⠀⠀⠀⠀⡀⠀\033[1;96m⠈⠙⢿⣳⢞⣽⢯⣞⣾⣯⡝⣿⡾⡇⠀⠀\033[1;92mAuthor: github.com/Azumi67  \033[1;96m  ⠀
  \033[1;96m  ______   \033[1;94m _______  \033[1;92m __    \033[1;93m  _______     \033[1;91m   __      \033[1;96m _____  ___  
 \033[1;96m  /    " \  \033[1;94m|   __ "\ \033[1;92m|" \  \033[1;93m  /"      \    \033[1;91m  /""\     \033[1;96m(\"   \|"  \ 
 \033[1;96m // ____  \ \033[1;94m(. |__) :)\033[1;92m||  |  \033[1;93m|:        |   \033[1;91m /    \   \033[1;96m |.\\   \     |
 \033[1;96m/  /    ) :)\033[1;94m|:  ____/ \033[1;92m|:  |  \033[1;93m|_____/   )  \033[1;91m /' /\  \   \033[1;96m|: \.   \\   |
\033[1;96m(: (____/ // \033[1;94m(|  /     \033[1;92m|.  |  \033[1;93m //      /  \033[1;91m //  __'  \  \033[1;96m|.  \    \  |
 \033[1;96m\        / \033[1;94m/|__/ \    \033[1;92m/\  |\ \033[1;93m|:  __   \  \033[1;91m/   /  \\   \ \033[1;96m|    \    \ |
 \033[1;96m \"_____/ \033[1;94m(_______)  \033[1;92m(__\_|_)\033[1;93m|__|  \___)\033[1;91m(___/    \___) \033[1;96m\___|\____\)
EOF
)
function main_menu() {
    while true; do
        display_logo
        echo -e "\e[93m╔════════════════════════════════════════════════════════════════╗\e[0m"  
        echo -e "\e[93m║           ▌║█║▌│║▌│║▌║▌█║ \e[92mMain Menu\e[93m  ▌│║▌║▌│║║▌█║▌             ║\e[0m"   
        echo -e "\e[93m╠════════════════════════════════════════════════════════════════╣\e[0m" 
        display_service_status                                 
		display_service_statuss
 echo -e "\e[93m╔════════════════════════════════════════════════════════════════╗\e[0m"
        echo -e   "\e[91m      🌐 \e[92mJoin Opiran Telegram \e[34m@https://t.me/OPIranClub\e[0m \e[91m🌐\e[0m"
        echo -e "\e[93m╠════════════════════════════════════════════════════════════════╣\e[0m"  
        echo -e "1. \e[96mInstallation-[Frp-Udp2raw]\e[0m"
		echo -e "2. \e[92mPrivate IP\e[0m"
        echo -e "3. \e[94mTCP Tunnel\e[0m"
        echo -e "4. \e[36mFRP Wireguard\e[0m"
        echo -e "5. \e[92mUDP2raw Wireguard\e[0m"
        echo -e "6. \e[93mRestart Service\e[0m"
        echo -e "7. \e[91mUninstall\e[0m"
        echo "0. Exit"
          printf "\e[93m╰─────────────────────────────────────────────────────────────────╯\e[0m\n" 
        read -e -p $'\e[5mEnter your choice Please: \e[0m' choice

        case $choice in
            1)
                installation_menu 
                ;;
			2)
                private_ip
                ;;				
            3)
                TCP_menu
                ;;
            4)
                FRPP_UDP_menu
                ;;
            5)
                UDP2raww_UDP_menu
                ;;
            6)
                restart_service
                ;;
            7)
                uninstall
                ;;
            0)
                echo "Exiting..."
                exit 0
                ;;
            *)
                echo "Invalid choice."
                ;;
        esac

        echo "Press Enter to continue..."
        read
        clear
    done
}
function rmve_cron() {
    entries_to_remove=(
        "0 */6 * * * /etc/res.sh"
    )

    if test -f /etc/res.sh; then
        for entry in "${entries_to_remove[@]}"; do
            existing_crontab=$(crontab -l 2>/dev/null)
            if [[ $existing_crontab == *"$entry"* ]]; then
                modified_crontab=${existing_crontab//$entry/}
                echo "$modified_crontab" | crontab -
                echo -e "\033[92mCron entry removed!\033[0m"
                rm /etc/res.sh
                return
            fi
        done
        echo -e "\033[91mCron entry not found.\033[0m"
    else
        echo -e "\033[91m/etc/res.sh file not found.\033[0m"
    fi
}


function res_li() {
    if test -f /etc/res.sh; then
        rm /etc/res.sh
    fi

    cat <<EOF > /etc/res.sh
#!/bin/bash
kill -9 \$(pgrep frps)
systemctl daemon-reload
systemctl restart azumifrps
EOF

    chmod +x /etc/res.sh

    existing_entry="0 */6 * * * /etc/res.sh"
    existing_crontab=""

    existing_crontab=$(crontab -l 2>/dev/null)

    if [[ $existing_entry == *"$existing_crontab"* ]]; then
        echo -e "\033[91mCrontab already exists.\033[0m"
    else
        new_crontab=$(echo -e "$existing_crontab\n0 */6 * * * /etc/res.sh\n")
        echo "$new_crontab" | crontab -
        echo -e "\033[92m6 hour reset timer added!\033[0m"
    fi

    echo -e "\033[92mIT IS DONE.!\033[0m"
}

function res_lk() {
    if test -f /etc/res.sh; then
        rm /etc/res.sh
    fi

    cat <<EOF > /etc/res.sh
#!/bin/bash
kill -9 \$(pgrep frpc)
systemctl daemon-reload
systemctl restart azumifrpc
EOF

    chmod +x /etc/res.sh

    existing_entry="0 */6 * * * /etc/res.sh"
    existing_crontab=""

    existing_crontab=$(crontab -l 2>/dev/null)

    if [[ $existing_entry == *"$existing_crontab"* ]]; then
        echo -e "\033[91mCrontab already exists.\033[0m"
    else
        new_crontab=$(echo -e "$existing_crontab\n0 */6 * * * /etc/res.sh\n")
        echo "$new_crontab" | crontab -
        echo -e "\033[92m6 hour reset timer added!\033[0m"
    fi

    echo -e "\033[92mIT IS DONE.!\033[0m"
}
function installation_menu() {
    clear
    echo $'\e[92m ^ ^\e[0m'
    echo $'\e[92m(\e[91mO,O\e[92m)\e[0m'
    echo $'\e[92m(   ) \e[93mInstallation Menu\e[0m'
    echo $'\e[92m "-"\e[93m═════════════════════\e[0m'
	echo ""
 printf "\e[93m╭───────────────────────────────────────╮\e[0m\n"
  echo $'\e[93mSelect what to install:\e[0m'
  echo $'1. \e[92mFRP\e[0m'
  echo $'2. \e[93mUDP2RAW\e[0m'
  echo $'3. \e[94mback to main menu\e[0m'
  printf "\e[93m╰───────────────────────────────────────╯\e[0m\n"
  read -e -p $'\e[38;5;205mEnter your choice Please: \e[0m' server_type
case $server_type in
        1)
            frp_menu
            ;;
        2)
            udp_menu
            ;;
        3)
            clear            
            main_menu
            ;;
        *)
            echo "Invalid choice."
            ;;
    esac
}

function frp_menu() {
 # Function to stop the loading animation and exit
    function stop_loading() {
        echo -e "\xE2\x9D\x8C Installation process interrupted."
        exit 1
    }

    # (Ctrl+C)
    trap stop_loading INT

ipv4_forwarding=$(sysctl -n net.ipv4.ip_forward)
    if [[ $ipv4_forwarding -eq 1 ]]; then
        echo "IPv4 forwarding is already enabled."
    else
        sysctl -w net.ipv4.ip_forward=1 &>/dev/null
        echo "IPv4 forwarding has been enabled."
    fi

    ipv6_forwarding=$(sysctl -n net.ipv6.conf.all.forwarding)
    if [[ $ipv6_forwarding -eq 1 ]]; then
        echo "IPv6 forwarding is already enabled."
    else
        sysctl -w net.ipv6.conf.all.forwarding=1 &>/dev/null
        echo "IPv6 forwarding has been enabled."
    fi

    # DNS baraye install

    # CPU architecture
    arch=$(uname -m)

    # cpu architecture
    case $arch in
        x86_64 | amd64)
            frp_download_url="https://github.com/fatedier/frp/releases/download/v0.52.3/frp_0.52.3_linux_amd64.tar.gz"
            ;;
        aarch64 | arm64)
            frp_download_url="https://github.com/fatedier/frp/releases/download/v0.52.3/frp_0.52.3_linux_arm64.tar.gz"
            ;;
        *)
            display_error "Unsupported CPU architecture: $arch"
            return
            ;;
    esac

    # Download FRP notificatiooooons
    display_notification $'\e[91mDownloading FRP in a sec...\e[0m'
    display_notification $'\e[91mPlease wait, updating...\e[0m'

    # timer
    SECONDS=0

    # Update in the background
    apt update &>/dev/null &
    apt_update_pid=$!

    # Timer
    while [[ -n $(ps -p $apt_update_pid -o pid=) ]]; do
        clear
        display_notification $'\e[93mPlease wait, updating...\e[0m'
        display_notification $'\e[93mAzumi is working in the background, timer: \e[0m'"$SECONDS seconds"
        sleep 1
    done

    # progress bar
    for ((i=0; i<=10; i++)); do
        sleep 0.5
        display_progress 10 $i
    done

    display_checkmark $'\e[92mUpdate completed successfully!\e[0m'

    # Download the appropriate FRP version
    wget "$frp_download_url" -O frp.tar.gz &>/dev/null
    tar -xf frp.tar.gz &>/dev/null

    display_checkmark $'\e[92mFRP installed successfully!\e[0m'

    # sysctl setting
    sysctl -p &>/dev/null

    # notify
    display_notification $'\e[92mIP forward enabled!\e[0m'
    display_loading

    # interrupt
    trap - INT
}
function udp_menu() {

   # clean up
    stop_loading() {
        kill $loading_bar_pid &>/dev/null
        echo ""
    }

    # (Ctrl+C)
    trap stop_loading INT

 # add DNS address


ipv4_forwarding=$(sysctl -n net.ipv4.ip_forward)
    if [[ $ipv4_forwarding -eq 1 ]]; then
        echo "IPv4 forwarding is already enabled."
    else
        sysctl -w net.ipv4.ip_forward=1 &>/dev/null
        echo "IPv4 forwarding has been enabled."
    fi
    
    ipv6_forwarding=$(sysctl -n net.ipv6.conf.all.forwarding)
    if [[ $ipv6_forwarding -eq 1 ]]; then
        echo "IPv6 forwarding is already enabled."
    else
        sysctl -w net.ipv6.conf.all.forwarding=1 &>/dev/null
        echo "IPv6 forwarding has been enabled."
    fi

    # Azumi is working in the background
 (
    while true; do
        echo -ne "\033[92mRunning update:  [          ]  $(printf "%02d:%02d" $((SECONDS/60)) $((SECONDS%60)))  \r\033[0m"
        sleep 0.3
        echo -ne "\033[92mRunning update:  [█         ]  $(printf "%02d:%02d" $((SECONDS/60)) $((SECONDS%60)))  \r\033[0m"
        sleep 0.3
        echo -ne "\033[92mRunning update:  [██        ]  $(printf "%02d:%02d" $((SECONDS/60)) $((SECONDS%60)))  \r\033[0m"
        sleep 0.3
        echo -ne "\033[92mRunning update:  [███       ]  $(printf "%02d:%02d" $((SECONDS/60)) $((SECONDS%60)))  \r\033[0m"
        sleep 0.3
        echo -ne "\033[92mRunning update:  [████      ]  $(printf "%02d:%02d" $((SECONDS/60)) $((SECONDS%60)))  \r\033[0m"
        sleep 0.3
        echo -ne "\033[92mRunning update:  [█████     ]  $(printf "%02d:%02d" $((SECONDS/60)) $((SECONDS%60)))  \r\033[0m"
        sleep 0.3
        echo -ne "\033[92mRunning update:  [██████    ]  $(printf "%02d:%02d" $((SECONDS/60)) $((SECONDS%60)))  \r\033[0m"
        sleep 0.3
        echo -ne "\033[92mRunning update:  [███████   ]  $(printf "%02d:%02d" $((SECONDS/60)) $((SECONDS%60)))  \r\033[0m"
        sleep 0.3
    done
) &

    loading_bar_pid=$!
    # run update 
    apt update > /dev/null 2>&1
	apt install wget > /dev/null 2>&1

    # clean up
    stop_loading

   display_checkmark $'\e[92mUpdate completed.\e[0m'
   sleep 1
   echo -e "\033[93mInstalling UDP2raw...\033[0m"
   sleep 1
   echo -e "\033[93mDownloading UDP2raw package...\033[0m"

    # Loading for FRP
    (
while true; do
    echo -ne "\033[94mLoading: [\033[1m=\033[0m          ]\r"
    sleep 0.5
    echo -ne "\033[94mLoading: [\033[1m==\033[0m         ]\r"
    sleep 0.5
    echo -ne "\033[94mLoading: [\033[1m===\033[0m        ]\r"
    sleep 0.5
    echo -ne "\033[94mLoading: [\033[1m====\033[0m       ]\r"
    sleep 0.5
    echo -ne "\033[94mLoading: [\033[1m=====\033[0m      ]\r"
    sleep 0.5
    echo -ne "\033[94mLoading: [\033[1m======\033[0m     ]\r"
    sleep 0.5
    echo -ne "\033[94mLoading: [\033[1m=======\033[0m    ]\r"
    sleep 0.5
    echo -ne "\033[94mLoading: [\033[1m========\033[0m   ]\r"
    sleep 0.5
    echo -ne "\033[94mLoading: [\033[1m=========\033[0m  ]\r"
    sleep 0.5
    echo -ne "\033[94mLoading: [\033[1m==========\033[0m ]\r"
    sleep 0.5
    echo -ne "\033[94mLoading: [\033[1m===========\033[0m]\r"
    sleep 0.5
done
) &
 
    loading_bar_pid=$!
system_architecture=$(uname -m)

if [ "$system_architecture" != "x86_64" ] && [ "$system_architecture" != "amd64" ] && [ "$system_architecture" != "arm" ]; then
    echo "Unsupported architecture: $system_architecture" > /dev/null
    exit 1
fi

sleep 1
echo ""
echo -e "${YELLOW}Downloading and installing udp2raw for architecture: $system_architecture${NC}" 

if [ "$system_architecture" == "x86_64" ] || [ "$system_architecture" == "amd64" ]; then
    wget https://github.com/Azumi67/udp2raw-core/raw/main/udp2raw_amd64 &>/dev/null
elif [ "$system_architecture" == "arm" ]; then
    wget https://github.com/Azumi67/udp2raw-core/raw/main/udp2raw_arm &>/dev/null
fi
sleep 1

chmod +x udp2raw_amd64 &>/dev/null
chmod +x udp2raw_arm &>/dev/null
    stop_loading

    display_checkmark $'\e[92mUDP2raw installation completed.\e[0m'


    # setup time
    duration=$SECONDS
    echo -e "\033[93mInstallation completed in \033[92m$(($duration / 60)) minutes and $(($duration % 60)) seconds.\033[0m"

    # interrupt
    trap - INT
}
function private_ip() {
    clear
    echo $'\e[92m ^ ^\e[0m'
    echo $'\e[92m(\e[91mO,O\e[92m)\e[0m'
    echo $'\e[92m(   ) \e[93mPrivate IP Menu\e[0m'
    echo $'\e[92m "-"\e[93m═════════════════════\e[0m'
      printf "\e[93m╭───────────────────────────────────────╮\e[0m\n"
  echo $'\e[93mChoose what to do:\e[0m'
  echo $'1. \e[92mKharej\e[0m'
  echo $'2. \e[91mIRAN\e[0m'
  echo $'3. \e[94mback to main menu\e[0m'
  printf "\e[93m╰───────────────────────────────────────╯\e[0m\n"
  read -e -p $'\e[38;5;205mEnter your choice Please: \e[0m' server_type
case $server_type in
    1)
        kharej_private_menu
        ;;
    2)
        iran_private_menu
        ;;
    3)
        clear
        main_menu
        ;;
    *)
        echo "Invalid choice."
        ;;
esac
}
function kharej_private_menu() {
     clear
	  echo $'\e[92m ^ ^\e[0m'
      echo $'\e[92m(\e[91mO,O\e[92m)\e[0m'
      echo $'\e[92m(   ) \e[93mConfiguring kharej server\e[0m'
      echo $'\e[92m "-"\e[93m══════════════════════════\e[0m'
       display_logoo
      printf "\e[93m╭────────────────────────────────────────────────────────────────────────────────────╮\e[0m\n"
        echo $'\e[92m   Please make sure to remove any private IPs that you have created before proceeding\e[0m'
      printf "\e[93m╰────────────────────────────────────────────────────────────────────────────────────╯\e[0m\n"
	  display_notification $'\e[93mAdding private IP addresses for Kharej server...\e[0m'
    if [ -f "/etc/private.sh" ]; then
        rm /etc/private.sh
    fi

# Q&A
printf "\e[93m╭─────────────────────────────────────────────────────────╮\e[0m\n"
read -e -p $'\e[93mEnter \e[92mKharej\e[93m IPV4 address: \e[0m' local_ip
read -e -p $'\e[93mEnter \e[92mIRAN\e[93m IPV4 address: \e[0m' remote_ip


# ip commands
ip tunnel add azumi mode sit remote $remote_ip local $local_ip ttl 255 > /dev/null

ip link set dev azumi up > /dev/null
 
# iran initial IP address
initial_ip="fd1d:fc98:b73e:b481::1/64"
ip addr add $initial_ip dev azumi > /dev/null

# additional private IPs-number
read -e -p $'How many additional \e[92mprivate IPs\e[93m do you need? \e[0m' num_ips
printf "\e[93m╰─────────────────────────────────────────────────────────╯\e[0m\n"

# additional private IPs
for ((i=1; i<=num_ips; i++))
do
  ip_suffix=`printf "%x\n" $i`
  ip_addr="fd1d:fc98:b73e:b48${ip_suffix}::1/64"  > /dev/null
  
  # Check kharej
  ip addr show dev azumi | grep -q "$ip_addr"
  if [ $? -eq 0 ]; then
    echo "IP address $ip_addr already exists. Skipping..."
  else
    ip addr add $ip_addr dev azumi
  fi
done

    # private.sh
	display_notification $'\e[93mAdding commands to private.sh...\e[0m'
    echo "ip tunnel add azumi mode sit remote $remote_ip local $local_ip ttl 255" >> /etc/private.sh
    echo "ip link set dev azumi up" >> /etc/private.sh
    echo "ip addr add fd1d:fc98:b73e:b481::1/64 dev azumi" >> /etc/private.sh
        ip_addr="fd1d:fc98:b73e:b48${ip_suffix}::1/64"
        echo "ip addr add $ip_addr dev azumi" >> /etc/private.sh

    display_checkmark $'\e[92mPrivate ip added successfully!\e[0m'

display_notification $'\e[93mAdding cron job for server!\e[0m'
    (crontab -l 2>/dev/null; echo "@reboot /bin/bash /etc/private.sh") | crontab -
	
	ping -c 2 fd1d:fc98:b73e:b481::2 | sed "s/.*/\x1b[94m&\x1b[0m/" 
	sleep 1
	display_notification $'\e[93mConfiguring keepalive service..\e[0m'

    # script
script_content='#!/bin/bash

# IPv6 address
ip_address="fd1d:fc98:b73e:b481::2"

# maximum number
max_pings=4

# Interval
interval=60

# Loop run
while true
do
    # Loop for pinging specified number of times
    for ((i = 1; i <= max_pings; i++))
    do
        ping_result=$(ping -c 1 $ip_address | grep "time=" | awk -F "time=" "{print $2}" | awk -F " " "{print $1}" | cut -d "." -f1)
        if [ -n "$ping_result" ]; then
            echo "Ping successful! Response time: $ping_result ms"
        else
            echo "Ping failed!"
        fi
    done

    echo "Waiting for $interval seconds..."
    sleep $interval
done'

echo "$script_content" | sudo tee /etc/ping_v6.sh > /dev/null

    chmod +x /etc/ping_v6.sh
# service file
    cat <<EOF > /etc/systemd/system/ping_v6.service
[Unit]
Description=keepalive
After=network.target

[Service]
ExecStart=/bin/bash /etc/ping_v6.sh
Restart=always

[Install]
WantedBy=multi-user.target
EOF
    
    systemctl daemon-reload
    systemctl enable ping_v6.service
    systemctl start ping_v6.service
    display_checkmark $'\e[92mPing Service has been added successfully!\e[0m'	
	
# display 
echo ""
echo -e "Created \e[93mPrivate IP Addresses \e[92m(Kharej):\e[0m"
for ((i=1; i<=num_ips; i++))
do
    ip_suffix=`printf "%x\n" $i`
    ip_addr="fd1d:fc98:b73e:b48${ip_suffix}::1"
    echo "+---------------------------+"
    echo -e "| \e[92m$ip_addr    \e[0m|"
done
echo "+---------------------------+"
}
# private IP for Iran
function iran_private_menu() {
 clear
	  echo $'\e[92m ^ ^\e[0m'
      echo $'\e[92m(\e[91mO,O\e[92m)\e[0m'
      echo $'\e[92m(   ) \e[93mConfiguring Iran server\e[0m'
      echo $'\e[92m "-"\e[93m══════════════════════════\e[0m'
       display_logoo
      printf "\e[93m╭────────────────────────────────────────────────────────────────────────────────────╮\e[0m\n"
        echo $'\e[92m   Please make sure to remove any private IPs that you have created before proceeding\e[0m'
      printf "\e[93m╰────────────────────────────────────────────────────────────────────────────────────╯\e[0m\n"
    	  display_notification $'\e[93mAdding private IP addresses for Iran server...\e[0m'
    if [ -f "/etc/private.sh" ]; then
        rm /etc/private.sh
    fi

# Q&A
printf "\e[93m╭─────────────────────────────────────────────────────────╮\e[0m\n"
read -e -p $'\e[93mEnter \e[92mKharej\e[93m IPV4 address: \e[0m' remote_ip
read -e -p $'\e[93mEnter \e[92mIRAN\e[93m IPV4 address: \e[0m' local_ip


# ip commands
ip tunnel add azumi mode sit remote $remote_ip local $local_ip ttl 255 > /dev/null

ip link set dev azumi up > /dev/null
 
# iran initial IP address
initial_ip="fd1d:fc98:b73e:b481::2/64"
ip addr add $initial_ip dev azumi > /dev/null

# additional private IPs-number
read -e -p $'How many additional \e[92mprivate IPs\e[93m do you need? \e[0m' num_ips
printf "\e[93m╰─────────────────────────────────────────────────────────╯\e[0m\n"
# additional private IPs
for ((i=1; i<=num_ips; i++))
do
  ip_suffix=`printf "%x\n" $i`
  ip_addr="fd1d:fc98:b73e:b48${ip_suffix}::2/64" > /dev/null
  
  # Check iran
  ip addr show dev azumi | grep -q "$ip_addr"
  if [ $? -eq 0 ]; then
    echo "IP address $ip_addr already exists. Skipping..."
  else
    ip addr add $ip_addr dev azumi
  fi
done
# private.sh
    echo -e "\e[93mAdding commands to private.sh...\e[0m"
    echo "ip tunnel add azumi mode sit remote $remote_ip local $local_ip ttl 255" >> /etc/private.sh
    echo "ip link set dev azumi up" >> /etc/private.sh
    echo "ip addr add fd1d:fc98:b73e:b481::2/64 dev azumi" >> /etc/private.sh
        ip_addr="fd1d:fc98:b73e:b48${ip_suffix}::2/64"
        echo "ip addr add $ip_addr dev azumi" >> /etc/private.sh
    
    chmod +x /etc/private.sh

    display_checkmark $'\e[92mPrivate ip added successfully!\e[0m'


    display_notification $'\e[93mAdding cron job for server!\e[0m'
    (crontab -l 2>/dev/null; echo "@reboot /bin/bash /etc/private.sh") | crontab -

	ping -c 2 fd1d:fc98:b73e:b481::1 | sed "s/.*/\x1b[94m&\x1b[0m/" 
	sleep 1
	display_notification $'\e[93mConfiguring keepalive service..\e[0m'

# script
script_content='#!/bin/bash

# iPv6 address
ip_address="fd1d:fc98:b73e:b481::1"


max_pings=3

# interval
interval=50

# loop run
while true
do
    # Loop for pinging specified number of times
    for ((i = 1; i <= max_pings; i++))
    do
        ping_result=$(ping -c 1 $ip_address | grep "time=" | awk -F "time=" "{print $2}" | awk -F " " "{print $1}" | cut -d "." -f1)
        if [ -n "$ping_result" ]; then
            echo "Ping successful! Response time: $ping_result ms"
        else
            echo "Ping failed!"
        fi
    done

    echo "Waiting for $interval seconds..."
    sleep $interval
done'

echo "$script_content" | sudo tee /etc/ping_v6.sh > /dev/null

    chmod +x /etc/ping_v6.sh
# service file
    cat <<EOF > /etc/systemd/system/ping_v6.service
[Unit]
Description=keepalive
After=network.target

[Service]
ExecStart=/bin/bash /etc/ping_v6.sh
Restart=always

[Install]
WantedBy=multi-user.target
EOF
    
    systemctl daemon-reload
    systemctl enable ping_v6.service
    systemctl start ping_v6.service
    display_checkmark $'\e[92mPing Service has been added successfully!\e[0m'

# display
echo ""
echo -e "Created \e[93mPrivate IP Addresses \e[92m(Iran):\e[0m"
for ((i=1; i<=num_ips; i++))
do
    ip_suffix=`printf "%x\n" $i`
    ip_addr="fd1d:fc98:b73e:b48${ip_suffix}::2"
    echo "+---------------------------+"
    echo -e "| \e[92m$ip_addr    \e[0m|"
done
echo "+---------------------------+"
}

function TCP_menu() {
clear
  clear
  echo $'\e[92m ^ ^\e[0m'
  echo $'\e[92m(\e[91mO,O\e[92m)\e[0m'
  echo $'\e[92m(   ) \e[93mTCP Tunnel Menu\e[0m'
  echo $'\e[92m "-"\e[93m═══════════════════════════════\e[0m'
    printf "\e[93m╭───────────────────────────────────────╮\e[0m\n"
    echo "Select an option:"
    echo -e "1. \e[92mKharej Tunnel\e[0m"
    echo -e "2. \e[96mIRAN Tunnel\e[0m"
    echo -e "3. \e[33mBack to main menu\e[0m"
      printf "\e[93m╰───────────────────────────────────────╯\e[0m\n"
    read -e -p "Enter your choice Please: " choice

    case $choice in
        1)
            kharej_tunnel_menu
            ;;
        2)
            iran_tunnel_menu
            ;;
        3)
            clear
            main_menu
            ;;
        *)
            echo "Invalid choice."
            ;;
 esac
}
function kharej_tunnel_menu() {
    clear
  
  echo $'\e[92m ^ ^\e[0m'
  echo $'\e[92m(\e[91mO,O\e[92m)\e[0m'
  echo $'\e[92m(   ) \e[93muKharej TCP Tunnel\e[0m'
  echo $'\e[92m "-"\e[93m═══════════════════════════════\e[0m'
  echo ""
   printf "\e[93m╭───────────────────────────────────────────────────────────────────╮\e[0m\n"
    read -p $'\e[93mHow many Private ip address do you have:\e[0m\e[92m[Kharej] \e[0m' num_ipv6
    sleep 1
    echo "Generating Config for you..."

    read -e -p $'\e[93mEnter \e[92mIran\e[93m Private ip address: \e[0m' iran_ipv6
    read -e -p $'\e[93mEnter Tunnel \e[92mToken\e[93m:[Same value for Server & Client] \e[0m' frp_token
    read -e -p $'\e[93mEnter \e[92mTunnel\e[93m Port:[Example: 443] \e[0m' tunnel_port
# frpc.ini 
rm frp_0.52.3_linux_amd64/frpc.ini
rm frp_0.52.3_linux_arm64/frpc.ini
# CPU architecture
if [[ "$(uname -m)" == "x86_64" ]]; then
  cpu_arch="amd64"
elif [[ "$(uname -m)" == "aarch64" ]]; then
  cpu_arch="arm64"
else
  echo -e "\e[93mUnsupported CPU architecture.\e[0m"
  exit 1
fi


    cat > frp_0.52.3_linux_$cpu_arch/frpc.ini <<EOL
[common]
server_addr = $iran_ipv6
server_port = $tunnel_port
authentication_mode = token
token = $frp_token

EOL

    for ((i=1; i<=$num_ipv6; i++)); do
        read -e -p $'\e[93mEnter your \e[92mKharej\e[93m '$i$'th Private ip address:\e[0m ' kharej_ipv6
        read -e -p $'\e[93mEnter \e[92mKharej\e[93m TCP port:\e[0m\e[92m[This is your current port]\e[0m ' kharej_port
        read -e -p $'\e[93mEnter \e[92mIran\e[93m TCP port:\e[0m\e[92m[This will be your new port]\e[0m ' iran_port
 printf "\e[93m╰────────────────────────────────────────────────────────────────────╯\e[0m\n"
    
        cat >> frp_0.52.3_linux_$cpu_arch/frpc.ini <<EOL

[v2ray$i]
type = tcp
local_port = $kharej_port
remote_port = $iran_port
local_ip$i = $kharej_ipv6
use_encryption = true
use_compression = true

EOL
    done

    display_checkmark $'\e[92mKharej configuration generated. Yours Truly, Azumi.\e[0m'
# service section for Kharej
    cat > /etc/systemd/system/azumifrpc.service <<EOL
[Unit]
Description=frpc service
After=network.target

[Service]
ExecStart=/root/frp_0.52.3_linux_$cpu_arch/./frpc -c /root/frp_0.52.3_linux_$cpu_arch/frpc.ini
Restart=always
RestartSec=10
User=root

[Install]
WantedBy=multi-user.target
EOL
echo "Reloading daemon..." > /dev/null 2>&1
    systemctl daemon-reload > /dev/null 2>&1

    echo "Enabling FRP service..." > /dev/null 2>&1
    systemctl enable azumifrpc > /dev/null 2>&1

    echo "Starting FRP  service..."
    systemctl restart azumifrpc
    res_lk
    display_checkmark $'\e[92mFRP Service started.\e[0m'
}
function iran_tunnel_menu() {
    clear
    
    echo $'\e[92m ^ ^\e[0m'
    echo $'\e[92m(\e[91mO,O\e[92m)\e[0m'
    echo $'\e[92m(   ) \e[93mIran TCP Tunnel\e[0m'
    echo ""
    echo $'\e[92m "-"\e[93m═══════════════════════════════\e[0m'
    printf "\e[93m╭───────────────────────────────────────────────────────────────────╮\e[0m\n"
    read -e -p $'\e[93mHow many \e[92mIran\e[93m Private ip addresses do you have: \e[0m' num_ipv6
    sleep 1
    echo "Generating Iran Config for you..."
    read -e -p $'\e[93mEnter \e[92mTunnel Port\e[93m:[Example: \e[92m443\e[93m] \e[0m' tunnel_port
    read -e -p $'\e[93mEnter \e[92mTunnel Token\e[93m:[\e[93mSame Value for both Iran & Kharej\e[93m] \e[0m' token
    
    echo -e "\e[93mGenerating config for you...\e[0m"
     rm frp_0.52.3_linux_amd64/frps.ini
     rm frp_0.52.3_linux_arm64/frps.ini
    # frps.ini
	# CPU architecture
if [[ "$(uname -m)" == "x86_64" ]]; then
  cpu_arch="amd64"
elif [[ "$(uname -m)" == "aarch64" ]]; then
  cpu_arch="arm64"
else
  echo -e "\e[93mUnsupported CPU architecture.\e[0m"
  exit 1
fi
    cat > frp_0.52.3_linux_$cpu_arch/frps.ini <<EOL
[common]
bind_port = $tunnel_port
token = $token

EOL

for ((i=1; i<=$num_ipv6; i++)); do
        read -e -p $'\e[93mEnter your \e[92mIran\e[93m '$i$'th Private ip address:\e[0m ' iran_ipv6
        read -e -p $'\e[93mEnter \e[92mKharej\e[93m TCP port:\e[0m\e[92m[This is your current port]\e[0m ' kharej_v2ray_port
        read -e -p $'\e[93mEnter \e[92mIran\e[93m TCP port:\e[0m\e[92m[This will be your new port]\e[0m ' iran_v2ray_port
  printf "\e[93m╰────────────────────────────────────────────────────────────────────╯\e[0m\n"
    
        cat >> frp_0.52.3_linux_$cpu_arch/frps.ini <<EOL
[v2ray$i]
type = tcp
local_ip$i = $iran_ipv6
local_port = $iran_v2ray_port
remote_port = $kharej_v2ray_port
use_encryption = true
use_compression = true

EOL
    done

    display_checkmark $'\e[92mIran configuration generated. Yours Truly, Azumi.\e[0m'
# service section for Kharej
    cat > /etc/systemd/system/azumifrps.service <<EOL
[Unit]
Description=frps service
After=network.target

[Service]
ExecStart=/root/frp_0.52.3_linux_$cpu_arch/./frps -c /root/frp_0.52.3_linux_$cpu_arch/frps.ini
Restart=always
RestartSec=10
User=root

[Install]
WantedBy=multi-user.target
EOL
echo "Reloading daemon..." > /dev/null 2>&1
    systemctl daemon-reload > /dev/null 2>&1

    echo "Enabling FRP service..." > /dev/null 2>&1
    systemctl enable azumifrps > /dev/null 2>&1

    echo "Starting FRP  service..."
    systemctl restart azumifrps
    res_li
    display_checkmark $'\e[92mFRP Service started.\e[0m'
}

function UDP2raww_UDP_menu() {
  clear
  echo $'\e[92m ^ ^\e[0m'
  echo $'\e[92m(\e[91mO,O\e[92m)\e[0m'
  echo $'\e[92m(   ) \e[93mudp2raw Tunnel Menu\e[0m'
  echo $'\e[92m "-"\e[93m═══════════════════════════════\e[0m'
    printf "\e[93m╭───────────────────────────────────────╮\e[0m\n"
  echo $'\e[93mSelect what to install:\e[0m'
  echo $'1. \e[92mKharej\e[0m'
  echo $'2. \e[93mIRAN\e[0m'
  echo $'3. \e[94mback to main menu\e[0m'
  printf "\e[93m╰───────────────────────────────────────╯\e[0m\n"
  read -e -p $'\e[38;5;205mEnter your choice Please: \e[0m' server_type
case $server_type in
        1)
            udp2raww_kharej_menu
            ;;
        2)
            udp2raww_iran_menu
            ;;
        3)
            clear            
            main_menu
            ;;
        *)
            echo "Invalid choice."
            ;;
    esac
}
function udp2raww_kharej_menu() {
    clear
  echo $'\e[92m ^ ^\e[0m'
  echo $'\e[92m(\e[91mO,O\e[92m)\e[0m'
  echo $'\e[92m(   ) \e[93mudp2raw Tunnel- Kharej\e[0m'
  echo $'\e[92m "-"\e[93m═══════════════════════════════\e[0m'
    printf "\e[93m╭─────────────────────────────────────────────────────╮\e[0m\n"
    read -e -p $'\e[93mEnter \e[92mTunnel\e[93m port: \e[0m\e[92m[example: 443]\e[0m ' local_port
    read -e -p $'\e[93mEnter \e[92mWireguard\e[93m port: [example: 50820]\e[0m ' remote_port
	read -e -p $'\e[93mEnter \e[92mTunnel\e[93m password: [Same value for Kharej & Iran]\e[0m ' password
    echo -e "\e[93m protocol \e[92m(Mode) \e[93m(Iran & Kharej value should be the same)\e[0m"
    echo ""
echo -e "1.\e[93mudp\e[0m"
echo -e "2.\e[93mfaketcp\e[0m"
echo -e "3.\e[93micmp\e[0m"
printf "\e[93m╰──────────────────────────────────────────────────────╯\e[0m\n"
    echo -e "\e[93mEnter your choice [1-3] : \e[0m"
    read protocol_choice

    case $protocol_choice in
        1)
            raw_mode="udp"
            ;;
        2)
            raw_mode="faketcp"
            ;;
        3)
            raw_mode="icmp"
            ;;
        *)
            echo -e "\e[91mInvalid choice, choose correctly ...\e[0m"
            ;;
    esac

    echo -e "\e[36mSelected protocol: \e[32m$raw_mode\e[0m"

   # architecture
if [[ "$(uname -m)" == "x86_64" ]]; then
  cpu_arch="amd64"
elif [[ "$(uname -m)" == "aarch64" ]]; then
  cpu_arch="arm"
else
  echo -e "\e[93mUnsupported CPU architecture.\e[0m"
  exit 1
fi
    # cpu architecture
config_file="/etc/systemd/system/azumi-udp2raws.service"
udp2raw_exec="/root/udp2raw_$cpu_arch"



# service file
cat << EOF > "$config_file"
[Unit]
Description=udp2raw-s Service
After=network.target

[Service]
ExecStart=$udp2raw_exec -s -l [::]:${local_port} -r 127.0.0.1:${remote_port} -k "${password}" --raw-mode ${raw_mode} -a
Restart=always
RestartSec=10
User=root

[Install]
WantedBy=multi-user.target
EOF

    sleep 1
    systemctl daemon-reload
    systemctl restart "azumi-udp2raws.service" > /dev/null 2>&1
    systemctl enable --now "azumi-udp2raws.service" > /dev/null 2>&1
    systemctl start --now "azumi-udp2raws.service" > /dev/null 2>&1
    sleep 1

    display_checkmark $'\e[92mKharej configuration has been adjusted and service started. Yours truly, Azumi\e[0m'
}

function udp2raww_iran_menu() {
     clear
    echo $'\e[92m ^ ^\e[0m'
    echo $'\e[92m(\e[91mO,O\e[92m)\e[0m'
    echo $'\e[92m(   ) \e[93mudp2raw Tunnel- Iran\e[0m'
    echo $'\e[92m "-"\e[93m═══════════════════════════════\e[0m'
    echo -e "Configuring IRAN server"
    printf "\e[93m╭─────────────────────────────────────────────────────╮\e[0m\n"
    read -e -p $'\e[93mEnter \e[92mTunnel\e[93m port: [example: 443]\e[0m ' remote_port
    read -e -p $'\e[93mEnter \e[92mWireguard\e[93m port: [example: 50820]\e[0m ' local_port
    read -e -p $'\e[93mEnter \e[92mTunnel\e[93m password: [Same value for Kharej & Iran]\e[0m ' password
    read -e -p $'\e[93mEnter \e[92mKharej\e[93m private ip address:\e[0m ' remote_address
    echo -e "\e[93m protocol \e[92m(Mode) \e[93m(Iran & Kharej value should be the same)\e[0m"
    echo ""
    echo -e "1.\e[93mudp\e[0m"
    echo -e "2.\e[93mfaketcp\e[0m"
    echo -e "3.\e[93micmp\e[0m"
    printf "\e[93m╰──────────────────────────────────────────────────────╯\e[0m\n"
    echo -e "\e[93mEnter your choice [1-3] : \e[0m"
    read protocol_choice

    case $protocol_choice in
        1)
            raw_mode="udp"
            ;;
        2)
            raw_mode="faketcp"
            ;;
        3)
            raw_mode="icmp"
            ;;
        *)
            echo -e "\e[91mInvalid choice, choose correctly ...\e[0m"
            ;;
    esac

    echo -e "\e[36mSelected protocol: \e[32m$raw_mode\e[0m"

   # architecture
if [[ "$(uname -m)" == "x86_64" ]]; then
  cpu_arch="amd64"
elif [[ "$(uname -m)" == "aarch64" ]]; then
  cpu_arch="arm"
else
  echo -e "\e[93mUnsupported CPU architecture.\e[0m"
  exit 1
fi
    # cpu architecture
config_file="/etc/systemd/system/azumi-udp2rawc.service"
udp2raw_exec="/root/udp2raw_$cpu_arch"


# service file
cat << EOF > "$config_file"
[Unit]
Description=udp2raw-c Service
After=network.target

[Service]
ExecStart=$udp2raw_exec -c -l [::]:${local_port} -r [${remote_address}]:${remote_port} -k ${password} --raw-mode ${raw_mode} -a
Restart=always
RestartSec=10
User=root

[Install]
WantedBy=multi-user.target
EOF

sleep 1
systemctl daemon-reload
systemctl restart "azumi-udp2rawc.service" > /dev/null 2>&1
systemctl enable --now "azumi-udp2rawc.service" > /dev/null 2>&1
systemctl start --now "azumi-udp2rawc.service" > /dev/null 2>&1

display_checkmark $'\e[92mIran configuration has been adjusted and service started. Yours truly, Azumi\e[0m'
}
function FRPP_UDP_menu() {
      clear
	  echo $'\e[92m ^ ^\e[0m'
      echo $'\e[92m(\e[91mO,O\e[92m)\e[0m'
      echo $'\e[92m(   ) \e[93mWireguard Menu\e[0m'
      echo $'\e[92m "-"\e[93m══════════════════════════\e[0m'
      printf "\e[93m╭────────────────────────────────────────────────────────────╮\e[0m\n"
    echo $'\e[93mSelect what server to configure:\e[0m'
    echo $'1. \e[92mKharej\e[0m'
    echo $'2. \e[93mIRAN\e[0m'
    echo $'3. \e[94mback to main menu\e[0m'
      printf "\e[93m╰────────────────────────────────────────────────────────────╯\e[0m\n"
    read -e -p $'\e[38;5;205mEnter your choice Please: \e[0m' server_type
    case $server_type in
        1)
            frpp_kharej_menu
            ;;
        2)
            frpp_iran_menu
            ;;
        3)
            clear
            main_menu
            ;;
        *)
            echo "Invalid choice."
            ;;
    esac
}

function frpp_kharej_menu() {
  clear
  
  echo $'\e[92m ^ ^\e[0m'
  echo $'\e[92m(\e[91mO,O\e[92m)\e[0m'
  echo $'\e[92m(   ) \e[93mFRP Kharej Tunnel\e[0m'
  echo $'\e[92m "-"\e[93m═══════════════════════════════\e[0m'
  printf "\e[93m╭──────────────────────────────────────────────────────╮\e[0m\n"
    read -e -p $'\e[93mHow many \e[92mKharej \e[93mPrivate IP address do you have: \e[0m' num_ipv6
    sleep 1
    echo "Generating Config for you..."

    read -e -p $'\e[93mEnter \e[92mIran\e[93m Private ip address: \e[0m' iran_ipv6
    read -e -p $'\e[93mEnter Tunnel \e[92mToken\e[93m:[Same value for Kharej & Iran] \e[0m' frp_token
    read -e -p $'\e[93mEnter \e[92mTunnel\e[93m Port:[Example: 443] \e[0m' tunnel_port

rm frp_0.52.3_linux_amd64/frpc.ini
rm frp_0.52.3_linux_arm64/frpc.ini
# frpc.ini 
# CPU architecture
if [[ "$(uname -m)" == "x86_64" ]]; then
  cpu_arch="amd64"
elif [[ "$(uname -m)" == "aarch64" ]]; then
  cpu_arch="arm64"
else
  echo -e "\e[93mUnsupported CPU architecture.\e[0m"
  exit 1
fi
    cat > frp_0.52.3_linux_$cpu_arch/frpc.ini <<EOL
[common]
server_addr = $iran_ipv6
server_port = $tunnel_port
authentication_mode = token
token = $frp_token

EOL

    for ((i=1; i<=$num_ipv6; i++)); do
        read -e -p $'\e[93mEnter your \e[92mKharej '$i$'th \e[93mPrivate ip address:\e[0m ' kharej_ipv6
        read -e -p $'\e[93mEnter \e[92mKharej\e[93m Wireguard port:\e[0m\e[92m[This is your current Wireguard port]\e[0m ' kharej_port
        read -e -p $'\e[93mEnter \e[92mIran\e[93m Wireguard port:\e[0m\e[92m[This will be your new Wireguard port]\e[0m ' iran_port
 printf "\e[93m╰────────────────────────────────────────────────────────────╯\e[0m\n"
    
        cat >> frp_0.52.3_linux_$cpu_arch/frpc.ini <<EOL

[wireguard$i]
type = udp
local_port = $kharej_port
remote_port = $iran_port
local_ip$i = $kharej_ipv6
use_encryption = true
use_compression = true

EOL
    done

    display_checkmark $'\e[92mKharej configuration generated. Yours Truly, Azumi.\e[0m'
#service section for Kharej
    cat > /etc/systemd/system/azumifrpc.service <<EOL
[Unit]
Description=frpc service
After=network.target

[Service]
ExecStart=/root/frp_0.52.3_linux_$cpu_arch/./frpc -c /root/frp_0.52.3_linux_$cpu_arch/frpc.ini
Restart=always
RestartSec=10
User=root

[Install]
WantedBy=multi-user.target
EOL
echo "Reloading daemon..." > /dev/null 2>&1
    systemctl daemon-reload > /dev/null 2>&1

    echo "Enabling FRP service..." > /dev/null 2>&1
    systemctl enable azumifrpc > /dev/null 2>&1

    echo "Starting FRP  service..."
    systemctl restart azumifrpc
    res_lk
    display_checkmark $'\e[92mFRP Service started.\e[0m'
}

function frpp_iran_menu() {
    clear
    
    echo $'\e[92m ^ ^\e[0m'
    echo $'\e[92m(\e[91mO,O\e[92m)\e[0m'
    echo $'\e[92m(   ) \e[93mFRP Iran Tunnel\e[0m'
    echo $'\e[92m "-"\e[93m═══════════════════════════════\e[0m'
    printf "\e[93m╭──────────────────────────────────────────────────────╮\e[0m\n"
    read -e -p $'\e[93mHow many \e[92mIran \e[93mPrivate ip address do you have: \e[0m' num_ipv6
    sleep 1
    echo "Generating Iran Config for you..."
    read -e -p $'\e[93mEnter \e[92mTunnel Port\e[93m:[Example: \e[92m443\e[93m] \e[0m' tunnel_port
    read -e -p $'\e[93mEnter \e[92mTunnel Token\e[93m:[\e[93mSame Value for both Kharej & Iran\e[93m] \e[0m' token
    
    echo -e "\e[93mGenerating config for you...\e[0m"
    rm frp_0.52.3_linux_amd64/frps.ini
    rm frp_0.52.3_linux_arm64/frps.ini
    # frps.ini
	# CPU architecture
if [[ "$(uname -m)" == "x86_64" ]]; then
  cpu_arch="amd64"
elif [[ "$(uname -m)" == "aarch64" ]]; then
  cpu_arch="arm64"
else
  echo -e "\e[93mUnsupported CPU architecture.\e[0m"
  exit 1
fi
    cat > frp_0.52.3_linux_$cpu_arch/frps.ini <<EOL
[common]
bind_port = $tunnel_port
token = $token

EOL

for ((i=1; i<=$num_ipv6; i++)); do
        read -e -p $'\e[93mEnter your \e[92mIran '$i$'th \e[93mPrivate ip address:\e[0m ' iran_ipv6
        read -e -p $'\e[93mEnter \e[92mKharej\e[93m Wireguard port:\e[0m\e[92m[This is your current Wireguard port]\e[0m ' kharej_wireguard_port
        read -e -p $'\e[93mEnter \e[92mIran\e[93m Wireguard port:\e[0m\e[92m[This will be your new Wireguard port]\e[0m ' iran_wireguard_port
 
    printf "\e[93m╰──────────────────────────────────────────────────────╯\e[0m\n"
        cat >> frp_0.52.3_linux_$cpu_arch/frps.ini <<EOL
[wireguard$i]
type = tcp
local_ip$i = $iran_ipv6
local_port = $iran_wireguard_port
remote_port = $kharej_wireguard_port
use_encryption = true
use_compression = true

EOL
    done

    display_checkmark $'\e[92mIran configuration generated. Yours Truly, Azumi.\e[0m'
# Add the service section for Kharej
    cat > /etc/systemd/system/azumifrps.service <<EOL
[Unit]
Description=frps service
After=network.target

[Service]
ExecStart=/root/frp_0.52.3_linux_$cpu_arch/./frps -c /root/frp_0.52.3_linux_$cpu_arch/frps.ini
Restart=always
RestartSec=10
User=root

[Install]
WantedBy=multi-user.target
EOL
echo "Reloading daemon..." > /dev/null 2>&1
    systemctl daemon-reload > /dev/null 2>&1

    echo "Enabling FRP service..." > /dev/null 2>&1
    systemctl enable azumifrps > /dev/null 2>&1

    echo "Starting FRP  service..."
    systemctl restart azumifrps
    res_li
    display_checkmark $'\e[92mFRP Service started.\e[0m'
}
function restart_service() {
    clear
    echo $'\e[92m ^ ^\e[0m'
    echo $'\e[92m(\e[91mO,O\e[92m)\e[0m'
    echo $'\e[92m(   ) \e[93mRestart Menu\e[0m'
    echo $'\e[92m "-"\e[93m═════════════════════\e[0m'
	echo ""
	printf "\e[93m╭───────────────────────────────────────╮\e[0m\n"
    echo $'\e[93mSelect what to Restart:\e[0m'
    echo $'1. \e[93mFRP\e[0m'
    echo $'2. \e[91mUDP2raw\e[0m'
    echo $'3. \e[94mback to main menu\e[0m'
	printf "\e[93m╰───────────────────────────────────────╯\e[0m\n"
    read -e -p $'\e[38;5;205mEnter your choice Please: \e[0m' server_type
    case $server_type in
        1)
            frpp_menu
            ;;
        2)
            udpp_menu
            ;;
        3)
            clear
            main_menu
            ;;
        *)
            echo "Invalid choice."
            ;;
    esac
}

function frpp_menu() {
    # Check 1
    systemctl daemon-reload
    systemctl restart azumifrpc.service > /dev/null 2>&1

    # Check 2
    systemctl restart azumifrps.service > /dev/null 2>&1
    display_checkmark $'\e[92mFRP Service restarted.\e[0m'

    
    echo "╭───────────────────────────────────────────╮"
    echo "│         Services Restarted                │"
    echo "│    services have been restarted!          │"
    echo "╰───────────────────────────────────────────╯"
}

function udpp_menu() {
    # Check 3
    systemctl restart azumi-udp2rawc.service > /dev/null 2>&1

    # Check 4
    systemctl restart azumi-udp2raws.service > /dev/null 2>&1
    display_checkmark $'\e[92mUDP2RAW Service restarted.\e[0m'

    
    echo "╭───────────────────────────────────────────╮"
    echo "│         Services Restarted                │"
    echo "│    services have been restarted!          │"
    echo "╰───────────────────────────────────────────╯"
}
# status
function display_service_status() {
   sudo systemctl is-active azumifrpc.service &>/dev/null
  local frpc_status=$?
  if [[ $frpc_status -eq 0 ]]; then
    frpc_status_msg="\e[92m\xE2\x9C\x94 FRP Kharej service is running\e[0m"
  else
    frpc_status_msg="\e[91m\xE2\x9C\x98 FRP Kharej service is not running\e[0m"
  fi

  sudo systemctl is-active azumifrps.service &>/dev/null
  local frps_status=$?
  if [[ $frps_status -eq 0 ]]; then
    frps_status_msg="\e[92m\xE2\x9C\x94 FRP Iran service is running\e[0m"
  else
    frps_status_msg="\e[91m\xE2\x9C\x98 FRP Iran service is not running\e[0m"
  fi

  # FRP service status
  printf "\e[93m╭───────────────────────────────────────╮\e[0m\n"
  printf "\e[93m  %-35b \e[0m\n" "$frpc_status_msg"     
  printf "\e[93m  %-35b \e[0m\n" "$frps_status_msg"
  printf "\e[93m╰───────────────────────────────────────╯\e[0m\n"
}
# status 2
function display_service_statuss() {
   sudo systemctl is-active azumi-udp2raws.service &>/dev/null
  local udp2raws_status=$?
  if [[ $udp2raws_status -eq 0 ]]; then
    udp2raws_status_msg="\e[92m\xE2\x9C\x94 udp2raw Kharej is running\e[0m"
  else
    udp2raws_status_msg="\e[91m\xE2\x9C\x98 udp2raw Kharej is not running\e[0m"
  fi

  sudo systemctl is-active azumi-udp2rawc.service &>/dev/null
  local udp2rawc_status=$?
  if [[ $udp2rawc_status -eq 0 ]]; then
    udp2rawc_status_msg="\e[92m\xE2\x9C\x94 udp2raw Iran service is running\e[0m"
  else
    udp2rawc_status_msg="\e[91m\xE2\x9C\x98 udp2raw Iran is not running\e[0m"
  fi

  # UDP2raw service status
  printf "\e[93m╭───────────────────────────────────────╮\e[0m\n"
  printf "\e[93m  %-35b \e[0m\n" "$udp2raws_status_msg"  
  printf "\e[93m  %-35b \e[0m\n" "$udp2rawc_status_msg"
  printf "\e[93m╰───────────────────────────────────────╯\e[0m\n"
}
function uninstall() {
    clear
    echo +══════════════════════════+
    echo -e "\e[93mUninstall Menu\e[0m"
    echo +══════════════════════════+
  echo $'\e[93mSelect what to uninstall:\e[0m'
  echo $'1. \e[92mPrivate IP\e[0m'
  echo $'2. \e[93mFRP\e[0m'
  echo $'3. \e[91mUDP2raw\e[0m'
  echo $'4. \e[94mback to main menu\e[0m'
  read -e -p $'\e[38;5;205mEnter your choice Please: \e[0m' server_type
case $server_type in
        1)
            pri_uninstall_menu
            ;;
        2)
            frp_uninstall_menu
            ;;
		3)  
		    udp_uninstall_menu
            ;;		
        4)
            clear            
            main_menu
            ;;
        *)
            echo "Invalid choice."
            ;;
    esac
}
function udp_uninstall_menu() {
    clear
    echo "Uninstalling UDP2raw..."
    systemctl stop --now "azumi-udp2raws.service" > /dev/null 2>&1
    systemctl disable --now "azumi-udp2raws.service" > /dev/null 2>&1
    systemctl stop --now "azumi-udp2rawc.service" > /dev/null 2>&1
    systemctl disable --now "azumi-udp2rawc.service" > /dev/null 2>&1
    rm -f /etc/systemd/system/azumi-udp2raws.service > /dev/null 2>&1
    rm -f /etc/systemd/system/azumi-udp2rawc.service > /dev/null 2>&1
	
	    echo -n "Progress: "

    # Loading bar
  cute_animation=("💖      "
                    "💖💖    "
                    "💖💖💖  "
                    "💖💖💖💖"
                    " 💖💖💖 "
                    "  💖💖  "
                    "   💖   ")


    # Process
    for i in $(seq 1 7); do
        echo -ne "\r[${cute_animation[i-1]}]"
        sleep 0.5
    done
	display_checkmark $'\e[92mUDP2raw removed successfully!\e[0m'
}	
function frp_uninstall_menu() {
    clear
    echo "Uninstalling FRP..."
    rmve_cron
    # Stop and disable azumifrps.service
    if systemctl is-active --quiet azumifrps; then
        systemctl stop azumifrps > /dev/null 2>&1
        systemctl disable azumifrps > /dev/null 2>&1  
    fi

    # Stop and disable azumifrpc.service
    if systemctl is-active --quiet azumifrpc; then
        systemctl stop azumifrpc > /dev/null 2>&1
        systemctl disable azumifrpc > /dev/null 2>&1  
    fi

    # Remove azumifrps.service file
    if rm /etc/systemd/system/azumifrps.service 2>/dev/null; then
        display_checkmark $'\e[92mService removed.\e[0m'
    else
        echo -e "\e[91mFailed to remove azumifrps.service.\e[0m"
    fi

    # Remove azumifrpc.service file
    if rm /etc/systemd/system/azumifrpc.service 2>/dev/null; then
        display_checkmark $'\e[92mService removed.\e[0m'
    else
        echo -e "\e[91mFailed to remove azumifrpc.service.\e[0m"
    fi

    # symbolic
    if rm /etc/systemd/system/multi-user.target.wants/azumifrps.service 2>/dev/null; then
        display_checkmark $'\e[92mSymbolic link removed.\e[0m' 
    else
        echo -e "\e[91mFailed to remove symbolic link for azumifrps.service.\e[0m"
    fi

    if rm /etc/systemd/system/multi-user.target.wants/azumifrpc.service 2>/dev/null; then
        display_checkmark $'\e[92mSymbolic link removed.\e[0m'
    else
        echo -e "\e[91mFailed to remove symbolic link for azumifrpc.service.\e[0m"
    fi

    echo "Removing FRP, Working in the background..."
    echo -n "Progress: "

    # Loading bar
 cute_animation=("💖      "
                    "💖💖    "
                    "💖💖💖  "
                    "💖💖💖💖"
                    " 💖💖💖 "
                    "  💖💖  "
                    "   💖   ")


    # Process
    for i in $(seq 1 7); do
        echo -ne "\r[${cute_animation[i-1]}]"
        sleep 0.5
    done

    echo -e "\e[92m\nFRP uninstalled.\e[0m"
}
function pri_uninstall_menu() {
    echo -e "\e[93mRemoving private IP addresses...\e[0m"
    if [ -f "/etc/private.sh" ]; then
        rm /etc/private.sh
    fi

        display_notification $'\e[93mRemoving cron job..\e[0m'
    crontab -l | grep -v "@reboot /bin/bash /etc/private.sh" | crontab -
    sleep 1
		systemctl disable ping_v6.service > /dev/null 2>&1
        systemctl stop ping_v6.service > /dev/null 2>&1
		rm /etc/systemd/system/ping_v6.service > /dev/null 2>&1
        sleep 1

    systemctl daemon-reload

    ip link set dev azumi down > /dev/null
    ip tunnel del azumi > /dev/null

        echo -n "Progress: "

    # Loading bar
  cute_animation=("💖      "
                    "💖💖    "
                    "💖💖💖  "
                    "💖💖💖💖"
                    " 💖💖💖 "
                    "  💖💖  "
                    "   💖   ")


    # Process
    for i in $(seq 1 7); do
        echo -ne "\r[${cute_animation[i-1]}]"
        sleep 0.5
    done
    display_checkmark $'\e[92mPrivate IP removed successfully!\e[0m'
}
# Call the main_menu function
main_menu
