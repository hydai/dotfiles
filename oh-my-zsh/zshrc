# oh-my-zsh path
ZSH=$HOME/.oh-my-zsh

# theme name
# ZSH_THEME="robbyrussell" # Pretty enough
ZSH_THEME="hydai"

# include plugins
plugins=(git rails ruby django python gitignore)

# Customize ENV PATH
export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/sbin:$PATH
source $ZSH/oh-my-zsh.sh
export PATH=/opt/local/bin:$PATH
export PATH=/opt/local/libexec:$PATH
export PYENV_ROOT=/usr/local/opt/pyenv
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi
export PATH=$PATH:/usr/local/mysql/bin
export JAVA_HOME=$(/usr/libexec/java_home)

# alias for lazy
alias gb="git branch"
alias gs="git status"
alias gbt="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias ls="ls -G"

# hot command for restarting Mac Dock
alias missionRst="osascript -e 'quit application \"Dock\"'"

# clang setting and c++11 flag
alias clang="/usr/bin/clang"
alias clang++="/usr/bin/clang++"
alias cc11="/usr/bin/clang++ -std=c++11"

# lazy commands of makefile
alias m="make"
alias mc="make clean"

# mysql path
alias mysql='/usr/local/mysql/bin/mysql'  
alias mysqladmin='/usr/local/mysql/bin/mysqladmin'  
