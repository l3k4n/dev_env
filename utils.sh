INFORM_COLOR="\033[1;34m"
WARNING_COLOR="\033[1;33m"
ERROR_COLOR="\033[1;31m"
NOTE_COLOR="\033[0;34m"
QUERY_COLOR="\033[0;35m"
RESET_COLOR="\033[0m"
PROGRESS_SPINNER="⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏"

inform() { echo -e "\n${INFORM_COLOR}$@${RESET_COLOR}"; }
warn() { echo -e "\n${WARNING_COLOR}WARNING: $@${RESET_COLOR}"; }
error() {
    echo -e "\n${ERROR_COLOR}ERROR: $@${RESET_COLOR}"
    exit
}
note() { echo -e "${NOTE_COLOR}> $@${RESET_COLOR}"; }

silent_exec() {
    msg=$(bash -c "$*" 2>&1 > /dev/null)
    if [ $? -ne 0 ]; then error "$msg"; fi
}

query() {
    echo -ne "\n${QUERY_COLOR}$@ (y/n): ${RESET_COLOR}"
    read -r response

    if [[ "$response" =~ ^[Yy]$ ]]; then
        return 0 
    else
        return 1
    fi
}

apt_install() {
    note "apt installing: $*"
    silent_exec sudo apt-get install -y $*
}

git_clone() {
    GIT_TERMINAL_PROMPT=0
    note "git cloning: $@"
    silent_exec "git clone $*"
    GIT_TERMINAL_PROMPT=1
}

bashrc_append () {
    if ! grep -q "$@" ~/.bashrc; then echo "$@" >> ~/.bashrc; fi
}
