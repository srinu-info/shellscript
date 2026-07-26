#!/bin/bash
THRESHOLD=70
DISK=$(df -hP | tail -n +2)

while IFS= read -r filesystem size used avail use mount
do
	USAGE=${use%\%}
	if [ "$USAGE" -ge "$THRESHOLD" ]
	then
		echo "ALERT: Disk Usage on $mount is ${USAGE}%"
	fi
done <<< $DISK
