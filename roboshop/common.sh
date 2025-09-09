START_TIME=$(date +%s)
USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
LOG_FOLDER="/var/logs/roboshop-logs"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
Log_file="$LOG_FOLDER/$SCRIPT_NAME.log"
SCRIPT_DIR=$PWD

mkdir -p $LOG_FOLDER
echo "Script started executing at: $(date)"  

check_root(){
if [ $USERID -ne 0 ]
then
echo -e "$R You are not root user,Please try with root user.-- $N" | tee -a $Log_file
exit 1
else
echo -e "$G You are root user---$N" | tee -a $Log_file
fi
}

VALIDATE(){
    if [ $1 -eq 0 ]  
then
echo -e "$2 is ... $G SUCCESS $N" | tee -a $Log_file
else
echo -e "$2 is ... $R FAILURE $N" | tee -a $Log_file
exit 1
fi    
}

nodejs_setup(){
dnf module disable nodejs -y &>>$Log_file
VALIDATE $? "Disabling existing nodes"

dnf module enable nodejs:20 -y &>>$Log_file
VALIDATE $? "Enabling nodejs:20 to install"

dnf install nodejs -y &>>$Log_file
VALIDATE $? "Installing nodejs..."

npm install 
VALIDATE $? "Installing dependencies..."
}

app_setup(){
id roboshop
if [ $? -ne 0 ]
then 
useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
VALIDATE $? "Creating user to run roboshop"
else
echo -e "System user roboshop already existed.....$Y SKIPPING $N"
fi

mkdir -p /app  &>>$Log_file
VALIDATE $? "Creating Dir..."

curl -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip 
VALIDATE $? "Downloading $app_name"

rm -rf /app/*
cd /app 
unzip /tmp/$app_name.zip
VALIDATE $? "Downloaded and extracted..."
}

systemd_setup(){
cp $SCRIPT_DIR/$app_name.service /etc/systemd/system/$app_name.service &>>$Log_file
VALIDATE $? "Copying service properties...."

systemctl daemon-reload
systemctl enable $app_name  &>>$Log_file
systemctl start $app_name
VALIDATE $? "Service started...."
}

print_time(){
    END_TIME=$(date +%s)
    TOTAL_TIME=$(($END_TIME - $START_TIME))
    echo -e "Script executed successfully, $Y Time taken: $TOTAL_TIME seconds $N"
}

python_setup(){
dnf install python3 gcc python3-devel -y &>>$Log_file
VALIDATE $? "Install Python3 packages"
pip3 install -r requirements.txt &>>$Log_file
VALIDATE $? "installing dependencies"
}

maven_setup(){
dnf install maven -y
VALIDATE $? "Installing maven.."
mvn clean package 
mv target/shipping-1.0.jar shipping.jar 
}