#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
LOG_FOLDER="/var/logs/roboshop-logs"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
Log_file="$LOG_FOLDER/$SCRIPT_NAME.log"

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

#---installation of mongodb
cp $SCRIPT_NAME/mongo.repo /etc/yum.repos.d/mongodb.repo 
VALIDATE() $? "Copiying moongo repo" 

dnf install mongodb-org -y &>>$Log_file
VALIDATE() $? "Installing mongoDb server"

systemctl enable mongod &>>$Log_file
systemctl start mongod 
VALIDATE() $? "Starting the mongoDB server"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
VALIDATE() $? "Changing port to access all "

systemctl restart mongod &>>$Log_file
VALIDATE() $? "Restarting mongodb server"
