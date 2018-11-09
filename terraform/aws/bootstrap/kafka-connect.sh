#!/bin/bash

########### Update and Install ###########

yum update -y
yum install java-1.8.0-openjdk-devel.x86_64 -y

########### Initial Bootstrap ###########

cd /home/ec2-user
wget ${confluent_platform_location}
unzip confluent-5.0.0-2.11.zip
mkdir /etc/confluent
mv confluent-5.0.0 /etc/confluent
mkdir /etc/confluent/confluent-5.0.0/etc/kafka-connect

########### Generating Props File ###########

cd /etc/confluent/confluent-5.0.0/etc/kafka-connect

cat > kafka-connect-ccloud.properties <<- "EOF"
${kafka_connect_properties}
EOF

############# Change Ownership ##############

chown -R ec2-user:ec2-user /etc/confluent

########### Creating the Service ############

cd /lib/systemd/system

cat > kafka-connect.service <<- "EOF"
[Unit]
Description=Kafka Connect

[Service]
Type=simple
Restart=always
RestartSec=1
User=ec2-user
ExecStart=/etc/confluent/confluent-5.0.0/bin/connect-distributed /etc/confluent/confluent-5.0.0/etc/kafka-connect/kafka-connect-ccloud.properties

[Install]
WantedBy=multi-user.target
EOF

########### Enable and Start ###########

systemctl enable kafka-connect
systemctl start kafka-connect