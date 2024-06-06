# Create an EC2 instance
resource "aws_instance" "Mywebsite" {
  ami                    = var.ami
  instance_type          = var.instance
  user_data              = var.user_data
  vpc_security_group_ids = [aws_security_group.jenkinssg1.id]

  tags = {
    Name = "HelloWorld"
  }
}

# Create default VPC
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

# Create Security Group for Jenkins that allows traffic on port 22 from your IP and allows traffic from port 8080.
resource "aws_security_group" "jenkinssg1" {
  name   = "jenkinssg1"
  vpc_id = aws_default_vpc.default.id

  ingress {
    description = "SSH traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Access Jenkins"
    from_port   = 8080
    to_port     = 8080
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
    Name = "jenkinssg1"
  }
}

# Create another Security Group to be attached to the instance later
resource "aws_security_group" "my-new-security-group" {
  name   = "my-new-security-group"
  vpc_id = aws_default_vpc.default.id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS"
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
    Name = "my-new-security-group"
  }
}
 # Create S3 Bucket
resource "aws_s3_bucket" "terraformBucket11" {
  bucket = "terraformproject112"

  tags = {
    Name    = "S3_Bucket"
    Purpose = "Jenkins Artifacts"
  }
}

# Public Access Block for S3 Bucket
resource "aws_s3_bucket_public_access_block" "terraformBucket11" {
  bucket = aws_s3_bucket.terraformBucket11.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  depends_on = [
    aws_s3_bucket.terraformBucket11
  ]
}
