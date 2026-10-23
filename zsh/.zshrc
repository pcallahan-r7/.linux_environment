# `.zshrc' is sourced in interactive shells. It should contain commands to set
# up aliases, functions, options, key bindings, etc.
[[ -n "$ZSH_DEBUG" ]] && print -n ".zshrc:"

# History — must live in .zshrc: macOS /etc/zshrc runs after .zshenv and
# resets HISTSIZE/SAVEHIST (2000/1000), which truncates the history file.
# outside the repo so command history can never end up in git;
# run zsh/migrate_history.sh once per machine to carry old history over
HISTFILE=${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history
[[ -d ${HISTFILE:h} ]] || mkdir -m 700 -p ${HISTFILE:h}
HISTSIZE=1000000
SAVEHIST=$HISTSIZE
setopt EXTENDED_HISTORY        # timestamps + duration
setopt HIST_IGNORE_ALL_DUPS    # drop older duplicates
setopt INC_APPEND_HISTORY      # write each command immediately, not on exit
SHELL_SESSION_HISTORY=0        # disable Apple Terminal per-window history

# PATH — set here because macOS rewrites PATH order in /etc/zprofile
# via /usr/libexec/path_helper after .zshenv runs.
path=('/usr/local/bin' $path)
path=('/usr/local/sbin' $path)
[[ -n "$JAVA_HOME" ]] && path=("${JAVA_HOME}/bin" $path)
[[ -d "$HOME/.cargo/bin" ]] && path+=("$HOME/.cargo/bin")
path=("${HOME}/.local/bin" $path)
path=('/opt/homebrew/bin' $path)
path=('/opt/homebrew/sbin' $path)
typeset -U path PATH    # de-duplicate
export PATH
[[ -n "$ZSH_DEBUG" ]] && print "setting PATH to $PATH"
[[ -n "$ZSH_DEBUG" ]] && print "3setting PATH to $PATH"

# aliases
source $HOME/.linux_environment/bash/.bash_aliases

# functions
source $HOME/.linux_environment/bash/.bash_functions

# fuzzy finder
[[ ! -f "${ZDOTDIR}"/"${OS_ENV}"/.fzf.zsh ]] || source "${ZDOTDIR}"/"${OS_ENV}"/.fzf.zsh

# zsh autosuggestion
[[ ! -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]] || \
    source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Node Version Manager
export NVM_DIR="$HOME/.nvm"
[[ ! -f "$NVM_DIR/nvm.sh" ]] || source "$NVM_DIR/nvm.sh"
[[ ! -f "$NVM_DIR/bash_completion" ]] || source "$NVM_DIR/bash_completion"

# don't load stuff like PL10k if in an ai agent
if [[ "$TERM_PROGRAM" == "vscode" || "$TERM_PROGRAM" == "cursor" ]]; then
  PROMPT='$ '
  return
fi

# windsurf
if [[ -n "${CODEIUM_EDITOR_APP_ROOT+1}" || -n "${VSCODE_INJECTION+1}" ]]; then
  PROMPT='$ '
  return
fi

# Enable Powerlevel10k instant prompt. Initialization code that may require
# console input (password prompts, [y/n] confirmations, etc.) must go above
# this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# powerlevel10k — opt/ symlink survives brew upgrades, unlike Cellar/<version>
[[ ! -f /opt/homebrew/opt/powerlevel10k/share/powerlevel10k/powerlevel10k.zsh-theme ]] || \
    source /opt/homebrew/opt/powerlevel10k/share/powerlevel10k/powerlevel10k.zsh-theme

# OS-specific zshrc.
source "${ZDOTDIR}"/"${OS_ENV}"/"zshrc-${OS_ENV}.sh"

# To customize prompt, run `p10k configure` or edit ~/.linux_environment/zsh/.p10k.zsh.
[[ ! -f ~/.linux_environment/zsh/.p10k.zsh ]] || source ~/.linux_environment/zsh/.p10k.zsh

end_dot .zshrc
