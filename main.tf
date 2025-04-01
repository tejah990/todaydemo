provider "aws" {
    region = "us-east-1"  # Specify the AWS region
  }
 
  # Create a random ID for the S3 bucket name
  resource "random_id" "unique_id" {
    byte_length = 8  # Generates a random ID of 8 bytes
  }
 
  # Create an S3 bucket with a valid name
  resource "aws_s3_bucket" "example" {
    bucket = "my-unique-s3-bucket-${random_id.unique_id.hex}"  # Valid S3 bucket name
  }
 
  # Fetch the latest Amazon Linux 2 AMI for the region
  data "aws_ami" "amazon_linux" {
    most_recent = true
    owners      = ["amazon"]  # Filter to Amazon-owned AMIs
    filter {
      name   = "name"
      values = ["amzn2-ami-hvm-*-x86_64-gp2"]  # Filter for Amazon Linux 2 AMIs
    }
  }
 
  # Create an EC2 instance using the fetched Amazon Linux 2 AMI ID
  resource "aws_instance" "example" {
    ami           = data.aws_ami.amazon_linux.id  # Dynamically retrieve the AMI ID
    instance_type = "t2.micro"
 
    tags = {
      Name = "ExampleInstance"
    }
  }
 
  # Output the S3 bucket name and EC2 instance ID
  output "s3_bucket_name" {
    value = aws_s3_bucket.example.bucket
  }
 
  output "ec2_instance_id" {
    value = aws_instance.example.id
  }
