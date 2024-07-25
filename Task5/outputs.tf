
output "load_balancer_dns_name" {
  value = module.alb.alb_dns_name
}

output "efs_id" {
  value = module.efs.efs_id
}
