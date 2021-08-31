#!/bin/bash

#bash script to tag instances
#In this script we are tagging instances with the following tags: Cost:Research ( you can change it to anything you want)

regionid="us-east-1" #region value
tagdata="Research"  #tag value

# Find all instances within the given region
instance_ids=$(/usr/local/bin/aws ec2 describe-instances --region "${regionid}" | jq -r '.Reservations[].Instances[].InstanceId')
  # Populate the Cost tag for all instances
  for instance_id in ${instance_ids};do
    echo "Adding tag data to instance-id: " ${instance_id}
    aws ec2 create-tags --region ${regionid} --resources ${instance_id} --tags Key=Cost,Value="${tagdata}"                #change the Cost tag value to your tag value
    echo "Done!"
    done