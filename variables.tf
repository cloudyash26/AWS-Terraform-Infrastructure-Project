variable "cidr_block" {
    default = "10.0.0.0/16"
}



variable "ami" {
    default = "ami-084568db4383264d4"
}

variable "instance_type" {
    default = "t2.micro"
}

variable "aws_s3_bucket" {
  default = "ysshdemo-s3bucket"
}