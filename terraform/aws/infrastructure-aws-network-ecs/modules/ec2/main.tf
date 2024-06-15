data "aws_ami" "ec2_ami" {
  most_recent = true
  filter {
    name = "name"
    #original ubuntu ami 
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20230208"]
  }
}



resource "aws_instance" "this" {
  ami                         = data.aws_ami.ec2_ami.id
  instance_type               = var.instance_type_value
  associate_public_ip_address = var.associate_public_ip_address
  key_name                    = var.key_name
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.vpc_security_group_ids
  root_block_device {
    volume_size = var.ec2_volume_size
    volume_type = var.ec2_volume_type
  }

  tags = {
    "Name"      = "${var.name}-${var.env}-bastion/cloudflare"
    "Lifecycle" = "dev-snap"
  }
  lifecycle {
    ignore_changes = [tags]
  }
}