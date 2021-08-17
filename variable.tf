  
# let's create variable fo rour resources in mian.tf to make use of DRY


variable "cidr_block_0" {
  default="10.210.0.0/16"
}


variable "cidr_block_1" {
  default="10.210.1.0/24"
}


variable "cidr_block_2" {
  default="10.210.2.0/24"
}


variable "vpc_name" {
  default = "eng89_prathima_terra_vpc"
}



variable "pub_subnet_name" {
  default = "eng89_prathima_terra_subnet_public"
}

variable "pri_subnet_name" {
  default = "eng89_prathima_terra_subnet_private"
}

variable "vpc_id" {

  default = "vpc-07e47e9d90d2076da"
}



variable "igw_name" {
  default = "eng89_prathima_terra_IG"
}



variable "app_ami_id" {
  default="ami-026754d4887301d2a" # ansible app ami
}

variable "db_ami_id" {
  default="ami-08abee4e4ddf9b9ba" # ansible app ami
}

# Let's creatge a variable to apply DRY

variable "app_name" {
  default="eng89_prathima_terra_app"
}
variable "db_name" {
  default="eng89_prathima_terra_db"
}

variable "my_ip" {

  default = "2.100.4.137/32"

}

variable "aws_key_name" {
  default = "eng89_prathima1"
}

variable "aws_key_path" {

  default = "~/.ssh/eng89_prathima1.pem"
}