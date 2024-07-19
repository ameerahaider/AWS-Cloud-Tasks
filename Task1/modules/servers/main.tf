resource "aws_instance" "main_server" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  user_data                   = var.user_data

  tags = {
    Name = "${var.name_prefix}-server"
  }
}
