#!/bin/bash

function git-branch-name {
    git symbolic-ref HEAD 2>/dev/null | cut -d"/" -f 3-
}


