#!/bin/bash

USERID=$(id -u)

if [ $USERID -ne 0 ]
then
echo "You are not root user,Please try with root user."
exit 1
else
echo "You are root user"
fi

# installation of mysql
dnf list installed mysql
if [ $? -ne 0 ]
then 
echo " Installing MySQL wait----"
dnf install mysql -y
if [ $? -eq 0 ]  
then
echo "Successfully installed MySql"
else
echo "MySql Installation failed"
exit 1
fi
else
echo "Already MySql Installed"
fi

#---installation of nginx

dnf list installed nginx
if [ $? -ne 0 ]
then 
echo " Installing nginx wait----"
dnf install nginx -y
if [ $? -eq 0 ]  
then
echo "Successfully installed nginx"
else
echo "nginx Installation failed"
exit 1
fi
else
echo "Already nginx Installed"
fi

#---installation of git

dnf list installed git
if [ $? -ne 0 ]
then 
echo " Installing git wait----"
dnf install git -y
if [ $? -eq 0 ]  
then
echo "Successfully installed git"
else
echo "git Installation failed"
exit 1
fi
else
echo "Already git Installed"
fi




