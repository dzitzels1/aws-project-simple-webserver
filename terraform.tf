provider "aws" {
  region = "us-west-2"
}

resource "aws_s3_bucket" "dznet-config-ec2" {
  bucket = "dznet-config-ec2" # Replace with a globally unique bucket name
  tags = {
    name = "dznet-config-ec2"
  }
}

resource "aws_iam_instance_profile" "test_profile" {
  name = "test_profile"
  role = aws_iam_role.role.name
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "role" {
  name               = "test_role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}


resource "aws_s3_bucket_object" "user_data" {
  bucket       = "dznet-config-ec2"
  key          = "user_data.sh"
  source       = "./user_data.sh"
  content_type = "text/x-shellscript"
}

data "aws_s3_bucket_object" "user_data_object" {
  bucket = aws_s3_bucket.dznet-config-ec2.id
  key    = aws_s3_bucket_object.user_data.key
}

resource "aws_iam_instance_profile" "example_profile" {
  name = "example_profile"
  role = aws_iam_role.example_role.name
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
  instance_type = "t3.micro"
  role          = aws_iam_role.S3ReadOnlyRole.name
  tags = {
    Name = "WebServer1"
  }
  user_data = base64encode(data.aws_s3_bucket_object.user_data_object.body)
}

