provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "monitoring" {
  ami           = "ami-002f6e91abff6eb96" # Amazon Linux 2 AMI
  instance_type = "t2.micro"
  key_name      = "first-key.pem"

  security_groups = [aws_security_group.prometheus_sg.name]

  tags = {
    Name = "Prometheus-Grafana-Server"
  }

  user_data = file("install_prometheus_grafana.sh") # Add your shell script here
}

resource "aws_security_group" "prometheus_sg" {
  name = "prometheus-grafana-sg"

  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
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
