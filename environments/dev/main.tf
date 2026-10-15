locals {
  name = "${var.project_name}-${var.environment}"

  common_tags = {
    Projet      = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    CostCenter  = "learning"
  }
}

module "networking" {
  #source = "git::https://github.com/system-design-floci-aws/terraform-aws-platform-modules.git//modules/networking?ref=v1.0.0"

  project_name        = var.project_name
  environment         = var.environment
  vpc_cidr            = var.vpc_cidr
  availability_zones  = var.availability_zones
  public_subnets      = var.public_subnets
  private_app_subnets = var.private_app_subnets
  private_db_subnets  = var.private_db_subnets

  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway
  tags               = var.tags
}

module "security_groups" {
  source = "git::https://github.com/system-design-floci-aws/terraform-aws-platform-modules.git//modules/security_groups?ref=v1.0.0"

  vpc_id       = module.networking.vpc_id
  project_name = var.project_name
  environment  = var.environment

  app_port = 8080
  db_port  = 5432

  tags = {
    CostCenter = "learning"
  }
}

module "iam" {
  source = "git::https://github.com/system-design-floci-aws/terraform-aws-platform-modules.git//modules/iam?ref=v1.0.0"

  name = local.name
  tags = local.common_tags
}

############################
# ACN certificate for HTTPS
############################

resource "aws_acm_certificate" "alb_dev" {
  domain_name       = "*.elb.localhost.floci.io"
  validation_method = "DNS"

  tags = {
    Name        = "${var.project_name}-${var.environment}-alb-cert"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

module "alb" {
  source = "git::https://github.com/system-design-floci-aws/terraform-aws-platform-modules.git//modules/alb?ref=v1.0.0"

  name = local.name

  vpc_id            = module.networking.vpc_id
  public_subnet_ids = module.networking.public_subnet_ids
  security_group_id = module.security_groups.alb_security_group_id

  app_port = 8080
  
  certificate_arn   = aws_acm_certificate.alb_dev.arn

  tags     = local.common_tags
}

module "ecr" {
  source = "git::https://github.com/system-design-floci-aws/terraform-aws-platform-modules.git//modules/ecr?ref=v1.0.0"

  name = "${local.name}-python-app"
  tags = local.common_tags
}

module "database" {
  source = "git::https://github.com/system-design-floci-aws/terraform-aws-platform-modules.git//modules/database/postgreSQL?ref=v1.0.0"
  name = local.name

  subnet_group_name = (
    module.networking.database_subnet_group_name
  )

  security_group_id = (
    module.security_groups.db_security_group_id
  )

  db_username = "appadmin"

  tags = local.common_tags
}

module "ecs" {
  source = "git::https://github.com/system-design-floci-aws/terraform-aws-platform-modules.git//modules/ecs?ref=v1.0.0"

  name       = local.name
  aws_region = var.aws_region

  private_subnet_ids = (
    module.networking.private_app_subnet_ids
  )

  security_group_id = (
    module.security_groups.app_security_group_id
  )
  target_group_arn = module.alb.target_group_arn

  execution_role_arn = module.iam.execution_role_arn
  task_role_arn      = module.iam.task_role_arn

  image = "${module.ecr.repository_url}:v1"

  app_port      = 8080
  desired_count = 0

  tags = local.common_tags

  # ensure execution policy attachment is created first
  depends_on = [module.iam]
}