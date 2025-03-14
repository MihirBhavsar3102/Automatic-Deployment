provider "aws" {
  region     = "ap-south-1"
  access_key = "AKIA5G2VG2TXYBMTCZ5A"
  secret_key = "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"
}

# Defined the Security Group
resource "aws_security_group" "allow_ssh_http" {
  name        = "allow_ssh_http"
  description = "Allow SSH and HTTP traffic"

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

# Defined the EC2 instance
resource "aws_instance" "nginx_server" {
  ami           = "ami-00bb6a80f01f03502"
  instance_type = "t2.micro"
  key_name      = "mihir"

  # Used `vpc_security_group_ids` instead of `security_groups`
  vpc_security_group_ids = [aws_security_group.allow_ssh_http.id]

  tags = {
    Name = "nginx-server"
  }

  # Generate Ansible Inventory File
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<EOT
    echo "[web]" > ../ansible-setup/inventory
    echo "${aws_instance.nginx_server.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=/home/mihir/.ssh/mihir.pem" >> ../ansible-setup/inventory
EOT
  }
}

# Output the Public IP
output "instance_ip" {
  value = aws_instance.nginx_server.public_ip
}
