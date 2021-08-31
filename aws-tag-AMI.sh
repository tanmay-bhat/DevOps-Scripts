#!/bin/bash

#bash script to tag AMI
#In this script we are tagging AMI with the following tags: Cost:Research ( you can change it to anything you want)

regionid="us-east-1"
tagdata="Research"

# Find all images within the given region
image_ids=$(aws ec2 describe-images --region "${regionid}" --filters "Name=is-public,Values=false" | jq -r '.Images[].ImageId')
  # Populate the Cost tag for all images
  for image_id in ${image_ids};do
    echo "Adding tag data to image-id: " ${image_id}
    aws ec2 create-tags --region ${regionid} --resources ${image_id} --tags Key=Cost,Value="${tagdata}"
    echo "Done!"
    done