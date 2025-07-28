provider "aws" {
  region = var.aws_region
}

module "ecr" {
  source = "./ecr"
}

module "ecs_cluster" {
  source = "./ecs/cluster.tf"
}
