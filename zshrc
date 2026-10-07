# zsh for the Refrag Coder workspace: no framework, the built-in completion system plus
# zsh-autosuggestions, zsh-syntax-highlighting and fzf (installed from apt).

export PATH="$HOME/.local/bin:./bin:./node_modules/.bin:$PATH"
export EDITOR=vim VISUAL=vim
export LANG=C.UTF-8

# The workspace exports the Coder account email as GIT_AUTHOR_EMAIL / GIT_COMMITTER_EMAIL,
# which beats any gitconfig. Drop them so ~/.gitconfig decides.
unset GIT_AUTHOR_NAME GIT_AUTHOR_EMAIL GIT_COMMITTER_NAME GIT_COMMITTER_EMAIL

# GH_TOKEN / GITHUB_PERSONAL_ACCESS_TOKEN, written by the workspace startup script.
[[ -f "$HOME/.config/refrag/mcp.env" ]] && source "$HOME/.config/refrag/mcp.env"

[[ -f "$HOME/.aliases" ]] && source "$HOME/.aliases"

[[ -o interactive ]] || return

HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt share_history hist_ignore_all_dups hist_ignore_space hist_reduce_blanks
setopt auto_cd auto_pushd pushd_ignore_dups interactive_comments no_beep

# Completion: menu you can arrow through, case-insensitive and partial-word matching,
# coloured like ls, grouped with headers.
fpath=("$HOME/.zsh/completions" $fpath)
autoload -Uz compinit && compinit -d "$HOME/.zcompdump"
zmodload zsh/complist
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$HOME/.zsh/cache"
bindkey -M menuselect '^[[Z' reverse-menu-complete

# Up/down search history by what is already typed.
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search '^[OA' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search '^[OB' down-line-or-beginning-search
bindkey -e

# Prompt in the spirit of oh-my-zsh's robbyrussell: ➜ dir git:(branch) ✗
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' unstagedstr ' %F{yellow}✗'
zstyle ':vcs_info:git:*' stagedstr ' %F{yellow}✗'
zstyle ':vcs_info:git:*' formats '%F{12}git:(%F{9}%b%F{12})%u%c%f '
zstyle ':vcs_info:git:*' actionformats '%F{12}git:(%F{9}%b|%a%F{12})%u%c%f '
zstyle ':vcs_info:git*+set-message:*' hooks respect-submodule-ignore
+vi-respect-submodule-ignore() {
  [[ -n ${hook_com[unstaged]} ]] && git diff --no-ext-diff --quiet 2>/dev/null && hook_com[unstaged]=''
  [[ -n ${hook_com[staged]} ]] && git diff --cached --no-ext-diff --quiet 2>/dev/null && hook_com[staged]=''
  return 0
}
precmd() { vcs_info }
setopt prompt_subst
PROMPT='%F{magenta}${CODER_WORKSPACE_NAME:+☁ }%f%(?:%F{green}➜:%F{red}➜) %F{cyan}%c%f ${vcs_info_msg_0_}'

[[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]] && source /usr/share/doc/fzf/examples/key-bindings.zsh
[[ -f /usr/share/doc/fzf/examples/completion.zsh ]] && source /usr/share/doc/fzf/examples/completion.zsh
[[ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# Must be sourced last.
[[ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
