#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOGS_FOLDER="/var/log/shell-log"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"

mkdir -p $LOGS_FOLDER
echo "script executed at: $(date)" | tee -a $LOG_FILE

if [ $USERID -ne 0 ]
then
	echo -e "$R ERROR: You dont have access $N" | tee -a $LOG_FILE
	exit 1
else
	echo -e "$G You have root access $N" | tee -a $LOG_FILE
fi

VALIDATE(){
	if [ $1 -eq 0 ]
	then
		echo -e "$2 installed $G Successfully $N" | tee -a $LOG_FILE
	else
		echo -e "$G $2 installation failed..$N"  | tee -a $LOG_FILE
		exit 1
	fi
}

dnf list installed nginx | tee -a $LOG_FILE
if [ $? -ne 0 ] 
then 
	echo -e " $G nginx not available.. Installing now...$N"  | tee -a $LOG_FILE
	dnf install nginx -y 
	VALIDATE $? "nginx" | tee -a $LOG_FILE
else
	echo -e " $Y  nginx already installed $N"  | tee -a $LOG_FILE
fi