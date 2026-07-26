#!/bin/bash
THRESHOLD=70
DISK=$(df -hP | tail -n +2)

while IFS= read line
do
	USAGE=${use%\%}
done <<<$DISK

if [ "$USAGE" -gt "$THRESHOLD" ]
then
	echo "ALERT: Disk Usage on $mount is ${USAGE}%"
fi