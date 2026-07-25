#!/bin/bash

# servers=("nginx" "git")

# for server in "${servers[@]}"
# do 
# 	systemctl is-active --quiet $service 
# done

# echo "------------------------------"

# echo "find error in file"
#  grep Error /var/log/shell-log/1-sample.log

#  echo "-----------------------------"

# service=nginx

# if  ! systemctl is-active --quiet $service 
# then
# systemctl restart $service
# else
# echo "service is Active"
# fi
# echo "--------------------------------"

# count=$(ls | wc -l)
# echo $count
# echo "-----------------------"
# SOURCE="/home/ec2-user/app-logs"
# while IFS= read -r line
# do
# 	echo $line
# done < $SOURCE/cart.log
# echo "-----------------------"

# FILE=$(find $SOURCE -name "*.log" -type f -mtime +14)
# while IFS= read -r filepath
# do
# 	rm -rf $filepath
# done <<< $FILE

# echo "-----------------------"

SOURCE=$1
DEST=$2
DAYS=${3:-14}
if [ ! -d $SOURCE ]
then
	echo "Source or Dest directory not exits"
fi
FILES=$(find $SOURCE -type f -name "*.log" -mtime $DAYS)

if [ -n $FILES ]
then
	TIMESTAMP=$(date +%F-%H-%M-%S)
	ZIP_FILE="$DEST/app-logs-$TIMESTAMP.zip"
	find $SOURCE -type f -name "*.log" -mtime $DAYS | zip -@ $ZIP_FILE

	if[ -f $ZIP_FILE ]
	then
		echo "FILES BACKUP SUCCESSFULL"
		echo "REMOVING FILES"
		while IFS= read -r filepath
		do
			rm -rf $filepath
		done <<< $FILES
	else
		echo "ZIP FAILED"
	fi
else
echo "Files not found"
fi
	



