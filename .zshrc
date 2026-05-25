# ──────────────────────────────────────────────
# Environment
# ──────────────────────────────────────────────
export EDITOR=nvim               # default editor (also try nvim, nano, code)
export VISUAL=$EDITOR
export PAGER=less
export LANG=en_US.UTF-8

# Add your local bin to PATH
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

# ──────────────────────────────────────────────
# History
# ──────────────────────────────────────────────
HISTFILE=~/.zsh_history
HISTSIZE=10000               # lines kept in memory
SAVEHIST=100000              # lines saved to disk

setopt HIST_IGNORE_DUPS      # skip consecutive duplicate entries
setopt HIST_IGNORE_SPACE     # skip commands starting with a space
setopt SHARE_HISTORY         # share history across all open terminals
setopt EXTENDED_HISTORY      # save timestamp + duration

# ──────────────────────────────────────────────
# Completion
# ──────────────────────────────────────────────
autoload -Uz compinit
compinit

setopt MENU_COMPLETE          # auto-select first completion
zstyle ':completion:*' menu select  # arrow-key navigable menu
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'  # case-insensitive
zstyle ':completion:*' list-colors ''  # colored completions

# ──────────────────────────────────────────────
# Key bindings
# ──────────────────────────────────────────────
bindkey -e                   # emacs-style keys (ctrl-a, ctrl-e, etc.)
bindkey '^[[A' history-search-backward  # up arrow: search history
bindkey '^[[B' history-search-forward   # down arrow: search history

# ──────────────────────────────────────────────
# Aliases
# ──────────────────────────────────────────────
# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ~='cd ~'

# ls (use eza/exa if available, fall back to ls)
if command -v eza &>/dev/null; then
  alias ls='eza --icons'
  alias ll='eza -lah --icons --git'
  alias tree='eza --tree --icons'
else
  alias ls='ls --color=auto'
  alias ll='ls -lahF --color=auto'
fi

# Safety
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Git
alias gs='git status'
alias ga='git add'
alias gc='git commit -m'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'
alias gd='git diff'
alias gb='git branch -a'

# Quick edit & reload this file
alias zshrc='$EDITOR ~/.zshrc && source ~/.zshrc'

# ──────────────────────────────────────────────
# Functions
# ──────────────────────────────────────────────
# mkdir + cd in one step
mkcd() { mkdir -p "$1" && cd "$1" }

# Show PATH entries one per line
path() { echo "$PATH" | tr ':' '\n' }

# Quick HTTP server in current dir
serve() { python3 -m http.server "${1:-8000}" }

# Extract any archive format
extract() {
  case "$1" in
    *.tar.gz|*.tgz) tar xzf "$1" ;;
    *.tar.bz2)      tar xjf "$1" ;;
    *.zip)          unzip "$1" ;;
    *.gz)           gunzip "$1" ;;
    *.rar)          unrar x "$1" ;;
    *)              echo "Unknown: $1" ;;
  esac
}

# ──────────────────────────────────────────────
# Prompt  (simple built-in version)
# ──────────────────────────────────────────────
autoload -Uz vcs_info
zstyle ':vcs_info:git*' formats " %F{blue{%b%f %m%u%c %a "
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr ' %F{green}+%f'
zstyle ':vcs_info:*' unstagedstr ' %F{red}●%f'

precmd() {
    vcs_info
    print -P '%B%~%b ${vcs_info_msg_0_}'
}

setopt PROMPT_SUBST
PROMPT='%B%(!.#.$)%b '
# Result: user@host ~/projects/myapp (main) %

# ──────────────────────────────────────────────
# Tool initialisation  (uncomment what you use)
# ──────────────────────────────────────────────
# eval "$(starship init zsh)"       # Starship prompt
# eval "$(zoxide init zsh)"          # smarter cd (z command)
# eval "$(direnv hook zsh)"          # per-directory env vars
# eval "$(fnm env --use-on-cd)"      # Node version manager
# source ~/.config/op/plugins.sh     # 1Password CLI

# Load local overrides (not committed to git)
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="agnoster"
plugins=(git)
source $ZSH/oh-my-zsh.sh
