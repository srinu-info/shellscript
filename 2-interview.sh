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
SOURCE="/home/ec2-user/app-logs"
while IFS= read -r line
do
	echo $line
done < $SOURCE/cart.log
echo "-----------------------"

FILE=$(find $SOURCE -name "*.log" -type f -mtime +14)
while IFS= read -r filepath
do
	rm -rf $filepath
done <<< $FILE