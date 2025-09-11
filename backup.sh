#!/bin/bash

SOURCE_DIR=$1
DEST_DIR=$2
DAYS=${3:-14}
USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
LOG_FOLDER="/var/logs/file-logs"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOG_FOLDER/$SCRIPT_NAME.log"


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

if [ $USERID -ne 0 ]
then
echo -e "$R You are not root user,Please try with root user.-- $N" | tee -a $Log_file
exit 1
else
echo -e "$G You are root user---$N" | tee -a $Log_file
fi

mkdir -p $LOG_FOLDER
echo "Script started executing at: $(date)"  

USAGE(){
	echo -e "$R USAGE: $Y sh fine.sh <source_dir> <dist_dir> <day(Optional)>"
}
if [ $# -lt 2 ] 
	then
	USAGE
fi

if [ ! -d $SCRIPT_DIR ]
then 
echo -e "$R Source directory $SOURCE_DIR not exist..Please check $N"
exist 1
fi

if [ ! -d $DEST_DIR ]
then 
echo -e "$R Destimation directory $DEST_DIR not exist..Please check $N"
exist 1
fi

FILES=$(find $SOURCE_DIR -name "*.log" -mtime +$DAYS)

if [ ! -z $FILES ]
then
echo "filed to zip are: $FILES"
TIMESTAMP=$(date +%F-%H-%M-%S)
ZIP_FILE="$DEST_DIR/app-logs-$TIMESTAMP.zip"
echo $FILES | zip -@ $ZIP_FILE

if [ -f $ZIP_FILE ]
then 
echo -e "successfully created zip file"
while IFS= read -r filepath
do
echo  "Deleting files : $filepath" | tee -a $LOG_FILE
rm -rf $filepath
done <<< $FILES
echo -e "log filed older than $DAYS from source directory removed...$G Success $N"

else
echo -e "Zip file Creation...$R FAILED $N"
exit 1
fi

else
echo -e "No log files found older than $DAYS days... $Y SKIPPING $N"
fi

