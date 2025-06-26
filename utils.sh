INFORM_COLOR="\033[1;34m"
WARNING_COLOR="\033[1;33m"
ERROR_COLOR="\033[1;31m"
NOTE_COLOR="\033[0;34m"
QUERY_COLOR="\033[0;35m"
RESET_COLOR="\033[0m"
TMP_INSTALL_DIR=$(mktemp -d)

print_boxed() {
  local text="$@"
  local len=${#text}
  local horizontal=$(printf '═%.0s' $(seq 1 $((len + 2))))

  echo -e "╔$horizontal╗"
  echo -e "║ $text ║"
  echo -e "╚$horizontal╝"


  # # use below in case of font compatibility
  # local len=${#text}
  # local border=$(printf '%*s' $((len + 4)) '' | tr ' ' '*')
  # echo "$border"
  # echo "* $text *"
  # echo "$border"
}

under_over_line() {
  local text="$1"
  local text_length=${#text}
  local line=""

  # Generate a line of tildes matching the text length
  for (( i=0; i<text_length; i++ )); do
    line="${line}~"
  done

  echo "$line"
  echo "$text"
  echo "$line"
}


inform() {
    printf $INFORM_COLOR
    print_boxed "$@"
    printf $RESET_COLOR
}

error() {
    echo -e "\n${ERROR_COLOR}ERROR: $@${RESET_COLOR}"
    exit
}

note() {
    echo -e "${NOTE_COLOR}> $@${RESET_COLOR}"
}

warn() {
    printf $WARNING_COLOR
    print_boxed "\n*** WARNING: $@ ***"
    printf $RESET_COLOR
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
    sudo apt-get install -qq -y $*
}

apt_install_no_recommends() {
    note "apt installing: $*"
    sudo apt-get install -qq -y --no-install-recommends $*
}

git_clone() {
    GIT_TERMINAL_PROMPT=0
    note "git cloning: $@"
    git clone -q $*
    GIT_TERMINAL_PROMPT=1
}

bashrc_append () {
    if ! grep -q "$@" ~/.bashrc; then echo "$@" >> ~/.bashrc; fi
}
