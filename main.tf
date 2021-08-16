# Let's build a script to connect to AWS and download/setup all dependencies required
# keyword: provider aws
provider "aws" {
       region = "eu-west-1"	
}

# then we will run terraform init

# then will move onto launch aws services

# Let's launch an ec2 instance in eu-west-1 with 

# keyword called "resource" provide resource name and give name with specific details to the service
resource "aws_instance" "app_instance" {

# resource aws_ec2_instance, name it as eng89_prathima_terraform, ami, type of instance, with or without ip,
# provide valid ami id
ami = "ami-038d7b856fe7557b3"

# provide what type of instance you would like to create 
instance_type = "t2.micro"

# we would like public ip for this instance
associate_public_ip_address = true

#Let's give proper name to this instance using tags (tags is the keyword to name the instance)
tags = {
	 Name = "eng89_prathima_terraform"
  }

  key_name   = var.aws_key_name
}

#  most commonly used commands for terraform:
# terraform plan checks the syntax and validates the instruction we have provided in this script

# once we are happy and outcome is green we could run terraform apply
