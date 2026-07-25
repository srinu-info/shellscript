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

while IFS=read -r line
do
	echo $line
done < cart.log
echo "-----------------------"
SOURCE="/home/ec2-user/app-logs"
FILE=$(find $SOURCE -type f -mtime +14)
while IFS= read -r filepath
do
	rm -rf $filepath
done <<< $FILE