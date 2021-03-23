#!/bin/bash
#Cleanup
#Iryna Bb 22/03/2021

aws ec2 terminate-instances \
 --instance-ids $aws_ec2_inst_id &&
rm -f userdata.sh

aws ec2 delete-key-pair \
 --key-name MyKeyPair &&
rm -f MyKeyPair.pem

aws ec2 delete-security-group \
 --group-id $aws_security_group_id  
