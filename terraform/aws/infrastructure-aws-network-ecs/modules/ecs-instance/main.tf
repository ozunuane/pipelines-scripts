data "aws_ami" "ec2_ami" {
  most_recent = true
  filter {
    name = "name"
    #original ubuntu ami 
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20230208"]
  }
}


resource "aws_launch_template" "ecs_lt" {
  name_prefix            = "${var.name}-ecs-template-${var.env}"
  image_id               = data.aws_ami.ec2_ami.image_id
  instance_type          = var.ecs_instance_type
  key_name               = var.ec2_template_key_name
  vpc_security_group_ids = [var.ecs_security_group_id]
  iam_instance_profile {
    name = "${var.name}-ecsInstanceRole-${var.env}"
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = var.ecs_volume_size
      volume_type = var.ecs_volume_type
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "ecs-instance"

    }
  }

  # user_data = <<-EOT
  #   #!/bin/bash
  #   cat <<'EOF' >> /etc/ecs/ecs.config
  #   ECS_CLUSTER=${var.cluster_name}
  #   ECS_LOGLEVEL=debug
  #   ECS_CONTAINER_INSTANCE_TAGS=${jsonencode(local.tags)}
  #   ECS_ENABLE_TASK_IAM_ROLE=true
  #   EOF
  # EOT

}

locals {
  tags = {
    name = var.name
    env  = var.env
  }
}
