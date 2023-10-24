terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.67.0"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
}

variable "acl_cidrs"{
}

variable "eip_id" {
}

resource "aws_security_group" "hackthebox_vpn" {
  name        = "hackthebox_vpn"
  description = "only allow VPN users"
  ingress {
    description = "allow all in"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.acl_cidrs
  }
  egress {
    description = "allow all out"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "tls_private_key" "htb-search" {
  algorithm = "ED25519"
}

resource "aws_key_pair" "ssh" {
  key_name   = "htb-search"
  public_key = tls_private_key.htb-search.public_key_openssh
}

resource "aws_eip_association" "htb-search" {
  instance_id = aws_instance.htb-search.id
  allocation_id = var.eip_id
}

resource "aws_instance" "htb-search" {
  ami                         = data.aws_ami.debian.id
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.ssh.key_name
  associate_public_ip_address = true
  security_groups             = ["${aws_security_group.hackthebox_vpn.name}"]
  user_data = templatefile("cloud-init.yaml", {
    files = [
      {
        path : "/etc/nginx/sites-available/default"
        defer : true
        content : file("nginx.conf")
      },
      {
        path : "/var/www/html/index.php"
        content : file("index.php")
      },
      {
        path : "/var/www/html/add_bookmark.php"
        content : file("add_bookmark.php")
      },
      {
        path : "/var/www/html/search.php"
        content : file("search.php")
      },
      {
        path : "/etc/redis/redis.conf"
        content : file("redis.conf")
      },
      {
        path : "/var/www/html/styles.css"
        content : file("styles.css")
      },
      {
        path : "/var/cache/redis/dump.rdb"
        encoding: "base64"
        owner: "redis:redis"
        content : filebase64("dump.rdb")
      }
  ] })
  tags = {
    Name = "htb-search"
  }
}

resource "local_file" "key" {
  content         = tls_private_key.htb-search.private_key_openssh
  filename        = "htb-search.pem"
  file_permission = "0600"
}

data "aws_ami" "debian" {
  most_recent = true

  filter {
    name   = "name"
    values = ["debian-11-amd64-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["136693071363"]
}

output "server-ip" {
  value = aws_instance.htb-search.public_ip
}
