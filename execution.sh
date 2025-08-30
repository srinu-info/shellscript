#!/bin/bash

USERID=$(id -u)

if [ $USERID -ne 0 ]
then
echo "You are not root user,Please try with root user."
exit 1
else
echo "You are root user"
fi

dnf list installed mysql
if [ $? -ne 0 ]
then 
echo " Installing MySQL wait----"

dnf install mysql -y
if [ $? -eq 0 ]  
then
echo "iSuccessfully installed MySql"
else
echo "MySql Installation failed"
exit 1
fi

else
then 
echo "Already MySql Installed"
fi





