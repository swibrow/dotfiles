# Only run on macOS

if [[ $(uname) == "Darwin" ]]; then
	if [[ $(uname -m) == "x86_64" ]]; then
		eval "$(/opt/local/bin/brew shellenv)"
	else
		eval "$(/opt/homebrew/bin/brew shellenv)"
	fi
fi

# Only run these on Ubuntu

if [[ $(grep -E "^(ID|NAME)=" /etc/os-release | grep -q "ubuntu")$? == 0 ]]; then
	# needed for brew to work
	eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

if [ -r ~/.bashrc ]; then
	source ~/.bashrc
fi

export XDG_CONFIG_HOME="$HOME"/.config
