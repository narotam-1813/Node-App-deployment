resource "aws_security_group" "app_sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "ec2_key" {
  key_name   = "MyKeyPair"
  public_key = tls_private_key.ec2_key.public_key_openssh
}

resource "aws_instance" "app_node" {
  ami = var.ami_id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.ec2_key.key_name
  subnet_id = var.subnet_id
  security_groups = [aws_security_group.example.name]

  tags = {
    Name = "NodeJsAppInstance"
  }
}

output "private_key_path" {
    value       = tls_private_key.ec2_key.private_key_pem
    description = "Path to the PEM key file for SSH access"
}

output "public_ip" {
  value = aws_instance.nodejs_instance.public_ip
}