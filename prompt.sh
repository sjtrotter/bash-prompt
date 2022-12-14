# available options (copy/paste in, with spaces between): USERATHOST USERNAME HOST VTY DIR $(if [[ SSH_CLIENT ]]; then printf "SSH"; fi)

PROMPT_ORDER="USERNAME AT HOST $(if [[ $SSH_CLIENT ]]; then printf "SSH"; fi) DIR"

# Other Examples
# PROMPT_ORDER="USERATHOST DIR"
# PROMPT_ORDER="VTY HOST DIR"

function prompt () {
    rc=$?
    if [[ $TERM == "linux" || $(tput colors) -eq 8 || $SSH_CLIENT ]]; then
        # assume unsupported chars over ANSI/512
        # and SSH clients are unpredictable.
        BAR_COLOR="\001\033[97m\002"
        DIR_FG="\001\033[0m\002"
        DIR_BG="\001\033[95m\002"
        DIR_FG_BG="\001\033[0m\002"
        VTY_FG="\001\033[0m\002"
        VTY_BG="\001\033[90m\002"
        VTY_FG_BG="\001\033[0m\002"
        AT_FG="\001\033[0m\002"
        AT_BG="\001\033[90m\002"
        AT_FG_BG="\001\033[0m\002"
        SSH_FG="\001\033[0m\002"
        SSH_BG="\001\033[93m\002"
        SSH_FG_BG="\001\033[0m\002"
        HOST_FG="\001\033[0m\002"
        HOST_BG="\001\033[94m\002"
        HOST_FG_BG="\001\033[0m\002"
        USERNAME_FG="\001\033[0m\002"
        USERNAME_BG="\001\033[$(if [[ $UID -eq 0 ]]; then printf 91; else printf 92; fi)m\002"
        USERNAME_FG_BG="\001\033[0m\002"
        USERATHOST_FG="\001\033[0m\002"
        USERATHOST_BG="\001\033[$(if [[ $UID -eq 0 ]]; then printf 91; else printf 92; fi)m\002"
        USERATHOST_FG_BG="\001\033[0m\002"
        OPEN_CHAR="<<"
        OPEN_CHAR_FILL="["
        CLOSE_CHAR=">>"
        CLOSE_CHAR_FILL="]"
        DIR_CHAR="/"
        REV="\001\033[7m\002"
        BOLD="\001\033[1m\002"
        CLEAR="\001\033[0m\002"
        RED="\001\033[91m\002"
        GREEN="\001\033[92m\002"
    else
        # assume unicode support
        BAR_COLOR="\001$(tput setaf 15)\002"
        DIR_FG="\001$(tput setaf 99)\002"
        DIR_BG="\001$(tput setab 15)\002"
        DIR_FG_BG="\001$(tput setab 99)\002"
        VTY_FG="\001$(tput setaf 237)\002"
        VTY_BG="\001$(tput setab 15)\002"
        VTY_FG_BG="\001$(tput setab 237)\002"
        AT_FG="\001$(tput setaf 237)\002"
        AT_BG="\001$(tput setab 15)\002"
        AT_FG_BG="\001$(tput setab 237)\002"
        SSH_FG="\001$(tput setaf 226)\002"
        SSH_BG="\001$(tput setab 15)\002"
        SSH_FG_BG="\001$(tput setab 226)\002"
        HOST_FG="\001$(tput setaf 33)\002"
        HOST_BG="\001$(tput setab 15)\002"
        HOST_FG_BG="\001$(tput setab 33)\002"
        USERNAME_FG="\001$(tput setaf $(if [[ $UID -eq 0 ]]; then printf 196; else printf 34; fi))\002"
        USERNAME_BG="\001$(tput setab 15)\002"
        USERNAME_FG_BG="\001$(tput setab $(if [[ $UID -eq 0 ]]; then printf 196; else printf 34; fi))\002"
        USERATHOST_FG="\001$(tput setaf $(if [[ $UID -eq 0 ]]; then printf 196; else printf 34; fi))\002"
        USERATHOST_BG="\001$(tput setab 15)\002"
        USERATHOST_FG_BG="\001$(tput setab $(if [[ $UID -eq 0 ]]; then printf 196; else printf 34; fi))\002"
        OPEN_CHAR='\U0e0b3'
        OPEN_CHAR_FILL="\U0e0b2"
        DIR_CHAR="\Ue0b1"
        CLOSE_CHAR="\U0e0b1"
        CLOSE_CHAR_FILL="\U0e0b0"
        REV="\001$(tput rev)\002"
        BOLD="\001$(tput bold)\002"
        CLEAR="\001$(tput sgr0)\002"
        RED="\001$(tput setaf 124)\002"
        GREEN="\001$(tput setaf 118)\002"
    fi

    TPUT_ORANGE=$(($(tput colors) < 256 ? 3 : 208))

    #TOP_BAR="\U0250c\U02500"
    TOP_BAR="${BOLD}\U2500"
    #BOT_BAR="\U02514\U02500"
    BOT_BAR="\U02514${BOLD}$(if [[ $rc == 0 ]]; then printf ${GREEN}; else printf ${RED}; fi)${OPEN_CHAR}${CLOSE_CHAR}${CLEAR}"

    dirs=($(pwd | sed "s|$HOME|~|g" | cut -d "/" -f 1- --output-delimiter=" "))
    if [[ "${dirs[0]}" == "" ]]; then dirs[0]="/"; fi
    DIR_START="${dirs[0]}"
    unset dirs[0]
    DIR="${DIR_FG}${DIR_BG}${BOLD} ${DIR_START} "
    for dir in "${dirs[@]}"; do
        DIR="${DIR}${DIR_CHAR} ${dir} "
    done

    usr="$USER"
    USERNAME="${USERNAME_FG}${USERNAME_BG}${BOLD} ${usr} "

    host=$(hostname)
    HOST="${HOST_FG}${HOST_BG}${BOLD} ${host} "

    AT="${AT_FG}${AT_BG}${BOLD} @ "

    vty=$(tty | sed 's|/dev/||g')
    VTY="${VTY_FG}${VTY_BG}${BOLD} ${vty} "

    ssh=$(if [[ $SSH_CLIENT ]]; then printf "$SSH_CLIENT" | cut -d '=' -f 2 | awk '{print $1'}; else printf ""; fi)
    SSH="${SSH_FG}${SSH_BG}${BOLD} ${ssh} "

    PROMPT_START="${BAR_COLOR}${BOLD}${TOP_BAR}${OPEN_CHAR}"
    #printf "${PROMPT_START}${PATH_FG}${OPEN_CHAR_FILL}${REV}${DIR}${CLEAR}${PATH_FG}${CLOSE_CHAR_FILL}${CLEAR}${BOLD}${CLOSE_CHAR}\n${BOLD}${BAR_COLOR}${BOT_BAR} \n"
#${fg}${OPEN_CHAR_FILL}
    PROMPT="${PROMPT_START}"
    first=1
    fgbg=
    for section in ${PROMPT_ORDER}; do
        LAST_FG=$fg
        LAST_BG=$bg
        LAST_FG_BG=$fgbg
        fg="${section}_FG"; fg="${!fg}"
        bg="${section}_BG"; bg="${!bg}"
        fgbg="${section}_FG_BG"; fgbg="${!fgbg}"
        txt="${!section}"
        if [[ ${first} -eq 1 || "${section}" == "AT" ]]; then
            PROMPT="${PROMPT}${fg}${LAST_FG_BG}${OPEN_CHAR_FILL}"
            first=0
        else
            PROMPT="${PROMPT}${LAST_FG_BG}${REV}${fg}${CLOSE_CHAR_FILL}"
        fi
        PROMPT="${PROMPT}${REV}${txt}${CLEAR}"
    done
    PROMPT="${PROMPT}${fg}${CLOSE_CHAR_FILL}${CLEAR}${BOLD}$(if [[ $rc == 0 ]]; then printf ${GREEN}; else printf ${RED}; fi)${CLOSE_CHAR}"
    PS1=$(printf "${PROMPT}${CLEAR} ")
    #PS1="${PROMPT}${CLEAR} "
    PS0="\$(tput cuu 1; tput cuf $(tput cols); tput cub 20; printf ' @ [';)$(tput setaf $TPUT_ORANGE)\D{%F %H:%M}$(tput sgr0)]\n"
    # PS1="$(printf "\U02514")\[${BOLD}$(if [[ $rc == 0 ]]; then printf ${GREEN}; else printf ${RED}; fi)\]\[$(printf "${OPEN_CHAR}${CLOSE_CHAR}")\]\[${CLEAR}\]"
}

PROMPT_COMMAND=prompt
