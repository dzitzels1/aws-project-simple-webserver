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

resource "aws_s3_bucket" "dznet-config-ec2" {
      bucket = "dznet-config-ec2" # Replace with a globally unique bucket name
      tags = {
          name = "dznet-config-ec2"
      }
    }

resource "aws_iam_role" "S3ReadOnlyRole" {
  name = "S3ReadOnlyRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "example_attachment" {
  role       = aws_iam_role.eS3ReadOnlyRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}


resource "aws_iam_instance_profile" "example_profile" {
  name = "example_profile"
  role = aws_iam_role.example_role.name
}

resource "aws_instance" "my_al2023_instance" {
  ami           = data.aws_ami.al2023_latest.id
  instance_type = "t3.micro" # Choose your desired instance type
  tags = {
    Name = "WebServer1"

  user_data = <<-EOF
  }
}