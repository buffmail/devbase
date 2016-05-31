# non-printable characters must be enclosed inside \[ and \]
PS1=''
PS1="$PS1"'\n'                 # new line
PS1="$PS1"'\[\033[34m\]'       # change color
PS1="$PS1"'\w'                 # current working directory
PS1="$PS1"'\[\033[31m\]'       # change color
if test -z "$WINELOADERNOEXEC"
then
    PS1="$PS1 "'$(git rev-parse --abbrev-ref HEAD 2> /dev/null)'   # bash function
fi
PS1="$PS1"'\[\033[0m\]'        # change color
PS1="$PS1"'\n'                 # new line
PS1="$PS1"'$ '                 # prompt: always $

alias ls='ls --color'
alias pym='python -m'
export PATH=$PATH:/mingw64/bin/:/d/work/Scripts/
export TERM=xterm

if [ ! -z "$my_workdir" ] ; then
    cd $my_workdir
fi
