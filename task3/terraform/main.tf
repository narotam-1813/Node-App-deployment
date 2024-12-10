module "vpc" {
  source = "./vpc"
  vpc_name = "App_vpc"
  vpc_cidr = "10.0.0.0/16"
  public_subnets_cidr = ["10.0.1.0/24", "10.0.2.0/24"]
}

module "ec2" {
  source = "./ec2"
  ami_id = "ami-0c94855ba95c71c99"
  subnet_id = module.vpc.public_subnet_id
  vpc_id = module.vpc.vpc_id
}