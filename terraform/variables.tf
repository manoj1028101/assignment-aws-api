variable "region" {
  description = "The AWS region to create resources in."
  default     = "us-east-2"
}

variable "aws_access_key" {
    default = ""
}

variable "aws_secret_key" {
    default = ""
}

variable "public_subnet_1_cidr" {
  description = "CIDR Block for Public Subnet 1"
  default     = "10.0.1.0/24"
}

variable "public_subnet_2_cidr" {
  description = "CIDR Block for Public Subnet 2"
  default     = "10.0.2.0/24"
}

variable "private_subnet_1_cidr" {
  description = "CIDR Block for Private Subnet 1"
  default     = "10.0.3.0/24"
}

variable "private_subnet_2_cidr" {
  description = "CIDR Block for Private Subnet 2"
  default     = "10.0.4.0/24"
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
  default     = ["us-east-2a", "us-east-2b"]
}

variable "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  default     = "api-cluster"
}

variable "log_retention_in_days" {
  default = 3
}

variable "amis" {
  description = "Which AMI to spawn."
  default = {
    us-east-2 = "ami-0f58ef99f498a0207"
  }
}
variable "instance_type" {
  default = "t2.micro"
}
variable "docker_image_url_api" {
  description = "Docker image to run in the ECS cluster"
  default     = "271957787021.dkr.ecr.us-east-2.amazonaws.com/api-app:v1.0.0"
}
variable "app_count" {
  description = "Number of Docker containers to run"
  default     = 3
}
