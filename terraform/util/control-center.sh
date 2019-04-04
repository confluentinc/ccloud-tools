#!/bin/bash

########### Update and Install ###########

yum update -y
yum install wget -y
yum install unzip -y
yum install java-1.8.0-openjdk-devel.x86_64 -y

########### Initial Bootstrap ###########

cd /tmp
wget ${confluent_platform_location}
unzip confluent-5.2.1-2.12.zip
mkdir /etc/confluent
mv confluent-5.2.1 /etc/confluent
mkdir ${confluent_home_value}/data

########### Generating Props File ###########

cd ${confluent_home_value}/etc/confluent-control-center

cat > c3-ccloud.properties <<- "EOF"
${control_center_properties}
EOF

########### Creating the Service ############

cat > /lib/systemd/system/control-center.service <<- "EOF"
[Unit]
Description=Confluent Control Center

[Service]
Type=simple
Restart=always
RestartSec=1
ExecStart=${confluent_home_value}/bin/control-center-start ${confluent_home_value}/etc/confluent-control-center/c3-ccloud.properties
ExecStop=${confluent_home_value}/bin/control-center-stop ${confluent_home_value}/etc/confluent-control-center/c3-ccloud.properties

[Install]
WantedBy=multi-user.target
EOF

########### Enable and Start ###########

systemctl enable control-center
systemctl start control-center
