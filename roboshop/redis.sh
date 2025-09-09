#!/bin/bash
source ./common.sh
app_name=redis
check_root

dnf module disable redis -y &>>$Log_file
dnf module enable redis:7 -y
dnf install redis -y 
VALIDATE $? "Installing redis.."

sed -i -e 's/127.0.0.1/0.0.0.0/g' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf
VALIDATE $? "Changing port to access all "

systemctl enable redis  &>>$Log_file
systemctl start redis 
VALIDATE $? "Start redis....."

print_time