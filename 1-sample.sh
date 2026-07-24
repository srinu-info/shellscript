#!/bin/bash

user=srinu
echo "Hello: $user"

Movies=("bahubali" "pushpa")
echo "firts film :${Movies[0]}"
echo "All movies: ${Movies[@]}"

Num1=1
Num2=99
sum=$((Num1+Num2))
echo "Sum=$sum"

echo "Timestamp =$(date)"

echo "All passing paramters :$@"
echo "number of paramters passed:$#"
echo "user who running this script:$USER"
echo "script name: $0"
echo "PID of the script: $$"
sleep 10 &
echo "PID of last cammand running in background: $!"

input=$1

if [ input -gt 10 ]
then 
	echo " given input number is grater than 10"
else
	echo " given number is smaller than 10"
fi