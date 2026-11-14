data "aws_key_pair" "existing" {
  key_name = "taskManagerApp-SSHkey"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_instance" "web_app" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  key_name                    = data.aws_key_pair.existing.key_name
  vpc_security_group_ids      = [var.webapp_sg_id]
  subnet_id                   = var.public_subnet_ids
  associate_public_ip_address = true
  user_data_replace_on_change = true // with this terraform will destroy, create a new EC2 instance and execute the new user_data.sh during boot 
  tags = {
    Name = "task-manager-app"
  }
  user_data = templatefile("${path.module}/user_data.sh",
    {
      redis_host = var.redis_host
      secret_key = var.secret_key
      image_tag  = var.image_tag
    }
  )
}
