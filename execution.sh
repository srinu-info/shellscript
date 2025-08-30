#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
LOG_FOLDER="/var/logs/shellscript-logs"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
Log_file="$LOG_FOLDER/$SCRIPT_NAME.log"

mkdir -p $LOG_FOLDER
echo "Script started executing at: $(date)"  &>>$Log_file


if [ $USERID -ne 0 ]
then
echo -e "$R You are not root user,Please try with root user.-- $N" &>>$Log_file
exit 1
else
echo -e "$G You are root user---$N" &>>$Log_file
fi

#----
VALIDATE(){
    if [ $1 -eq 0 ]  
then
echo -e  "$G Successfully installed $2---$N" &>>$Log_file
else
echo -e "$R $2 Installation failed---$N" &>>$Log_file
exit 1
fi    
}


# installation of mysql
dnf list installed mysql
if [ $? -ne 0 ]
then 
echo -e "$Y Installing MySQL wait----$N " &>>$Log_file
dnf install mysql -y
VALIDATE $? "mysql"
else
echo -e "$Y Already MySql Installed---$N" &>>$Log_file
fi

#---installation of nginx

dnf list installed nginx
if [ $? -ne 0 ]
then 
echo -e "$Y Installing nginx wait----$N" &>>$Log_file
dnf install nginx -y
VALIDATE $? "nginx"
else
echo -e "$Y Already nginx Installed--$N" &>>$Log_file
fi

#---installation of git

dnf list installed git
if [ $? -ne 0 ]
then 
echo -e "$Y Installing git wait----$N" &>>$Log_file

dnf install git -y
VALIDATE $? "git"
else
echo -e "$Y Already git Installed--$N" &>>$Log_file
fi




