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
read -s RABBITMQ_ROOT_PASSWD

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
# Check if user "roboshop" already exists before adding
rabbitmqctl list_users | grep -w roboshop &>/dev/null
if [ $? -eq 0 ]; then
    echo -e "$Y User 'roboshop' already exists. Skipping add_user.$N" | tee -a $Log_file
else
    rabbitmqctl add_user roboshop $RABBITMQ_ROOT_PASSWD
    VALIDATE $? "Adding user roboshop"
fi
cp rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo
VALIDATE $? "Adding repo.."

dnf install rabbitmq-server -y
VALIDATE $? "Installing rabbitmq.."

systemctl enable rabbitmq-server
systemctl start rabbitmq-server
VALIDATE $? "Starting mysql.."

rabbitmqctl add_user roboshop $RABBITMQ_ROOT_PASSWD
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"