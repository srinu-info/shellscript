#!/bin/bash

echo "Variable  passed to script: $@"
echo "number of variable passed :$#"
echo "current script name:$0"
echo "current working directory: $PWD"
echo "home directory of script: $HOME"
echo "which user running script:$USER"
echo "PID of current script:$$"
sleep 10

echo "PID of last command running in background:$!"