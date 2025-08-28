#!/bin/bash

echo "hello!"

P1="Ramesh"
P2="Suresh"

echo "$P1: Hi ! $P2 how are you?"
echo "$P2: I am fine. Thankyou! how are you  $P1"
echo "$P1: I am doing well..$P2"

N1=100
N2=120

sum=$(($N1+$N2))
timestamp=$(date)

echo "sum of $N1 and $N2=$sum at $timestamp" 