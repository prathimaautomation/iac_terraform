# Infrastructure as Code using Terraform
![](terraform.png)

## Infrastructure as Code
```
Infrastructure as code, also referred to as IaC, is an IT practice that codifies and manages underlying IT infrastructure as software.
```
### IaC Advantages
- Speed and efficiency
`Automated provisioning and management are faster and more efficient than manual processes.`
- Consistency
`Software developers can use code to provision and deploy servers and applications according to business practices and policies, rather than rely on system administrators in a DevOps environment.`
- Alignment with DevOps
`With the infrastructure setup written as code, it can go through the same version control, automated testing and other steps of a continuous integration and continuous delivery (CI/CD) pipeline that developers use for application code.`

### What is Terraform?
* Terraform is a tool for building, changing, and versioning infrastructure safely and efficiently. Terraform can manage existing and popular service providers as well as custom in-house solutions. Configuration files describe to Terraform the components needed to run a single application or your entire datacenter.

### Benefits of Terraform?
* Terraform modules are useful because they allow complex resources to be automated with re-usable, configurable constructs.
* Cloud independent - works with different cloud providers, allowing for multi-cloud configuration
* Can effectively scale up/down to meet the current load.
* Reduced time to provision and reduced development costs.
* Ease of use.
* Simplicity, it does a lot of work for us behind, in the background.
### Installation
* Download Terraform for the applicable platform here: https://www.terraform.io/downloads.html
* Extract and place the terraform file in a file location of your choice.
* In Search, type and select Edit the system environment variables.
* Click Environment Variables...
* Edit the Path variable in User variables.
* Click New, then add the file path of the terraform file inside
#### Commands
* terraform init: initialises the terraform with required dependencies of the provider mentioned in the main.tf.
* terraform plan: checks the syntax of the code. Lists the jobs to be done (in main.tf).
* terraform apply: launches and executes the tasks in main.tf
* terraform destroy: destroys/terminates services run in main.tf
Creating an EC2 Instance from an AMI

![](VPC.png)

## Let's create our Terraform env to access our AMI to launch ec2 instance

```python
# Let's build a script to connect to AWS and download/setup all dependencies required 

# Provide a region
provider "aws" {
        region = "eu-west-1"
}




# VPC 
resource "aws_vpc" "terraform_vpc" {
  cidr_block       = var.cidr_block_0 
  instance_tenancy = "default"
  # enable_dns_support = true
  # enable_dns_hostnames = true
  
  tags = {
    Name = var.vpc_name
  }
} 



# INTERNET GATEWAY
resource "aws_internet_gateway" "terraform_igw" {
  vpc_id = aws_vpc.terraform_vpc.id
  
  tags = {
    Name = var.igw_name
  }
}





#  PUBLIC SUBNET
resource "aws_subnet" "app_subnet" {
    vpc_id = aws_vpc.terraform_vpc.id
    cidr_block = var.cidr_block_1
    map_public_ip_on_launch = "true" 
    availability_zone = "eu-west-1a"
    tags = {
        Name = var.pub_subnet_name
    }
}


#  Private SUBNET
resource "aws_subnet" "db_subnet" {
    vpc_id = aws_vpc.terraform_vpc.id
    cidr_block = var.cidr_block_2
    map_public_ip_on_launch = "true" 
    availability_zone = "eu-west-1a"
    tags = {
        Name = var.pri_subnet_name
    }
}



# ROUTE TABLE

resource "aws_route_table" "terra_route_table" {
    vpc_id = aws_vpc.terraform_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.terraform_igw.id
    }
    tags = {
        Name = "eng89_prathima_terra_RT"
    }
}

resource "aws_route_table_association" "terra_assoc_RT" {
    subnet_id = aws_subnet.app_subnet.id
    route_table_id = aws_route_table.terra_route_table.id
}





# SECURITY GROUPS
resource "aws_security_group" "pub_sec_group" {
      
  name        = "eng89_prathima_terra_app"
  description = "app security group"
  vpc_id =    aws_vpc.terraform_vpc.id


  ingress {                         # allow to ssh into instance
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip] # MY IP
    }

  ingress {                           # allow  for nginx
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }



  ingress {                         # reverse proxy
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }

  egress {                          # allow all outbound traffic 
    from_port  = 0
    to_port    = 0
    protocol   = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
   Name = "eng89_prathima_terra_public_SG"
  }
}


resource "aws_security_group" "pri_sec_group" {
      
  name        = "eng89_prathima_terra_db"
  description = "db security group"
  vpc_id =    aws_vpc.terraform_vpc.id


  ingress {                         # allow to ssh into instance
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip] # MY IP
    }

  

  ingress {                           # reverse proxy
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = ["10.210.1.0/32"]
    }

  egress {                          # allow all outbound traffic 
    from_port  = 0
    to_port    = 0
    protocol   = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
   Name = "eng89_prathima_terra_private_SG"
  }
}


# NETWORK ACLs
resource "aws_network_acl" "public_nacl" {
  vpc_id = aws_vpc.terraform_vpc.id

  
  ingress {
      protocol   = "tcp"
      rule_no    = 100
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 80
      to_port    = 80
    }



  ingress {
      protocol   = "tcp"
      rule_no    = 120
      action     = "allow"
      cidr_block = var.my_ip # MY IP
      from_port  = 22
      to_port    = 22
    }

  egress {
      protocol   = "tcp"
      rule_no    = 110
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 80
      to_port    = 80
    }

  egress {
      protocol   = "tcp"
      rule_no    = 120
      action     = "allow"
      cidr_block = "10.210.2.0/24"
      from_port  = 27017
      to_port    = 27017
    }



  tags = {
    Name = "eng89_terra_prathima_nACL_pub"
  }
}

# NETWORK ACLs
resource "aws_network_acl" "private_nacl" {
  vpc_id = aws_vpc.terraform_vpc.id

  
  ingress {
      protocol   = "tcp"
      rule_no    = 100
      action     = "allow"
      cidr_block = var.my_ip
      from_port  = 22
      to_port    = 22
    }



  ingress {
      protocol   = "tcp"
      rule_no    = 110
      action     = "allow"
      cidr_block = var.cidr_block_2 # DB
      from_port  = 27017
      to_port    = 27017
    }

  
  ingress {
      protocol   = "tcp"
      rule_no    = 120
      action     = "allow"
      cidr_block = "0.0.0.0/0" 
      from_port  = 1024
      to_port    = 65535
    }

ingress {
      protocol   = "tcp"
      rule_no    = 130
      action     = "allow"
      cidr_block = "0.0.0.0/0" 
      from_port  = 80
      to_port    = 80
    }

ingress {
      protocol   = "tcp"
      rule_no    = 140
      action     = "allow"
      cidr_block = "0.0.0.0/0" 
      from_port  = 443
      to_port    = 443
    }




  egress {
      protocol   = "tcp"
      rule_no    = 100
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 80
      to_port    = 80
    }

  egress {
      protocol   = "tcp"
      rule_no    = 110
      action     = "allow"
      cidr_block = "10.210.1.0/24"
      from_port  = 1024
      to_port    = 65535
    }



  tags = {
    Name = "eng89_terra_prathima_nACL_pri"
  }
}



# APP INSTANCE
resource "aws_instance" "app_instance" {
ami                 = var.app_ami_id
instance_type       = "t2.micro"

subnet_id = aws_subnet.app_subnet.id
associate_public_ip_address = true


vpc_security_group_ids = ["${aws_security_group.pub_sec_group.id}"]


tags = {
      Name = var.app_name   
 }

 key_name = var.aws_key_name # goes to varaible.tf file

#runs commands in instance
# provisioner "file" {
#   source ="script.sh"
#   destination = "/script.sh"
# }

# connection {
#   type        = "ssh"
#   user        = "ubuntu"
#   private_key = file("${var.aws_key_path}")
#   host        = self.public_ip
#  }

}

# DB INSTANCE
resource "aws_instance" "db_instance" {
ami                 = var.db_ami_id
instance_type       = "t2.micro"

subnet_id = aws_subnet.app_subnet.id
associate_public_ip_address = true


vpc_security_group_ids = ["${aws_security_group.pri_sec_group.id}"]


tags = {
      Name = var.db_name   
 }

 key_name = var.aws_key_name # goes to varaible.tf file

}
```
### Let's run the main.tf as below:
- terraform plan #checks the syntax errors
- terraform apply #builds the resources from the code
