#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

if [ $USERID -ne 0 ]
then
echo "$R You are not root user,Please try with root user.-- $N"
exit 1
else
echo "$G You are root user---$N"
fi

#----
VALIDATE(){
    if [ $1 -eq 0 ]  
then
echo "$G Successfully installed $2---$N"
else
echo "$R $2 Installation failed---$N"
exit 1
fi    
}


# installation of mysql
dnf list installed mysql
if [ $? -ne 0 ]
then 
echo "$Y Installing MySQL wait----$N"
dnf install mysql -y
VALIDATE $? "mysql"
else
echo "$Y Already MySql Installed---$N"
fi

#---installation of nginx

dnf list installed nginx
if [ $? -ne 0 ]
then 
echo "$Y Installing nginx wait----$N"
dnf install nginx -y
VALIDATE $? "nginx"
else
echo "$Y Already nginx Installed--$N"
fi

#---installation of git

dnf list installed git
if [ $? -ne 0 ]
then 
echo "$Y Installing git wait----$N"

dnf install git -y
VALIDATE $? "git"
else
echo "$Y Already git Installed--$N"
fi




