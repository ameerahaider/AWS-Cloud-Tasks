resource "aws_efs_file_system" "efs" {

  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }

  tags = {
    Name = "${var.name_prefix}-efs"
  }
}

resource "aws_efs_mount_target" "efs_mount" {
  count          = length(var.public_subnet_ids)
  file_system_id = aws_efs_file_system.efs.id
  subnet_id      = var.public_subnet_ids[count.index]

  security_groups = [var.efs_sg]
}
