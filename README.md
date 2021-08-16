# Infrastructure as Code using Terraform
![](terraform.png)
## Terraform installation and setting up the path in the env variable
- Securing AWS keys with Terraform
- Setting Env variables for our AWS secret and access keys
- On windows click on windows keys and type settings
- Windows
- In Search, search for and then select: System (Control Panel)
- Click the Advanced system settings link.
- Click Environment Variables. ...
- In the Edit System Variable (or New System Variable) window, specify the value of the PATH environment variable. ...
- Name env variables as AWS_ACCESS_KEY_ID for secret key AWS_SECRET_ACCESS_KEY

## Let's create our Terraform env to access our AMI to launch ec2 instance
### Terrafrom commands:
- terraform init: initialises the terraform with required dependencies of the provider mentioned in the main.tf 

- terraform plan
- terraform apply
- terraform destroy
```python
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
key_name   = "eng89_prathima"

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
}

#  most commonly used commands for terraform:
# terraform plan checks the syntax and validates the instruction we have provided in this script

# once we are happy and outcome is green we could run terraform apply
```

