#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
LOG_FOLDER="/var/logs/shellscript-logs"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
Log_file="$LOG_FOLDER/$SCRIPT_NAME.log"
Packages=("mysql" "nginx")
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

for Packages in "${Packages[@]}"
do
dnf list installed $Packages
if [ $? -ne 0 ]
then 
echo -e "$Y Installing $Packages wait----$N " | tee -a $Log_file
dnf install $Packages -y
VALIDATE $? "$Packages"
else
echo -e "$Y Already $Packages Installed---$N" | tee -a $Log_file
fi
done

