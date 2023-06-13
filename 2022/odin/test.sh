#!/usr/bin/env bash

export PATH=$PATH:$PWD/Odin

odin test ./days/01

if ([ $? -ne 0 ])
then
    echo "Ols tests failed"
    exit 1
fi
