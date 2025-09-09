#!/bin/bash
source ./common.sh
app_name=frontend
check_root

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

print_time
