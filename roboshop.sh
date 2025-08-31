#!/bin/bash

AMI_ID="ami-09c813fb71547fc4f"
SG_ID="sg-0771b87321713642a"
INSTANCES=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment"
"dispatch" "frontend")
ZONE_ID="Z08547183IUKT17HPDSNQ"
DOMAIN_ID="svdvps.online"

for instances in ${INSTANCES[@]}
do
INSTANCE_ID=$(aws ec2 run-instances   --image-id ami-09c813fb71547fc4f  -instance-type t3.micro   --security-group-ids sg-0771b87321713642a  --tag-specifications "ResourceType=instance,  Tags=[{Key=Name,Value=$instances}]" --query "Instances[0].InstanceId"   --output text)
if [ $instnace !="frontend" ] 
then
IP=$(aws ec2 describe-instances   --instance-ids $INSTANCE_ID   --query "Reservations[0].Instances[0].PrivateIpAddress" --output text)
  else
  IP=$(aws ec2 describe-instances   --instance-ids $INSTANCE_ID   --query "Reservations[0].Instances[0].PublicIpAddress" --output text)
  fi
  echo " $instances Ip Address: $IP"
done

