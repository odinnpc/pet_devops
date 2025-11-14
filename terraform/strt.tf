provider "aws" {
  region = "eu-north-1"
}

resource "aws_instance" "terraform_instance" {
  ami           = "ami-0fa91bc90632c73c9" # AMI ID for Ubuntu in us-east-1
  instance_type = "t3.micro"
  #key_name      = "my-keypair"

  tags = {
    Name = "ItsUbuntuInstance"
  }
}