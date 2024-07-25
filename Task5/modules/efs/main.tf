resource "aws_efs_file_system" "efs" {

  tags = {
    Name = "${var.name_prefix}-efs"
  }
}

resource "aws_efs_mount_target" "efs_mount" {
  count          = length(var.private_subnets_ids)
  file_system_id = aws_efs_file_system.efs.id
  subnet_id      = var.private_subnets_ids[count.index]

  security_groups = [var.efs_security_group_id]
}
