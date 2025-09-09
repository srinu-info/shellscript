#!/bin/bash

source ./common.sh
app_name=mongodb

check_root

#---installation of mongodb
cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongodb.repo 
VALIDATE $? "Copiying moongo repo" 

dnf install mongodb-org -y &>>$Log_file
VALIDATE $? "Installing mongoDb server"

systemctl enable mongod &>>$Log_file
systemctl start mongod 
VALIDATE $? "Starting the mongoDB server"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
VALIDATE $? "Changing port to access all "

systemctl restart mongod &>>$Log_file
VALIDATE $? "Restarting mongodb server"

print_time