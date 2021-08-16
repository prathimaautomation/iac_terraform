# Let's create variables for our resources in the main.tf to make use of DRY

variable "aws_key_name"{
    default = "eng89_prathima1"
}

variable "aws_key_path"{
    default = "~/.ssh/eng89_prathima1.pem"
}