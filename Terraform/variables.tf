variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "ssh_key_name" {
  description = "Name of existing AWS keypair for SSH access"
  type        = string
}

variable "wg_port" {
  description = "WireGuard listen port"
  type        = number
  default     = 51820
}
