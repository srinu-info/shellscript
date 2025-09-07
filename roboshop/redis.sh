#!/bin/bash
START_TIME=$(date +%s)
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


dnf module disable redis -y &>>$LOG_FILE
dnf module enable redis:7 -y
dnf install redis -y 
VALIDATE() $? "Installing redis.."

sed -i -e 's/127.0.0.1/0.0.0.0/g' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf &>>$LOG_FILE
VALIDATE() $? "Changing port to access all "

systemctl enable redis  &>>$LOG_FILE
systemctl start redis 
VALIDATE() $? "Start redis....."

END_TIME=$(date +%s)
TOTAL_TIME=$(( $END_TIME - $START_TIME ))

echo -e "Script execution completed successfully. $Y time taken:  $TOTAL_TIME seconds $N" tee -a $LOG_FILE