#!/bin/bash

source ./common.sh
app_name=mysql

echo "please enter root password to set up"
read -s MYSQL_ROOT_PASSWD


dnf install mysql-server -y  &>>$Log_file
VALIDATE $? "Installing mysql.."

systemctl enable mysqld &>>$Log_file
VALIDATE $? "enable mysql..."

systemctl start mysqld  &>>$Log_file
VALIDATE $? "starting mysql.."

mysql_secure_installation --set-root-pass $MYSQL_ROOT_PASSWD

print_time