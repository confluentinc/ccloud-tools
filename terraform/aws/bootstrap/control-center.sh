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
mkdir /etc/confluent/confluent-5.0.0/data

########### Generating Props File ###########

cd /etc/confluent/confluent-5.0.0/etc/confluent-control-center

cat > c3-ccloud.properties <<- "EOF"
${control_center_properties}
EOF

############# Change Ownership ##############

chown -R ec2-user:ec2-user /etc/confluent

########### Creating the Service ############

cd /lib/systemd/system

cat > control-center.service <<- "EOF"
[Unit]
Description=Confluent Control Center

[Service]
Type=simple
Restart=always
RestartSec=1
User=ec2-user
ExecStart=/etc/confluent/confluent-5.0.0/bin/control-center-start /etc/confluent/confluent-5.0.0/etc/confluent-control-center/c3-ccloud.properties
ExecStop=/etc/confluent/confluent-5.0.0/bin/control-center-stop /etc/confluent/confluent-5.0.0/etc/confluent-control-center/c3-ccloud.properties

[Install]
WantedBy=multi-user.target
EOF

########### Enable and Start ###########

systemctl enable control-center
systemctl start control-center