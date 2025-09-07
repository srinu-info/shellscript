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

echo "please enter root password to set up"
read -s MYSWL_ROOT_PASSWD

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

dnf install mysql-server -y  &>>$Log_file
VALIDATE $? "Installing mysql.."

systemctl enable mysqld &>>$Log_file
VALIDATE $? "enable mysql..."

systemctl start mysqld  &>>$Log_file
VALIDATE $? "starting mysql.."

mysql_secure_installation --set-root-pass $MYSQL_ROOT_PASSWD