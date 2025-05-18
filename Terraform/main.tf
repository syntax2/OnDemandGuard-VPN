provider "aws" {
  region = var.aws_region
}

# 1. Create a Security Group allowing WireGuard UDP port
resource "aws_security_group" "wg_sg" {
  name        = "wg-sg"
  description = "Allow WireGuard"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "WireGuard UDP"
    from_port   = var.wg_port
    to_port     = var.wg_port
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 2. Create a VPC + subnet (basic network)
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

# 3. EC2 instance to host WireGuard
resource "aws_instance" "wg_server" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.main.id
  vpc_security_group_ids      = [aws_security_group.wg_sg.id]
  associate_public_ip_address = true
  key_name                    = var.ssh_key_name

  # User data to install and configure WireGuard
  user_data = file("${path.module}/scripts/bootstrap.sh")

  tags = {
    Name = "OnDemandGuardVPN"
  }
}

# 4. Allocate Elastic IP
resource "aws_eip" "wg_eip" {
  instance = aws_instance.wg_server.id
  vpc      = true
}

# 5. Outputs
output "server_public_ip" {
  description = "Public IP of WireGuard server"
  value       = aws_eip.wg_eip.public_ip
}
