# ami variable
variable "ami" {
  description = "ami-id"
  type        = string
  default     = "ami-00beae93a2d981137"
}

#Region
variable "region" {
  description = "region"
  type        = string
  default     = "us-east-1"
}
# instance type
variable "instance" {
  description = "instance_type"
  type        = string
  default     = "t2.micro"
}
#Jenkins bootstrap
variable "user_data" {
  description = "jenkins"
  type        = string
  default     = <<-EOF
   #!/bin/bash

  sudo yum update -y
  sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
  sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
  sudo yum install java-17-amazon-corretto -y
  sudo yum install jenkins -y
  sudo systemctl enable jenkins
  sudo systemctl start jenkins
  sudo systemctl status jenkins
  EOF
}
