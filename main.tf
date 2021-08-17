# Let's build a script to connect to AWS and download/setup all dependencies required
# keyword: provider aws
provider "aws" {
       region = "eu-west-1"	
}

# Let's build a vpc 
resource "aws_vpc" "terraform_vpc_code_test" {
  cidr_block       = var.cidr_block 
  instance_tenancy = "default"
  enable_dns_support = true # gives you an internal domain name
  enable_dns_hostnames = true # gives you an internal host name

  tags = {
    Name = var.vpc_name
  }
}

#Let's create subnet for the app
resource "aws_subnet" "app_subnet"{
       vpc_id = var.vpc_id
       cidr_block = "10.210.2.0/24"
       availability_zone = "eu-west-1a"
       tags = {
              Name = "eng89_prathima_terraform_app_subnet"
       }
}

# Create Internet Gateway
resource "aws_internet_gateway" "terraform_igw"{
       vpc_id = aws_vpc.terraform_vpc_code_test.id

       tags = {
              Name = var.igw_name
       }
}

resource "aws_security_group" "pub_sec_group"{
       name        = "eng89_prathima_terraform_SG_app"
       description = "app security group"
       vpc_id      = aws_vpc.terraform_vpc_code_test.id

# Inbound rules for webapp
# Inbound rules code block:
ingress { #ingress is for inbound rules
  from_port  = 80 # for our app to launch in the browser
  to_port    = 80 # for our app to launch in the browser
  protocol   = "HTTP"
  cidr_blocks = ["0.0.0.0/0"] # allow all
}
ingress { 
  from_port  = 443 
  to_port    = 443 
  protocol   = "tcp"
  cidr_blocks = ["0.0.0.0/0"] # allow all
}
ingress { 
  from_port  = 3000 
  to_port    = 3000
  protocol   = "tcp"
  cidr_blocks = ["0.0.0.0/0"] # allow all
}


# Outbound rules code block
egress { # egress for outbound rules
  from_port   = 0
  to_port     = 0
  protocol    = "-1" # allow all
  cidr_blocks = ["0.0.0.0/0"]

}
tags = {
  Name = "eng89_prathima_terraform_public_SG"
}

}

resource "aws_security_group_rule" "my_ssh" {
       type           = "ingress"
       from_port      = 22
       to_port        = 22
       protocol       = "tcp"
       cidr_blocks    = [var.my_ip]
       security_group_id = aws_security_group.pub_sec_group.id
}

resource "aws_security_group_rule" "vpc_access" {
       type           = "ingress"
       from_port      = 0
       to_port        = 0
       protocol       = "-1"
       cidr_blocks    = [var.cidr_block]
       security_group_id = aws_security_group.pub_sec_group.id
}
# keyword called "resource" provide resource name and give name with specific details to the service
resource "aws_instance" "app_instance" {

# resource aws_ec2_instance, name it as eng89_prathima_terraform, ami, type of instance, with or without ip,
# provide valid ami id
ami = "ami-026754d4887301d2a"

# provide what type of instance you would like to create 
instance_type = "t2.micro"
subnet_id = aws_subnet.app_subnet.id

# we would like public ip for this instance
associate_public_ip_address = true

#Let's give proper name to this instance using tags (tags is the keyword to name the instance)
tags = {
	 Name = "eng89_prathima_terraform_app"
  }

  key_name   = var.aws_key_name
}
