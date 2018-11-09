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

########### Generating Props File ###########

cd /etc/confluent/confluent-5.0.0/etc/kafka-rest

cat > kafka-rest-ccloud.properties <<- "EOF"
${rest_proxy_properties}
EOF

############# Change Ownership ##############

chown -R ec2-user:ec2-user /etc/confluent

########### Creating the Service ############

cd /lib/systemd/system

cat > kafka-rest.service <<- "EOF"
[Unit]
Description=Confluent Kafka REST
After=network.target

[Service]
Type=simple
Restart=always
RestartSec=1
User=ec2-user
ExecStart=/etc/confluent/confluent-5.0.0/bin/kafka-rest-start /etc/confluent/confluent-5.0.0/etc/kafka-rest/kafka-rest-ccloud.properties
ExecStop=/etc/confluent/confluent-5.0.0/bin/kafka-rest-stop /etc/confluent/confluent-5.0.0/etc/kafka-rest/kafka-rest-ccloud.properties

[Install]
WantedBy=multi-user.target
EOF

########### Enable and Start ###########

systemctl enable kafka-rest
systemctl start kafka-rest