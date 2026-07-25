#!/bin/bash

servers=("nginx" "mysql")

for server in "${servers[@]}"
do 
	ssh $s uptime
done

echo "------------------------------"

echo "find error in file"
 grep Error /var/log/shell-log/1-sample.log

 echo "-----------------------------"

service=nginx

if [! sysemctl is-active --quite $service ]
then
systemctl restart $service
else
echo "service is Active"
fi
echo "--------------------------------"

count=$(ls | wc -l)
echo $count

