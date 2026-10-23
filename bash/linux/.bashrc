


# 1) bash completion
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

export HISTFILE=~/.bash_eternal_history


export JAVA_HOME=`java -XshowSettings:properties -version 2>&1    | sed '/^[[:space:]]*java\.home/!d;s/^[[:space:]]*java\.home[[:space:]]*=[[:space:]]*//'`
export PATH=${HOME}/.local/bin${PATH:+:${PATH}}
