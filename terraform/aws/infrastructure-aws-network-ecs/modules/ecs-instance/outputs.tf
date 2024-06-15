output "ecs_instance_tmp_id" {
  value = aws_launch_template.ecs_lt.id
}



output "ecs_instance_tmp_arn" {
  value = aws_launch_template.ecs_lt.arn
}


output "ecs_instance_tmp_arn_key" {
  value = aws_launch_template.ecs_lt.key_name
}

output "ecs_instance_tmp_ami" {
  value = aws_launch_template.ecs_lt.image_id
}


output "ecs_instance_tmp_instance_type" {
  value = aws_launch_template.ecs_lt.instance_type
}

output "ecs_tags" {
  value = aws_launch_template.ecs_lt.tags
}