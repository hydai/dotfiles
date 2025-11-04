# Debian/Ubuntu-specific configuration

# APT package manager aliases
alias apt-update="sudo apt update"
alias apt-upgrade="sudo apt upgrade"
alias apt-search="apt search"
alias apt-install="sudo apt install"
alias apt-remove="sudo apt remove"
alias apt-autoremove="sudo apt autoremove"
alias apt-clean="sudo apt clean"

# NVM setup for Debian/Ubuntu
export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
  . "$NVM_DIR/nvm.sh"
fi
if [ -s "$NVM_DIR/bash_completion" ]; then
  . "$NVM_DIR/bash_completion"
fi

# Debian-specific paths
if [ -d "/snap/bin" ]; then
  export PATH="/snap/bin:$PATH"
fi

# Java home for Debian (if installed)
if [ -d "/usr/lib/jvm/default-java" ]; then
  export JAVA_HOME="/usr/lib/jvm/default-java"
elif [ -d "/usr/lib/jvm/java-11-openjdk-amd64" ]; then
  export JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"
fi
