# FreeBSD-specific configuration

# FreeBSD package manager
alias pkg-update="sudo pkg update"
alias pkg-upgrade="sudo pkg upgrade"
alias pkg-search="pkg search"
alias pkg-install="sudo pkg install"

# FreeBSD-specific paths
if [ -d "/usr/local/bin" ]; then
  export PATH="/usr/local/bin:$PATH"
fi

# NVM setup for FreeBSD
export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
  . "$NVM_DIR/nvm.sh"
fi
if [ -s "$NVM_DIR/bash_completion" ]; then
  . "$NVM_DIR/bash_completion"
fi

# FreeBSD-specific aliases
alias ports-update="sudo portsnap fetch update"

# Java home for FreeBSD (if installed via pkg)
if [ -d "/usr/local/openjdk11" ]; then
  export JAVA_HOME="/usr/local/openjdk11"
elif [ -d "/usr/local/openjdk8" ]; then
  export JAVA_HOME="/usr/local/openjdk8"
fi
