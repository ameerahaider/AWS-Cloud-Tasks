

output "ecr_repo_url" {
  value = module.ecr.ecr_repo_url
}

output "load_balancer_dns_name" {
  value = module.alb.alb_dns_name
}