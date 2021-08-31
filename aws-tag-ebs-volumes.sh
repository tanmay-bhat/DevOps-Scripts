#!/bin/bash

#bash script to tag EBS volumes
#In this script we are tagging EBS volumes with the following tags: Cost:Research ( you can change it to anything you want)

regionid="us-east-1"   #region value
tagdata="Research"     #tag value

# Find all  volumes within the given region ( gp3 only)
volume_ids=$(/usr/local/bin/aws ec2 describe-volumes --region "${regionid}" --filters Name=volume-type,Values=gp3 | jq -r '.Volumes[].VolumeId')

# Populate the Cost tag for all volumes
for volume_id in ${volume_ids};do
    echo "Adding tag data to volume-id: " ${volume_id}
    aws ec2 create-tags --region ${regionid} --resources ${volume_id} --tags Key=Cost,Value="${tagdata}"
    echo "Done!"
    done
