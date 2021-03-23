#!/bin/bash
#Creat aws ec2 t2mikro
#Iryna Bb mod. v.2 22/03/2021


aws_ami_id=$(aws ec2 describe-images \ 
 --filters "Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-????????" "Name=state,Values=available" \
 --query "reverse(sort_by(Images, &CreationDate))[:1].ImageId" \
 --output text)

aws ec2 create-key-pair \ 
 --key-name MyKeyPair \
 --query 'KeyMaterial' \
 --output text > MyKeyPair.pem
chmod 400 MyKeyPair.pem

aws ec2 create-security-group \
 --group-name user3 \
 --description "Standart user with limits" 


aws_security_group_id=$(aws ec2 describe-security-groups \
 --filters "Name=vps-id,Values=vpc-ee33e84" \
 --query 'SecurityGroups[?GroupName==`user3`].GroupId' \
 --output text)

aws ec2 authorize-security-group-ingress 
 --group-id $aws_security_group_id 
 --protocol tcp --port 22 --cidr 93.170.116.127/32

#aws ec2 autorize-security-group-ingress \
# --group-id $aws_security_group_id \
# --ip-permissions '[{"IpProtocol": "tcp", "FromPort": 22, "ToPort": 80, "IpRanges": [{"CidrIp": "0.0.0.0/0", "Description": "Allow SSh"}]}]' && 
#aws ec2 autorize-security-group-ingress \
# --group-id $aws_security_group_id \
# --ip-permissions '[{"IpProtocol": "tcp", "FromPort": 80, "ToPort": 80, "IpRanges": [{"CidrIp": "0.0.0.0/0", "Dewscription": "Allow HTTP"}]}]'

aws_ec2_inst_id=$(aws ec2 run-instances \
 --image-id $aws_ami_id \
 --count 1 \
 --instance-type t2.micro \
 --key-name MyKeyPair \
 --security-group-ids $aws_security_group_id \
 --user-data file://Documents/bashscripting/userdata.sh
 --query 'Instances[0].InstanceId' \
 --output text)



while true; do
 STATUS=`aws ec2 describe-instances \
 --instance-id $aws_ec2_inst_id \
 --query "Reservation[].Instances[].[State.Name]"
 --o text`
 if [ "$STATUS" == "running" ]
  break
 fi
 sleep 15
done
 
aws_ec2_inst_publicip=$(aws ec2 describe-instances \
 --query "Reservation[*].Instances[*].PublicIpAddress" \
 --output=text) &&
echo $aws_ec2_inst_publicip


