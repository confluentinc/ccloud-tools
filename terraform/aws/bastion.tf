################################################################################
##### Bastion Server: Feel free to un-comment this section if you need SSH #####
##### access to the internal compute instances through a bastion server.   #####
################################################################################

/*

data "template_file" "bastion_server_bootstrap" {

  template = <<EOT

    #!/bin/bash
    yum update -y

  EOT
  
}

resource "aws_subnet" "bastion_server" {

  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "10.0.9.0/24"
  map_public_ip_on_launch = true
  availability_zone = "${element(var.aws_availability_zones, 0)}"

    tags {

        Name = "bastion-server"

    }    

}

resource "aws_security_group" "bastion_server" {

  name = "bastion-server"
  description = "Bastion Server"
  vpc_id = "${aws_vpc.default.id}"

  ingress {

    from_port = 22
    to_port = 22
    protocol = "tcp"

    // For security reasons, it
    // is recommended to set your
    // public IP address here, so
    // the bastion server is only
    // accessible from your end.

    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {

    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }  

}

resource "aws_instance" "bastion_server" {

  ami = "ami-0922553b7b0369273"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.generated_key.key_name}"

  subnet_id = "${aws_subnet.bastion_server.id}"
  vpc_security_group_ids = ["${aws_security_group.bastion_server.id}"]

  user_data = "${data.template_file.bastion_server_bootstrap.rendered}"

  ebs_block_device {

    device_name = "/dev/xvdb"
    volume_type = "gp2"
    volume_size = 10

  }

  tags {

    Name = "bastion-server"

  }

}

output "Bastion Server Public IP Address" {

  value = "${aws_instance.bastion_server.public_ip}"

}
output "Bastion Server Private Key" {

  value = "${tls_private_key.key_pair.private_key_pem}"

}

*/