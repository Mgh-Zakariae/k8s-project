provider "aws" {
  region = "eu-north-1"
}

module "vpc" {
  source = "./modules/vpc"
}

module "redis_instance" {
  source             = "./modules/redis"
  private_subnet_ids = module.vpc.private_subnet_ids
  redis_sg_id        = module.vpc.redis_sg_id
}

module "web_app_instance" {
  source            = "./modules/ec2"
  webapp_sg_id      = module.vpc.webapp_sg_id
  public_subnet_ids = module.vpc.public_subnet_ids
  redis_host        = module.redis_instance.redis_endpoint
  image_tag         = var.image_tag
}

output "redis_endpoint" {
  value = module.redis_instance.redis_endpoint
}

output "app_public_ip" {
  value = module.web_app_instance.app_ip
}

output "deployed_image_tag" {
  value = var.image_tag
}