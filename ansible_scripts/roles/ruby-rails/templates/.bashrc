if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
