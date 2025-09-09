#!/bin/bash

source ./common.sh
app_name=rabbitmq

check_root
echo "please enter root password to set up"
read -s RABBITMQ_PASSWD

cp rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo
VALIDATE $? "Adding repo.."

dnf install rabbitmq-server -y
VALIDATE $? "Installing rabbitmq.."

systemctl enable rabbitmq-server
systemctl start rabbitmq-server
VALIDATE $? "Starting Rabbitmq.."

rabbitmqctl add_user roboshop $RABBITMQ_PASSWD &>>$Log_file
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$Log_file

print_time