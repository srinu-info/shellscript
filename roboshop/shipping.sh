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
read -s MYSQL_ROOT_PASSWD

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

dnf install maven -y
VALIDATE $? "Installing maven.."

id roboshop
if [ $? -ne 0 ]
then 
useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$Log_file
VALIDATE $? "Creating user to run roboshop"
else
echo -e "System user roboshop already existed.....$Y SKIPPING $N"
fi

mkdir -p /app 
VALIDATE $? "Creating app dir..."

curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping-v3.zip 

rm -rf /app/*
cd /app 
unzip /tmp/shipping.zip
VALIDATE $? "downloading unzipping code."

mvn clean package 
mv target/shipping-1.0.jar shipping.jar 

cp $SCRIPT_DIR/shipping.service /etc/systemd/system/shipping.service


systemctl daemon-reload

systemctl enable shipping 
systemctl start shipping
VALIDATE $? "Start shipping service"
dnf install mysql -y  &>>$Log_file
VALIDATE $? "Install MySQL"

mysql -h mysql.svdvps.online -u root -p$MYSQL_ROOT_PASSWD -e 'use cities'
if [ $? -ne 0 ]
then
mysql -h mysql.svdvps.online  -uroot -p$MYSQL_ROOT_PASSWD < /app/db/schema.sql
mysql -h mysql.svdvps.online  -uroot -p$MYSQL_ROOT_PASSWD < /app/db/app-user.sql 
mysql -h mysql.svdvps.online  -uroot -p$MYSQL_ROOT_PASSWD < /app/db/master-data.sql
VALIDATE $? "Loading data"
else
echo -e "Data already loaded into MYSQL.. $Y SKIPPING $N"
fi 

systemctl restart shipping
VALIDATE $? "Restart shipping service"