#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
LOG_FOLDER="/var/logs/file-logs"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOG_FOLDER/$SCRIPT_NAME.log"
SCRIPT_DIR=$PWD
SOURCE_DIR=/home/ec2-user/app-logs

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

FILES_TO_DELETE=$(find $SOURCE_DIR -name "*.log" -mtime +14)

while IFS = read -r filepath
do
echo -e "Deleting files : $filepath"
rm -rf $filepath
done <<< $FILES_TO_DELETE

echo "successfully executed.."