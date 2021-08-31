#! /bin/bash
#script to convert all AWS gp2 volumes in a region to gp3

region='ap-south-1' #region in which ebs resides

echo "Warning ! Depending on volume size, the conversion can take few hours to complete from AWS side"
echo "But this shouldn't affect any operations on that volume and progress can be tracked via AWS console"

# Find all gp2 volumes within the given region
volume_ids=$(/usr/local/bin/aws ec2 describe-volumes --region "${region}" --filters Name=volume-type,Values=gp2 | jq -r '.Volumes[].VolumeId')

# Iterate over all gp2 volumes and change its type to gp3
for volume_id in ${volume_ids};do
    result=$(/usr/local/bin/aws ec2 modify-volume --region "${region}" --volume-type=gp3 --volume-id "${volume_id}" | jq '.VolumeModification.ModificationState' | sed 's/"//g')
    if [ $? -eq 0 ] && [ "${result}" == "modifying" ];then
        echo "Success ! volume ${volume_id} state changed to 'modifying'"
    else
        echo "Sorry ! unable to change volume ${volume_id} type to gp3!"
    fi
done