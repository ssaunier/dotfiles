ZSH=$HOME/.oh-my-zsh

ZSH_THEME="robbyrussell"
# SPACESHIP_VENV_SHOW=false
# ZSH_THEME="spaceship"

# Useful plugins for Rails development with Sublime Text
plugins=(last-working-dir common-aliases sublime docker-compose zsh-syntax-highlighting history-substring-search)

# Prevent Homebrew from reporting - https://github.com/Homebrew/brew/blob/master/share/doc/homebrew/Analytics.md
export HOMEBREW_NO_ANALYTICS=1

# Actually load Oh-My-Zsh
source "${ZSH}/oh-my-zsh.sh"
unalias rm # No interactive rm by default, disable https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/common-aliases/common-aliases.plugin.zsh#L49

# Latex
export PATH="${PATH}:/usr/local/texlive/2016/bin/x86_64-darwin"

# Load rbenv (Ruby version manager)
type -a rbenv > /dev/null && eval "$(rbenv init -)"

# Load pyenv (Python version manager)
type -a pyenv > /dev/null && eval "$(pyenv init -)" && eval "$(pyenv virtualenv-init -)"

# Load 'lewagon' virtualenv for the Data Bootcamp
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
# pyenv activate lewagon 2>/dev/null && echo "🐍 Loading 'lewagon' virtualenv"

# # Anaconda binaries
# export PATH="${HOME}/anaconda3/bin:${PATH}"

# Load nvm (Node)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Rails and Ruby uses the local `bin` folder to store binstubs.
# So instead of running `bin/rails` like the doc says, just run `rails`
# Same for `./node_modules/.bin` and nodejs
export PATH="./bin:./node_modules/.bin:${PATH}"

# Store your own aliases in the ~/.aliases file and load the here.
[[ -f "$HOME/.aliases" ]] && source "$HOME/.aliases"

# Encoding stuff for the terminal
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# `bundle open` with Sublime Text
export BUNDLER_EDITOR="'/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl'"
