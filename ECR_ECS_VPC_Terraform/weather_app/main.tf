### Create VPc from module

module "vpc" {
  source = "../modules/vpc"

  region                       = var.region
  project_name                 = var.project_name
  vpc_cidr                     = var.vpc_cidr
  public_subnet_az1_cidr       = var.public_subnet_az1_cidr
  public_subnet_az2_cidr       = var.public_subnet_az2_cidr
  private_app_subnet_az1_cidr  = var.private_app_subnet_az1_cidr
  private_app_subnet_az2_cidr  = var.private_app_subnet_az2_cidr
  private_data_subnet_az1_cidr = var.private_data_subnet_az1_cidr
  private_data_subnet_az2_cidr = var.private_data_subnet_az2_cidr
  public_rt_table_cidr         = var.public_rt_table_cidr
}


### Create NAT Gateway from module
module "nat_gateway" {
  source = "../modules/nat-gateway"

  vpc_id                     = module.vpc.vpc_id
  public_subnet_az1_id       = module.vpc.public_subnet_az1_id
  public_subnet_az2_id       = module.vpc.public_subnet_az2_id
  internet_gateway           = module.vpc.internet_gateway
  private_app_subnet_az1_id  = module.vpc.private_app_subnet_az1_id
  private_data_subnet_az1_id = module.vpc.private_data_subnet_az1_id
  private_app_subnet_az2_id  = module.vpc.private_app_subnet_az2_id
  private_data_subnet_az2_id = module.vpc.private_data_subnet_az2_id
}


## Create Security group from module

module "security_group" {
  source = "../modules/security_groups"

  vpc_id = module.vpc.vpc_id
}


## Create ECSTask execution role

module "ecs-task-exe-role" {
  source = "../modules/ecs-task-definition-role"

  project_name = module.vpc.project_name

}


## Create Amazon Certificate
module "acm" {
  source = "../modules/acm"

  domain_name             = var.domain_name
  alternative_domain_name = var.alternative_domain_name
  alb_dns_name            = module.alb.alb_dns_name

}

## Create ALB for this project
module "alb" {
  source = "../modules/alb"

  project_name         = module.vpc.project_name
  alb_sg_id            = module.security_group.alb_sg_id
  public_subnet_az1_id = module.vpc.public_subnet_az1_id
  public_subnet_az2_id = module.vpc.public_subnet_az2_id
  vpc_id               = module.vpc.vpc_id
  certificate_arn      = module.acm.certificate_arn
}


## Create a Cointainer Cluster Service
module "ecs" {
  source = "../modules/ecs"

  project_name                 = module.vpc.project_name
  ecs_tasks_execution_role_arn = module.ecs-task-exe-role.ecs_tasks_execution_role_arn
  docker_image                 = var.docker_image
  region                       = module.vpc.region
  private_app_subnet_az1_id    = module.vpc.private_app_subnet_az1_id
  private_app_subnet_az2_id    = module.vpc.private_app_subnet_az2_id
  ecs_sg_id                    = module.security_group.ecs_sg_id
  alb_target_group_arn         = module.alb.alb_target_group_arn
}
