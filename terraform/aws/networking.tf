###########################################
################### VPC ###################
###########################################
resource "aws_vpc" "default" {
    
    cidr_block = "10.0.0.0/16"

    tags {

        Name = "ccloud-tools"

    }

}

resource "aws_internet_gateway" "default" {

  vpc_id = "${aws_vpc.default.id}"

    tags {

        Name = "ccloud-tools"

    }

}

resource "aws_eip" "default" {

  depends_on = ["aws_internet_gateway.default"]
  vpc = true

    tags {

        Name = "ccloud-tools"

    }

}

resource "aws_nat_gateway" "default" {

    depends_on = ["aws_internet_gateway.default"]

    allocation_id = "${aws_eip.default.id}"
    subnet_id = "${aws_subnet.public_subnet_1.id}"

    tags {

        Name = "ccloud-tools"

    }

}

resource "aws_route" "default" {

  route_table_id = "${aws_vpc.default.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.default.id}"

}

resource "aws_route_table" "private_route_table" {

  vpc_id = "${aws_vpc.default.id}"

  tags {

    Name = "private-route-table"

  }

}

resource "aws_route" "private_route_2_internet" {

  route_table_id = "${aws_route_table.private_route_table.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = "${aws_nat_gateway.default.id}"

}

resource "aws_route_table_association" "public_subnet_1_association" {

    subnet_id = "${aws_subnet.public_subnet_1.id}"
    route_table_id = "${aws_vpc.default.main_route_table_id}"

}

resource "aws_route_table_association" "public_subnet_2_association" {

    subnet_id = "${aws_subnet.public_subnet_2.id}"
    route_table_id = "${aws_vpc.default.main_route_table_id}"

}

resource "aws_route_table_association" "private_subnet_1_association" {

    subnet_id = "${aws_subnet.private_subnet_1.id}"
    route_table_id = "${aws_route_table.private_route_table.id}"

}

resource "aws_route_table_association" "private_subnet_2_association" {

    subnet_id = "${aws_subnet.private_subnet_2.id}"
    route_table_id = "${aws_route_table.private_route_table.id}"

}

###########################################
################# Subnets #################
###########################################

data "aws_subnet_ids" "private" {

  vpc_id = "${aws_vpc.default.id}"

  filter {

    name = "tag:Name"
    values = ["private-subnet"]

  }

}

resource "aws_subnet" "private_subnet_1" {

  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = false
  availability_zone = "${element(var.aws_availability_zones, 0)}"

    tags {

        Name = "private-subnet"

    }    

}

resource "aws_subnet" "private_subnet_2" {

  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = false
  availability_zone = "${element(var.aws_availability_zones, 1)}"

    tags {

        Name = "private-subnet"

    }    

}

resource "aws_subnet" "public_subnet_1" {

  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "10.0.3.0/24"
  map_public_ip_on_launch = true
  availability_zone = "${element(var.aws_availability_zones, 0)}"

    tags {

        Name = "public-subnet"

    }    

}

resource "aws_subnet" "public_subnet_2" {

  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "10.0.4.0/24"
  map_public_ip_on_launch = true
  availability_zone = "${element(var.aws_availability_zones, 1)}"

    tags {

        Name = "public-subnet"

    }    

}

###########################################
############# Security Groups #############
###########################################

resource "aws_security_group" "load_balancer" {

  name = "load-balancer"
  description = "Load Balancer"
  vpc_id = "${aws_vpc.default.id}"

  ingress {

    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {

    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    
  }  
  
}

resource "aws_security_group" "schema_registry" {

  name = "schema-registry"
  description = "Schema Registry"
  vpc_id = "${aws_vpc.default.id}"

  ingress {

    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.5.0/24"]

  }

  ingress {

    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"

    cidr_blocks = ["10.0.1.0/24",
                   "10.0.2.0/24",
                   "10.0.3.0/24",
                   "10.0.4.0/24"]

  }

  egress {

    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    
  }  
  
}

resource "aws_security_group" "rest_proxy" {

  name = "rest-proxy"
  description = "REST Proxy"
  vpc_id = "${aws_vpc.default.id}"

  ingress {

    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.5.0/24"]

  }

  ingress {

    from_port   = 8082
    to_port     = 8082
    protocol    = "tcp"

    cidr_blocks = ["10.0.1.0/24",
                   "10.0.2.0/24",
                   "10.0.3.0/24",
                   "10.0.4.0/24"]

  }

  egress {

    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    
  }  
  
}

resource "aws_security_group" "kafka_connect" {

  name = "kafka-connect"
  description = "Kafka Connect"
  vpc_id = "${aws_vpc.default.id}"

  ingress {

    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.5.0/24"]

  }

  ingress {

    from_port   = 8083
    to_port     = 8083
    protocol    = "tcp"

    cidr_blocks = ["10.0.1.0/24",
                   "10.0.2.0/24",
                   "10.0.3.0/24",
                   "10.0.4.0/24"]

  }

  egress {

    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    
  }  
  
}

resource "aws_security_group" "ksql_server" {

  name = "ksql-server"
  description = "KSQL Server"
  vpc_id = "${aws_vpc.default.id}"

  ingress {

    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.5.0/24"]

  }

  ingress {

    from_port   = 8088
    to_port     = 8088
    protocol    = "tcp"

    cidr_blocks = ["10.0.1.0/24",
                   "10.0.2.0/24",
                   "10.0.3.0/24",
                   "10.0.4.0/24"]

  }

  egress {

    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    
  }  
  
}

resource "aws_security_group" "control_center" {

  name = "control-center"
  description = "Control Center"
  vpc_id = "${aws_vpc.default.id}"

  ingress {

    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.5.0/24"]

  }

  ingress {

    from_port   = 9021
    to_port     = 9021
    protocol    = "tcp"

    cidr_blocks = ["10.0.1.0/24",
                   "10.0.2.0/24",
                   "10.0.3.0/24",
                   "10.0.4.0/24"]

  }

  egress {

    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    
  }  
  
}