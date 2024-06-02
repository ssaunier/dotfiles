ZSH=$HOME/.oh-my-zsh

ZSH_THEME="robbyrussell"

# Useful plugins for Rails development with Sublime Text
plugins=(last-working-dir common-aliases sublime zsh-syntax-highlighting history-substring-search)

# Prevent Homebrew from reporting - https://github.com/Homebrew/brew/blob/master/share/doc/homebrew/Analytics.md
export HOMEBREW_NO_ANALYTICS=1

# Actually load Oh-My-Zsh
source "${ZSH}/oh-my-zsh.sh"
unalias lt # we need `lt` for https://github.com/localtunnel/localtunnel
unalias rm # No interactive rm by default, disable https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/common-aliases/common-aliases.plugin.zsh#L49

# GPG
export GPG_TTY=$(tty)

# Latex
export PATH="${PATH}:/usr/local/texlive/2016/bin/x86_64-darwin"

# Go
export PATH=$PATH:$(go env GOPATH)/bin

# Load rbenv (Ruby version manager)
type -a rbenv > /dev/null && eval "$(rbenv init -)" && RPROMPT+='[💎 $(rbenv version-name)]'

# ruby-build installs a non-Homebrew OpenSSL for each Ruby version installed and these are never upgraded. Linking Rubies to Homebrew's OpenSSL 1.1 (which is upgraded):
export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"

# Python
init_pyenv() {
  type -a pyenv > /dev/null && eval "$(pyenv init -)" && eval "$(pyenv virtualenv-init -)" && RPROMPT+='[🐍 $(pyenv version-name)]'
  export PYENV_VIRTUALENV_DISABLE_PROMPT=1
}

# Node
export NVM_DIR="$HOME/.nvm"
init_nvm() {
  [ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

  # Call `nvm use` automatically in a directory with a `.nvmrc` file
  autoload -U add-zsh-hook
  load-nvmrc() {
    local node_version="$(nvm version)"
    local nvmrc_path="$(nvm_find_nvmrc)"

    if [ -n "$nvmrc_path" ]; then
      local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

      if [ "$nvmrc_node_version" = "N/A" ]; then
        nvm install
      elif [ "$nvmrc_node_version" != "$node_version" ]; then
        nvm use --silent
      fi
    elif [ "$node_version" != "$(nvm version default)" ]; then
      nvm use default --silent
    fi
  }
  add-zsh-hook chpwd load-nvmrc
  load-nvmrc
  RPROMPT+='[ $(nvm version | sed "s/^v//" )]'
}

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
