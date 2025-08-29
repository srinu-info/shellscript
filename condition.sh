#!/bin/bash

USERID=$(id -u)

if [ $USERID -ne 0 ]
then
 echo "Error-run with root user"
 exit 1
 else
 echo "you are the root user"
fi

dnf list installed mysql

if [ $? -ne 0 ]
then 
echo " installing mysql---------"
if [ $? eq 0 ]
then 
    echo " MySQl installing Success.."
    else
    echo "Installation Failure.."
    exit 1
fi
else
echo " mysql already installed...nothing to do"
fi 

#dnf install mysql -y

# if [ $? eq 0 ]
# then 
#     echo " MySQl installing Success.."
#     else
#     echo "Installation Failure.."
#     exit 1
# fi