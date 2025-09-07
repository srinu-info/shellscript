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
echo -e  "$G Successfully installed $2---$N" | tee -a $Log_file
else
echo -e "$R $2 Installation failed---$N" | tee -a $Log_file
exit 1
fi    
}

dnf module disable nodejs -y &>>$Log_file
VALIDATE() $? "Disabling existing nodes"

dnf module enable nodejs:20 -y &>>$Log_file
VALIDATE() $? "Enabling nodejs:20 to install"

dnf install nodejs -y &>>$Log_file
VALIDATE() $? "Installing nodejs..."

id roboshop
if [ $? -ne 0 ]
then 
useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
VALIDATE() $? "Creating user to run roboshop"
else
echo -e "System user roboshop already existed.....$Y SKIPPING $N"
fi

mkdir -p /app  &>>$Log_file
VALIDATE() $? "Creating Dir..."

curl -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart-v3.zip 
VALIDATE $? "Downloading cart"

rm -rf /app/*
cd /app 
unzip /tmp/cart.zip
VALIDATE() $? "Downloaded and extracted..."

npm install 


cd $SCRIPT_DIR/cart.service /etc/systemd/system/cart.service &>>$Log_file
VALIDATE() $? "Copying service properties...."

systemctl daemon-reload
systemctl enable cart  &>>$Log_file
systemctl start cart
VALIDATE() $? "service started....

