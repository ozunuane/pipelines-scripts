resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_block
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = title("${var.name}-${var.env}-vpc")
    Environment = "${var.env}"
  }
  lifecycle {
    prevent_destroy = false
  }
}

module "public_subnets" {
  source    = "../subnet"
  vpc_id    = aws_vpc.vpc.id
  env       = var.env
  networks  = var.public_subnets
  is_public = true
  name      = var.name

}

module "private_subnets" {
  source    = "../subnet"
  vpc_id    = aws_vpc.vpc.id
  env       = var.env
  networks  = var.private_subnets
  is_public = false
  name      = var.name
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = title("${var.name}-${var.env}-igw")
    Environment = "${var.env}"
  }
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_eip" "ngw_eip" {
  tags = {
    "Environment" = "${var.name}-${var.env}"
    "Name"        = "${var.name}nat-gt-${var.env}-VPC"
  }
  depends_on = [
    aws_internet_gateway.igw
  ]
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.ngw_eip.id
  subnet_id     = module.public_subnets.subnet_id[0]

  tags = {
    Name        = "${var.env}-vpc-nat-gateway"
    Environment = "${var.env}"
  }
  depends_on = [aws_internet_gateway.igw]
}




module "private_route_table" {
  source     = "../route_table"
  env        = var.env
  name       = var.name
  subnet_ids = module.private_subnets.subnet_id
  gateways   = ["${aws_nat_gateway.ngw.id}:nat_gw"]
  # gateways   = ["${aws_nat_gateway.ngw.id}:nat_gw", "${aws_vpc_peering_connection.staging_to_prod.id}:vpc_peering_connection"]
  #gateways   = ["${aws_network_interface.vpn_public_interface.id}:network_interface", "${aws_nat_gateway.ngw.id}:nat_gw"]
  vpc_id    = aws_vpc.vpc.id
  routes    = var.private_routes
  is_public = false
  depends_on = [
    aws_nat_gateway.ngw,
    aws_internet_gateway.igw,
    # aws_vpc_peering_connection.staging_to_prod
  ]
}




module "public_route_table" {
  source     = "../route_table"
  env        = var.env
  name       = var.name
  subnet_ids = module.public_subnets.subnet_id
  # gateways   = ["${aws_internet_gateway.igw.id}:internet_gw", "${aws_vpc_peering_connection.staging_to_prod.id}:vpc_peering_connection"]
  gateways = ["${aws_internet_gateway.igw.id}:internet_gw"]
  #gateways   = ["${aws_network_interface.vpn_public_interface.id}:network_interface", "${aws_internet_gateway.igw.id}:internet_gw"]
  vpc_id    = aws_vpc.vpc.id
  routes    = var.public_routes
  is_public = true
  depends_on = [
    aws_internet_gateway.igw,
    aws_nat_gateway.ngw,
    # aws_vpc_peering_connection.staging_to_prod
  ]
}


module "private_nacl" {
  source     = "../nacl"
  env        = var.env
  vpc_id     = aws_vpc.vpc.id
  nacl_rules = var.private_nacl_rules
  name       = var.name
  subnet_ids = module.private_subnets.subnet_id[*]
}

module "public_nacl" {
  source     = "../nacl"
  env        = var.env
  vpc_id     = aws_vpc.vpc.id
  nacl_rules = var.public_nacl_rules
  name       = var.name
  subnet_ids = module.public_subnets.subnet_id[*]
  # subnet_ids = split(",", "${join(",", module.private_subnets.subnet_id)},${join(",", module.public_subnets.subnet_id)}")
}






