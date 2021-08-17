# Let's create variables for our resources in the main.tf to make use of DRY


variable "name" {
  default="eng89_prathima_terraform_app"
}

variable "app_ami_id"{
    default = "ami-026754d4887301d2a"
}
variable "vpc_id" {
  default="vpc-07e47e9d90d2076da"
}

variable "vpc_name"{
    default = "eng89_prathima_terraform_vpc"

}

variable "cidr_block"{
    default = "10.210.0.0/16"
}
variable "igw_name"{
    default = "eng89_prathima_terraform_igw"
}

variable "aws_subnet"{

    default = "eng89_prathima_terraform_subnet"
}

variable "my_ip" {

  default = "2.100.4.137/32"

}

variable "aws_key_name"{
    default = "eng89_prathima1"
}

variable "aws_key_path"{
    default = "~/.ssh/eng89_prathima1.pem"
}