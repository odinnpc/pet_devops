/*
provider "aws" {
  region = "eu-north-1"
}

resource "aws_instance" "ubuntu_with_terraform" {
  #count = 2
  ami                    = "ami-0fa91bc90632c73c9" # AMI ID for Ubuntu in us-east-1
  instance_type          = "t3.micro"
  key_name               = "super_duper"
  vpc_security_group_ids = ["sg-03ad5e817c12f5faf"]


  tags = {
    Name = "instance_terraform"
    #Name = format("instance_terraform_%02d", count.index + 1) # differentiate instances if count > 1
    owner   = "anton_dev_ops"
    project = "terraform_lunch"
  }
}
*/