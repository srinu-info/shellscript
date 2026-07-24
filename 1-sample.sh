#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

if [ $USERID -ne 0 ]
then
	echo -e "$R ERROR: You dont have access $N"
	exit 1
else
	echo -e "$G You have root access $N"
fi

dnf list installed nginx
if [ $? -ne 0 ] 
then 
	echo -e " $G nginx not available.. Installing now...$N"
	dnf install nginx -y
	if [ $? -eq 0 ]
	then
		echo -e "nginx installed $G Successfully $N"
	else
		echo -e "$G nginx installation failed..$N"
		exit 1
	fi
else
	echo -e " $Y  nginx already installed $N"
fi