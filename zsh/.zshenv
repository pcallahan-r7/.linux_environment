# `.zshenv' is sourced on all invocations of the shell, unless the -f option
# is set. It should contain commands to set the command search path, plus
# other important environment variables. `.zshenv' should not contain
# commands that produce output or assume the shell is attached to a tty.
# note: any echo output here breaks scp/rsync.

export ZDOTDIR=${HOME}/.linux_environment/zsh

# Startup trace for debugging dotfile load order: enable with `ZSH_DEBUG=1`.
# Off by default so normal shells stay silent (echo output here breaks scp/rsync).
if [[ -n "$ZSH_DEBUG" ]]; then
    source() {
        (( ${+source_called} )) && print -n ", ${1}" || { source_called=1; print -n "  ${1}"; }
        builtin source "$1"
    }
fi
end_dot() {
    [[ -n "$ZSH_DEBUG" ]] || return
    (( ${+source_called} )) && print
    print -- "--end $1"
    unset source_called
}

unamestr=`uname`
if [[ "$unamestr" == 'Linux' ]]; then
    export OS_ENV=linux
else
    export OS_ENV=macos
fi

source "${ZDOTDIR}"/"${OS_ENV}"/"zshenv-${OS_ENV}.sh"

###############################
## Env variables here
###############################

export HOMEBREW_NO_AUTO_UPDATE=1

export PYENV_ROOT="$HOME/.pyenv"
# export LDFLAGS=-L/opt/homebrew/opt/openssl/lib

[[ -n "$ZSH_DEBUG" ]] && print "2setting PATH to $PATH"
end_dot .zshenv
