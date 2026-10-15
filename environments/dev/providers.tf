provider "aws" {
  region = var.aws_region

  access_key = "test"
  secret_key = "test"

  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    ec2   = "http://localhost:4566"
    elbv2 = "http://localhost:4566"

    elasticloadbalancing = "http://localhost:4566"
    ecs                  = "http://localhost:4566"
    ecr                  = "http://localhost:4566"
    iam                  = "http://localhost:4566"
    rds                  = "http://localhost:4566"
    logs                 = "http://localhost:4566"
    sts                  = "http://localhost:4566"
    acm            = "http://localhost:4566"
    secretsmanager = "http://localhost:4566"
  }

  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
      Owner       = "platform"
    }
  }
}