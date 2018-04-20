variable "key_name" {
  default = "my_key"
}

variable "ami_id" {
  default = "ami-0ee66876"
}

variable "root_volume_size_gb" {
  default = 250
}

variable "instance_type" {
  default = "t2.medium"
}

variable "vpc_id" {
  default = "some-vpc-id-here"
}

variable "subnet_id" {
  default = "some-subnet-id-here"
}

variable "rg_name" {
  description = "Resource Group name"
  default = "test_jenkins"
}
