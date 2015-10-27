# non-printable characters must be enclosed inside \[ and \]
PS1=''
PS1="$PS1"'\n'                 # new line
PS1="$PS1"'\[\033[34m\]'       # change color
PS1="$PS1"'\w'                 # current working directory
PS1="$PS1"'\[\033[31m\]'       # change color
#if test -z "$WINELOADERNOEXEC"
#then
#    PS1="$PS1"'$(__git_ps1)'   # bash function
#fi
PS1="$PS1"'\[\033[0m\]'        # change color
PS1="$PS1"'\n'                 # new line
PS1="$PS1"'$ '                 # prompt: always $

