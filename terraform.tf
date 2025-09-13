provider "aws" {
  region     = "us-west-2"
}


data "aws_ami" "al2023_latest" {
  most_recent = true
  owners      = ["amazon"] # Official Amazon AMIs

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"] # Intel 64-bit architecture
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


resource "aws_instance" "my_al2023_instance" {
  ami           = data.aws_ami.al2023_latest.id
  instance_type = "t3.micro" # Choose your desired instance type
  tags = {
    Name = "WebServer1"

  user_data = <<-EOF
  }
}