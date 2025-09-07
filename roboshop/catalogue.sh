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

dnf module disable nodejs -y &>>$Log_file
VALIDATE $? "Disabling existing nodes"

dnf module enable nodejs:20 -y &>>$Log_file
VALIDATE $? "Enabling nodejs:20 to install"

dnf install nodejs -y &>>$Log_file
VALIDATE $? "Installing nodejs..."

id roboshop
if [ $? -ne 0 ]
then 
useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$Log_file
VALIDATE $? "Creating user to run roboshop"
else
echo -e "System user roboshop already existed.....$Y SKIPPING $N"
fi

mkdir -p /app 
VALIDATE $? "Creating Dir..."

curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip 
VALIDATE $? "Downloading Catalogue"

rm -rf /app/* &>>$Log_file
cd /app 
unzip /tmp/catalogue.zip
VALIDATE $? "Downloaded and extracted..."

npm install  


cp $SCRIPT_DIR/catalogue.service /etc/systemd/system/catalogue.service &>>$Log_file
VALIDATE $? "Copying service properties...."

systemctl daemon-reload
systemctl enable catalogue 
systemctl start catalogue
VALIDATE $? "service started...."

cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo 
dnf install mongodb-mongosh -y &>>$LOG_FILE
VALIDATE $? "Installing MongoDB Client"

STATUS=$(mongosh --host mongodb.svdvps.online --eval 'db.getMongo().getDBNames().indexOf("catalogue")')
if [ $STATUS -lt 0 ]
then
    mongosh --host mongodb.svdvps.online </app/db/master-data.js &>>$LOG_FILE
    VALIDATE $? "Loading data into MongoDB"
else
    echo -e "Data is already loaded ... $Y SKIPPING $N"
fi