provider "aws" {
  region = "eu-north-1"
}

resource "aws_instance" "ubuntu_with_terraform" {
  #count = 3
  ami           = "ami-0fa91bc90632c73c9" # AMI ID for Ubuntu in us-east-1
  instance_type = "t3.micro"
  key_name      = "super_duper"
  vpc_security_group_ids = ["sg-03ad5e817c12f5faf"]


  tags = {
    Name = "instance_terraform_${count.index + 1}" # differentiate instances if count > 1
  }
}