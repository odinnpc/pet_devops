resource "aws_security_group" "nginx_sg" {
  name        = "nginx_security_group"
  description = "Allow HTTP inbound"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
   ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "nginx_security_group"
  }
}

resource "aws_instance" "ubuntu_nginx" {
  #count = 2
  ami                    = "ami-0fa91bc90632c73c9" # AMI ID for Ubuntu in us-east-1
  instance_type          = "t3.micro"
  key_name               = "super_duper"
  vpc_security_group_ids = [aws_security_group.nginx_sg.id]
  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y nginx
              sudo systemctl start nginx
              sudo systemctl enable nginx
              EOF

  tags = {
    Name = "instance_terraform"
    #Name = format("instance_terraform_%02d", count.index + 1) # differentiate instances if count > 1
    owner   = "anton_dev_ops"
    project = "terraform_lunch"
  }
}