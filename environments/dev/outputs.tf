output "vpc_id" {
  value = module.networking.vpc_id
}
output "public_subnet_ids" {
  value = module.networking.public_subnet_ids
}
output "private_app_subnet_ids" {
  value = module.networking.private_app_subnet_ids
}
output "private_db_subnet_ids" {
  value = module.networking.private_db_subnet_ids
}
output "database_subnet_group_name" {
  value = module.networking.database_subnet_group_name
}

output "alb_security_group_id" {
  description = "ALB security group ID"
  value       = module.security_groups.alb_security_group_id
}

output "app_security_group_id" {
  description = "Application security group ID"
  value       = module.security_groups.app_security_group_id
}

output "db_security_group_id" {
  description = "Database security group ID"
  value       = module.security_groups.db_security_group_id
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "ecr_repository_url" {
  value = module.ecr.repository_url
}

output "ecs_cluster_name" {
  value = module.ecs.cluster_name
}

output "ecs_service_name" {
  value = module.ecs.service_name
}

output "db_endpoint" {
  value = module.database.db_endpoint
}

output "db_identifier" {
  value = module.database.db_identifier
}

output "db_master_secret_arn" {
  description = "RDS master credential secret ARN"
  value       = module.database.master_secret_arn
}