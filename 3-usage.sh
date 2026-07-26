#!/bin/bash
# THRESHOLD=70
# DISK=$(df -hP | tail -n +2)


# df -hP | tail -n +2 | while read -r filesystem size used avail use mount
# do
# 	USAGE=${use%\%}
# 	if [ "$USAGE" -ge "$THRESHOLD" ]
# 	then
# 		echo "ALERT: Disk Usage on $mount is ${USAGE}%"
# 	fi
# done 
# echo "----------------"
# DISKSPACE=$(df -hT | grep -v Filesystem)
# while IFS= read line
# do
# 	USE=$(echo $line | awk '{print $6F}'| cut -d "%" -f1)
# 	MOUNT=$(echo $line | awk '{print $7F}' )
# 	if [ $USE -ge $THRESHOLD ]
# 	then
# 		echo "ALERT: Disk Usage on $MOUNT is $USE%"
# 	fi
# done <<< $DISKSPACE
echo "------------***************---------------------"
THRESHOLD=30


MEMORY=$(free -h | awk '/Mem:/ {print int($3/$2 *100)}')

if [ "$MEMORY" -ge "$THRESHOLD "]
then
	echo "ALERT: Memory is $MEMORY"
fi