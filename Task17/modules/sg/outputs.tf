output "control-lane-sg-id" {
  value       = aws_security_group.control-plane-sg.id
}

output "node-instance-sg-id" {
  value       = aws_security_group.node-instance-sg.id
}