# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#
# ZSH_THEME="gallois"
ZSH_THEME="robbyrussell"
RPS1='[$(ruby_prompt_info)]$EPS1'

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
plugins=(gitfast rbenv last-working-dir sublime brew zsh-syntax-highlighting zsh-history-substring-search)

source $ZSH/oh-my-zsh.sh
export PATH='./bin:/usr/local/bin:/usr/local/var/rbenv/shims:/usr/local/share:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/local/sbin:/usr/local/share/npm/bin:/usr/X11/bin:/usr/texbin:~/bin'

# Disable auto update of title name (for tmux, see http://superuser.com/a/320316)
DISABLE_AUTO_TITLE=true

# Disable zsh correction
unsetopt correct_all

# To use Homebrew's directories rather than ~/.rbenv
export RBENV_ROOT=/usr/local/var/rbenv

# To enable shims and autocompletion add to your profile:
# if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# Docker
$(boot2docker shellinit 2>/dev/null)

# Gather handy aliases
[[ -f "$HOME/.aliases" ]] && source "$HOME/.aliases"

# Enhance history
bindkey '^[OA' history-substring-search-up
bindkey '^[OB' history-substring-search-down

# UTF-8 is our default encoding
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# AWS Command line
source /usr/local/share/zsh/site-functions/_aws
