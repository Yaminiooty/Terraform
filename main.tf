terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~>3.0"
        }
    }
} 

#configure aws provider

provider "aws" {
  region = "us-east-2"
  
}

# creating VPC

resource "aws_vpc" "MyLab-VPC" {
        cidr_block = "172.20.0.0/16"

        tags = {
            Name = "MyLab-VPC"
        }

}

# create public subnet

resource "aws_subnet" "MyLab-Public-Subnet" {
    vpc_id = aws_vpc.MyLab-VPC.id
    cidr_block = "172.20.10.0/16"

    tags = {
      Name = "MyLab-Public-Subnet"
    }
  
}

#create internet gateway

resource "aws_internet_gateway" "MyLab-IG" {
    vpc_id = aws_vpc.MyLab-VPC.id
     
     tags = {
         Name = "MyLab-IG"
     }
  
}

#create security group

resource "aws_security_group" "MyLab-SG" {
      name = "MyLab-SG"
      description = "To allow inbound and outbound rules"
      vpc_id = aws_vpc.MyLab-VPC.id

     dynamic  ingress  {
         iterator = port
         for_each = var.ports
         content {
          from_port = port.value
          to_port = port.value
          protocol = "tcp"  
          cidr_blocks = ["0.0.0.0/0"]
         }
         
      }

      egress {
          from_port = 0
          to_port = 0
          protocol = "-1"   
          cidr_blocks = ["0.0.0.0/0"]
      }

     tags = {
         Name = "allow traffic"
     }
}

#create route table and association

resource "aws_route_table" "MyLab-RT" {
    vpc_id = aws_vpc.MyLab-VPC.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.MyLab-IG.id
    }
    tags = {
        Name = "MyLab-RT"
    }
}

resource "aws_route_table_association" "MyLab-association" {
  subnet_id = aws_subnet.MyLab-Public-Subnet.id
  route_table_id = aws_route_table.MyLab-RT.id
} 

#create ec2 instance
 
 resource "aws_instance" "MyLab-instance" {
     ami = "ami-02d1e544b84bf7502"
     instance_type = "t2.micro"
     key_name = SAI NEW
     vpc_security_group_ids = [aws_security_group.MyLab-SG.id]
     subnet_id = aws_subnet.MyLab-Public-Subnet.id
     associate_public_ip_address = true
   tags = {
       Name = "MyLab-instance"
   }
 }
