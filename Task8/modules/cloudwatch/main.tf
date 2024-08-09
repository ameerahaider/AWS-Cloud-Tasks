# --- Cloud Watch Logs ---

resource "aws_cloudwatch_log_group" "ecs" {
  name              = "${var.name_prefix}/ecs/"
  retention_in_days = 14
}