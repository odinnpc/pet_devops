resource "aws_instance" "web_server" {
  #count = 2
  ami                    = "ami-0fa91bc90632c73c9" # AMI ID for Ubuntu in us-east-1
  instance_type          = "t3.micro"
  key_name               = "super_duper"
  vpc_security_group_ids = [aws_security_group.nginx_sg.id]
  user_data = templatefile("file_for_terraform.sh.tpl", {
})
  tags = {
    Name = "web_server_terraform"
    #Name = format("instance_terraform_%02d", count.index + 1) # differentiate instances if count > 1
    owner   = "anton_dev_ops"
    project = "terraform_lunch"
  }
  depends_on = [ aws_instance.db_server ]
}
resource "aws_instance" "app_server" {
  #count = 2
  ami                    = "ami-0fa91bc90632c73c9" # AMI ID for Ubuntu in us-east-1
  instance_type          = "t3.micro"
  key_name               = "super_duper"
  vpc_security_group_ids = [aws_security_group.nginx_sg.id]
  user_data = templatefile("file_for_terraform.sh.tpl", {
})
  tags = {
    Name = "app_server_terraform"
    #Name = format("instance_terraform_%02d", count.index + 1) # differentiate instances if count > 1
    owner   = "anton_dev_ops"
    project = "terraform_lunch"
  }
  depends_on = [ aws_instance.db_server ]
}
resource "aws_instance" "db_server" {
  #count = 2
  ami                    = "ami-0fa91bc90632c73c9" # AMI ID for Ubuntu in us-east-1
  instance_type          = "t3.micro"
  key_name               = "super_duper"
  vpc_security_group_ids = [aws_security_group.nginx_sg.id]
  user_data = templatefile("file_for_terraform.sh.tpl", {
})
  tags = {
    Name = "db_server_terraform"
    #Name = format("instance_terraform_%02d", count.index + 1) # differentiate instances if count > 1
    owner   = "anton_dev_ops"
    project = "terraform_lunch"
  }
}
resource "aws_security_group" "nginx_sg" {
  name        = "nginx_security_group"
  description = "Allow HTTP inbound"

dynamic "ingress" {
    for_each = [80, 443]

    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  ingress {
    from_port   = 22
    to_port     = 22
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
resource "aws_eip" "my_permanent_ip" {
  instance = aws_instance.ubuntu_nginx.id
  domain   = "vpc"

  lifecycle {
    create_before_destroy = true
  }
}