#!/bin/bash

#bash script to tag EBS snapshots
#In this script we are tagging EBS snapshots with the following tags: Cost:Research ( you can change it to anything you want)

regionid="us-east-1"
tagdata="Research"


# Find all snapshots within the given region
snap_ids=$(/usr/local/bin/aws ec2 describe-snapshots --region "${regionid}" --owner-ids self | jq -r '.Snapshots[].SnapshotId')
  # Populate the Cost tag for all snapshots
  for snap_id in ${snap_ids};do
    echo "Adding tag data to snapshot-id: " ${snap_id}
    aws ec2 create-tags --region ${regionid} --resources ${snap_id} --tags Key=Cost,Value="${tagdata}"
    echo "Done!"
    done