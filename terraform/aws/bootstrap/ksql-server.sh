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

cd /etc/confluent/confluent-5.0.0/etc/ksql

cat > ksql-server-ccloud.properties <<- "EOF"
${ksql_server_properties}
EOF

############# Change Ownership ##############

chown -R ec2-user:ec2-user /etc/confluent

########### Creating the Service ############

cd /lib/systemd/system

cat > ksql-server.service <<- "EOF"
[Unit]
Description=Confluent KSQL Server
After=network.target

[Service]
Type=simple
Restart=always
RestartSec=1
User=ec2-user
ExecStart=/etc/confluent/confluent-5.0.0/bin/ksql-server-start /etc/confluent/confluent-5.0.0/etc/ksql/ksql-server-ccloud.properties
ExecStop=/etc/confluent/confluent-5.0.0/bin/ksql-server-stop /etc/confluent/confluent-5.0.0/etc/ksql/ksql-server-ccloud.properties

[Install]
WantedBy=multi-user.target
EOF

########### Enable and Start ###########

systemctl enable ksql-server
systemctl start ksql-server
