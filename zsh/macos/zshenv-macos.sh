
# resolve the installed JDK dynamically instead of hardcoding a version
JAVA_HOME=$(/usr/libexec/java_home 2>/dev/null)
export JAVA_HOME

# Added by OrbStack: command-line tools and integration
# source ~/.orbstack/shell/init.zsh 2>/dev/null || :
