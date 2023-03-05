#! /bin/bash

source ./config/settings.sh
source ./config/createDump.sh
source ./config/loadDump.sh

########################## Main Functions  #############################

function open_setting {
  nano ./config/settings.sh
}

function open_logfile_createDump {
  nano ./logs/logs_createDump
}

function open_logfile_loadDump {
  nano ./logs/logs_loadDump
}

function exit_menu {
  exit
}

function generate_pass {
    grep -e "DB_USER_PASS" ./config/settings.sh
    passwd="$(openssl rand -hex 24)"
    sed -i "s/DB_USER_PASS=.*/DB_USER_PASS="\'$passwd\'"/" ./config/settings.sh
    grep -e "DB_USER_PASS" ./config/settings.sh
}

########################## Functions for Menu #############################
function select_option {
    ESC=$( printf "\033")
    cursor_blink_on()  { printf "$ESC[?25h"; }
    cursor_blink_off() { printf "$ESC[?25l"; }
    cursor_to()        { printf "$ESC[$1;${2:-1}H"; }
    print_option()     { printf "   $1 "; }
    print_selected()   { printf "  $ESC[7m $1 $ESC[27m"; }
    get_cursor_row()   { IFS=';' read -sdR -p $'\E[6n' ROW COL; echo ${ROW#*[}; }
    key_input()        { read -s -n3 key 2>/dev/null >&2
                         if [[ $key = $ESC[A ]]; then echo up;    fi
                         if [[ $key = $ESC[B ]]; then echo down;  fi
                         if [[ $key = ""     ]]; then echo enter; fi; }

    for opt; do printf "\n"; done

    local lastrow=`get_cursor_row`
    local startrow=$(($lastrow - $#))

    trap "cursor_blink_on; stty echo; printf '\n'; exit" 2
    cursor_blink_off

    local selected=0
    while true; do
        local idx=0
        for opt; do
            cursor_to $(($startrow + $idx))
            if [ $idx -eq $selected ]; then
                print_selected "$opt"
            else
                print_option "${GREEN}$opt${NC}"
            fi
            ((idx++))
        done

        case `key_input` in
            enter) break;;
            up)    ((selected--));
                   if [ $selected -lt 0 ]; then selected=$(($# - 1)); fi;;
            down)  ((selected++));
                   if [ $selected -ge $# ]; then selected=0; fi;;
        esac
    done

    cursor_to $lastrow
    printf "\n"
    cursor_blink_on

    return $selected
}


################################# Menu #################################
function main {
    options=("➜ Create Dump" "➜ Load Dump" "➜ Edit Settings" "✚ Open Logs" "➜ Generate Password" "✖ Exit Menu") 

    select_option "${options[@]}"
    selected=$?

    if [ "$selected" = "0" ]; then
        create_dump
    elif [ "$selected" = "1" ]; then
        load_dump
    elif [ "$selected" = "2" ]; then
        open_setting
    elif [ "$selected" = "3" ]; then
            logs_options=("➜ Open logfile CreateDump" "➜ Open logfile LoadDump" "⬅ Back" "✖ Exit Menu")
            select_option "${logs_options[@]}"
            log_selected=$?
            if [ "$log_selected" = "0" ]; then
                open_logfile_createDump
            elif [ "$log_selected" = "1" ]; then
                open_logfile_loadDump
            elif [ "$log_selected" = "2" ]; then
                main
            elif [ "$log_selected" = "4" ]; then
                exit_menu
            fi
    elif [ "$selected" = "4" ]; then
        generate_pass
    elif [ "$selected" = "5" ]; then
        exit_menu
    fi
}

main