#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
LOG_FOLDER="/var/logs/roboshop-logs"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
Log_file="$LOG_FOLDER/$SCRIPT_NAME.log"
SCRIPT_DIR=$PWD

mkdir -p $LOG_FOLDER
echo "Script started executing at: $(date)"  


if [ $USERID -ne 0 ]
then
echo -e "$R You are not root user,Please try with root user.-- $N" | tee -a $Log_file
exit 1
else
echo -e "$G You are root user---$N" | tee -a $Log_file
fi

#----
VALIDATE(){
    if [ $1 -eq 0 ]  
then
echo -e "$2 is ... $G SUCCESS $N" | tee -a $Log_file
else
echo -e "$2 is ... $R FAILURE $N" | tee -a $Log_file
exit 1
fi    
}

dnf module disable nginx -y &>>$Log_file
VALIDATE $? "Disabling existing nginx"

dnf module enable nginx:1.24 -y &>>$Log_file
VALIDATE $? "Enabling nginx1.24"

dnf install nginx -y &>>$Log_file
VALIDATE $? "Installing nginx"

systemctl enable nginx  &>>$Log_file
systemctl start nginx 
VALIDATE $? "Starting nginx server"


rm -rf /usr/share/nginx/html/*  
VALIDATE $? "Removing existing content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip

cd /usr/share/nginx/html &>>$Log_file
unzip /tmp/frontend.zip
VALIDATE $? "Downloaded and extracting code"

rm -rf  /etc/nginx/nginx.conf &>>$Log_file
cp $SCRIPT_DIR/nginx.conf /etc/nginx/nginx.conf
VALIDATE $? "Copiying roboshop code"

systemctl restart nginx  &>>$Log_file
VALIDATE $? "Restarting nginx server"
