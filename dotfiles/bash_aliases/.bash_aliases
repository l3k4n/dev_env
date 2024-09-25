dev_cmd() {
	if [[ "$1" == "" ]]; then
		cd "~/dev"
	elif [[ "$1" == "-x" ]]; then
		cd ~/dev/"$2"
	else
		cd ~/dev/"$1"
		nvim
	fi
}

alias dev='dev_cmd'

alias python="python3"
alias pip="pip3"
