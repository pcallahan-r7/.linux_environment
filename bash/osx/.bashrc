check_installed() {
    if [[ ! -f "$1" ]]; then
        brew install "$2"
    fi
}

export BASH_COMPLETION_COMPAT_DIR="/usr/local/etc/bash_completion.d"
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"


#check_installed /usr/local/opt/bash-completion/etc/bash_completion bash-completion
#. /usr/local/opt/bash-completion/etc/bash_completion

export JAVA_HOME="$(/usr/libexec/java_home 2>/dev/null)"
export HOMEBREW_NO_AUTO_UPDATE=1
