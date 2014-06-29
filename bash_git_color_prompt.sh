#!/bin/bash

function git-branch-name {
    git symbolic-ref HEAD 2>/dev/null | cut -d"/" -f 3-
}
function git-status {
    local statusLine=$(git status -s -b | head -n1)
    if [[ "${statusLine}" =~ \[ahead\ [0-9]+\]$ ]]; then
        aheadBy=${statusLine##* [ahead }
        aheadBy=${aheadBy%]}
        echo " >> ${aheadBy}"
        return 0
    fi
    if [[ "${statusLine}" =~ \[behind\ [0-9]+\]$ ]]; then
        behindBy=${statusLine##* [behind }
        behindBy=${behindBy%]}
        echo " <<! ${behindBy}"
        return 0
    fi
}
function git-prompt {
    local branch=$(git-branch-name)
    [ -z "$branch" ] && return 1
    local status=$(git-status)
    echo " [${branch}${status}]"
}

function git-prompt-imp {
    git-prompt | grep -P "(master|develop|<<!)"    
}
function git-prompt-norm {
    git-prompt | grep -vP "(master|develop|<<!)"    
}

if [ "$color_prompt" = yes ]; then
    PS1="\${debian_chroot:+(\$debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[0;36m\]\w\[\033[0;31m\]\$(git-prompt-imp)\[\033[0;32m\]\$(git-prompt-norm)\[\033[0m\] \$ "
else
    PS1="\${debian_chroot:+(\$debian_chroot)}\u@\h:\w$(git-prompt) \$ "
fi

